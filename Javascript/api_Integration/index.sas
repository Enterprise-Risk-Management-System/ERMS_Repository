


/* ============================================================================
   Module: configs/js_config_main.sas
   Description: Main configuration assembler - includes all domain configurations
   Dependencies: js_helpers.sas (must be included before this file)
   Includes: js_config_dashboard.sas, js_config_reports.sas, js_config_api.sas
   ============================================================================ */

/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\Javascript\api_integration\croDashboard\cro_dashboard_api.sas";



%macro Api_Integrations;

	%cro_Dashboard_Api_Integ;

%mend Api_Integrations;


