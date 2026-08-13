


/* ============================================================================
   Module: configs/js_config_main.sas
   Description: Main configuration assembler - includes all domain configurations
   Dependencies: js_helpers.sas (must be included before this file)
   Includes: js_config_dashboard.sas, js_config_reports.sas, js_config_api.sas
   ============================================================================ */

/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\regulatoryReports\regulatoryReportGeneration.sas";

/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\saibor\saiborReportGeneration.sas";

/* Risk Appetite Framework (CRO-only section) - added without touching any line above */
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\index.sas";



%macro Report_Generation;

	%regulatoryReportGeneration;

	%saiborReportGeneration;

	/* Risk Appetite Framework (CRO-only section) - added without touching any line above */
	%RAF_Report_Generation;

%mend Report_Generation;


