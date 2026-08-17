
/* ============================================================================
   Module: configs/js_config_main.sas
   Description: Main configuration assembler - includes all domain configurations
   Dependencies: js_helpers.sas (must be included before this file)
   Includes: js_config_dashboard.sas, js_config_reports.sas, js_config_api.sas
   ============================================================================ */

/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\config\dashboard\dashboardTableConfig.sas";
%include "C:\Users\62917\ERMS\config\regulatoryReports\regulatoryReportsConfig.sas";
%include "C:\Users\62917\ERMS\config\riskModule\riskModulesConfig.sas";
%include "C:\Users\62917\ERMS\config\reportDownload\reportDownload.sas";
%include "C:\Users\62917\ERMS\config\api\apiEndpoints.sas";

/* Risk Appetite Framework (CRO-only section) - added without touching any line above */
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\index.sas";

/* ============================================================================
   Main Macro: Generate All Configurations
   Generates all domain configurations in the correct order
   ============================================================================ */
%macro erms_config_new;
    
    /* Generate Dashboard Domain Configurations */
    %dashboardTableConfig;
     
    /* Generate Reports Domain Configurations */
    %riskModulesConfig;

    %regulatoryReportsConfig;

    %reportDownloadMetadata;

    %apiEndpoints;

    /* Risk Appetite Framework (CRO-only section) - added without touching any line above */
    %raf_config_new;

%mend erms_config_new;
