%macro erms_timer_start(tag=req);
    %global ERMS_T_&tag;
    %let ERMS_T_&tag = %sysfunc(datetime());
%mend erms_timer_start;

%macro erms_timer_elapsed(tag=req);
    %local now;
    %let now = %sysfunc(datetime());
    %if %symexist(ERMS_T_&tag) %then %sysevalf(&now - &&ERMS_T_&tag);
    %else 0;
%mend erms_timer_elapsed;

%macro erms_log_event(endpoint=, phase=, status=OK, rows=, detail=, tag=req);

    %local elapsed;
    %if not %symexist(ERMS_LOG_FILE) %then %erms_infra_config;
    %let elapsed = %sysfunc(putn(%erms_timer_elapsed(tag=&tag), 12.3));

    data _null_;
        length line $1000;
        line = put(datetime(), is8601dt.) || ',' ||
               strip("&sysuserid") || ',' ||
               strip("&sysjobid") || ',' ||
               strip("&endpoint") || ',' ||
               strip("&phase") || ',' ||
               strip("&status") || ',' ||
               strip("&elapsed") || ',' ||
               strip("&rows") || ',' ||
               quote(strip("&detail"));
        file "&ERMS_LOG_FILE" mod lrecl=1200;
        put line;
    run;

%mend erms_log_event;
