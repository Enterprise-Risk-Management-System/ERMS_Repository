%macro erms_cache_lib;
    %if not %symexist(ERMS_CACHE_ROOT) %then %erms_infra_config;
    libname ermscach "&ERMS_CACHE_ROOT";
%mend erms_cache_lib;

%macro erms_file_modtime(path);
    %local fref rc fid modtime;
    %let modtime = ;
    %let rc  = %sysfunc(filename(fref, "%superq(path)"));
    %let fid = %sysfunc(fopen(&fref));
    %if &fid > 0 %then %do;
        %let modtime = %sysfunc(finfo(&fid, Last Modified));
        %let rc = %sysfunc(fclose(&fid));
    %end;
    %let rc = %sysfunc(filename(fref));
    &modtime
%mend erms_file_modtime;

%macro erms_cache_lock(key=, ttl=120, tries=6);
    %local lockdir rc i got stamp now age;
    %let lockdir = &ERMS_CACHE_ROOT.\lock_&key;
    %let got = 0;

    %do i = 1 %to &tries;
        %let rc = %sysfunc(dcreate("lock_&key", "&ERMS_CACHE_ROOT"));
        %if %length(&rc) > 0 %then %do;
            data _null_; file "&lockdir.\owner.txt"; put "%sysfunc(datetime())"; run;
            %let got = 1;
            %let i = &tries;
        %end;
        %else %do;
            %let stamp = 0;
            %if %sysfunc(fileexist("&lockdir.\owner.txt")) %then %do;
                data _null_; infile "&lockdir.\owner.txt"; input stamp; call symputx('stamp', stamp); run;
            %end;
            %let now = %sysfunc(datetime());
            %let age = %sysevalf(&now - &stamp);
            %if %sysevalf(&age > &ttl) %then %erms_cache_unlock(key=&key);
            %else %let rc = %sysfunc(sleep(0.5, 1));
        %end;
    %end;
    &got
%mend erms_cache_lock;

%macro erms_cache_unlock(key=);
    %local lockdir fref rc;
    %let lockdir = &ERMS_CACHE_ROOT.\lock_&key;
    %if %sysfunc(fileexist("&lockdir.\owner.txt")) %then %do;
        %let rc = %sysfunc(filename(fref, "&lockdir.\owner.txt"));
        %let rc = %sysfunc(fdelete(&fref));
        %let rc = %sysfunc(filename(fref));
    %end;
    %if %sysfunc(fileexist("&lockdir")) %then %do;
        %let rc = %sysfunc(filename(fref, "&lockdir"));
        %let rc = %sysfunc(fdelete(&fref));
        %let rc = %sysfunc(filename(fref));
    %end;
%mend erms_cache_unlock;

%macro erms_refresh_if_changed(key=, source_file=, import_macro=, stage_ds=, out_ds=);

    %erms_cache_lib;
    %local cur_mod prev_mod need lockok nrows w rc;

    %let cur_mod = %erms_file_modtime(&source_file);

    %let prev_mod = ;
    %if %sysfunc(exist(ermscach.refresh_markers)) %then %do;
        proc sql noprint;
            select source_modtime into :prev_mod trimmed
            from ermscach.refresh_markers where cache_key = "&key";
        quit;
    %end;

    %let need = 0;
    %if not %sysfunc(exist(&out_ds)) %then %let need = 1;
    %else %if %superq(cur_mod) ne %superq(prev_mod) %then %let need = 1;

    %if &need = 0 %then %do;
        %erms_log_event(endpoint=&key, phase=cache_hit);
        %return;
    %end;

    %let lockok = %erms_cache_lock(key=&key);
    %if &lockok ne 1 %then %do;
        %if %sysfunc(exist(&out_ds)) %then
            %erms_log_event(endpoint=&key, phase=cache_hit, status=SERVED_STALE);
        %else %do;
            %do w = 1 %to 20;
                %if %sysfunc(exist(&out_ds)) %then %let w = 20;
                %else %let rc = %sysfunc(sleep(0.5, 1));
            %end;
            %erms_log_event(endpoint=&key, phase=cache_hit, status=WAITED_COLD);
        %end;
        %return;
    %end;

    %erms_log_event(endpoint=&key, phase=cache_miss, detail=source changed);

    %&import_macro;

    data &out_ds; set &stage_ds; run;

    %let nrows = 0;
    %if %sysfunc(exist(&out_ds)) %then %do;
        proc sql noprint; select count(*) into :nrows trimmed from &out_ds; quit;
    %end;

    %if &nrows > 0 %then %do;
        data work._erms_marker;
            length cache_key $32 source_modtime $60;
            cache_key = "&key";  source_modtime = "&cur_mod";
            last_import_dt = datetime();  last_rows = &nrows;
            format last_import_dt datetime20.;
        run;
        %if %sysfunc(exist(ermscach.refresh_markers)) %then %do;
            proc sql noprint; delete from ermscach.refresh_markers where cache_key = "&key"; quit;
        %end;
        proc append base=ermscach.refresh_markers data=work._erms_marker force; run;

        %erms_cache_unlock(key=&key);
        %erms_log_event(endpoint=&key, phase=import, status=OK, rows=&nrows);
    %end;
    %else %do;
        %erms_cache_unlock(key=&key);
        %erms_log_event(endpoint=&key, phase=import, status=ERROR, rows=0, detail=import produced zero rows - marker not saved);
    %end;

%mend erms_refresh_if_changed;
