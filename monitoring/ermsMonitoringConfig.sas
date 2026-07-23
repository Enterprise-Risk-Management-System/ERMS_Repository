/* Need to set or change only one folder path in this configuration file wchich is ERMS_INFRA_ROOT. 
All the other required paths where cache files and log files get saved will automatically update themselves based on that main master folder.
Safe to Run Multiple Times : Idempotent */

%macro erms_infra_config;

    %local _rc;
    %global ERMS_INFRA_ROOT ERMS_CACHE_ROOT ERMS_LOG_ROOT ERMS_LOG_FILE;

    %let ERMS_INFRA_ROOT = TODO_SET_WRITABLE_PATH;
    %let ERMS_CACHE_ROOT = &ERMS_INFRA_ROOT.\cache;
    %let ERMS_LOG_ROOT   = &ERMS_INFRA_ROOT.\logs;
    %let ERMS_LOG_FILE   = &ERMS_LOG_ROOT.\erms_monitor.log;

    %if %sysfunc(fileexist("&ERMS_CACHE_ROOT")) = 0 %then
        %let _rc = %sysfunc(dcreate("cache", "&ERMS_INFRA_ROOT"));
    %if %sysfunc(fileexist("&ERMS_LOG_ROOT")) = 0 %then
        %let _rc = %sysfunc(dcreate("logs", "&ERMS_INFRA_ROOT"));

%mend erms_infra_config;



