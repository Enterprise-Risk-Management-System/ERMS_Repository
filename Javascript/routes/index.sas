
/* ============================================================================
   Module: configs/js_config_main.sas
   Description: Main configuration assembler - includes all domain configurations
   Dependencies: js_helpers.sas (must be included before this file)
   Includes: js_config_dashboard.sas, js_config_reports.sas, js_config_api.sas
   ============================================================================ */

/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\Javascript\routes\dashboards\index.sas";


/* Include all domain configuration modules */
%include "C:\Users\62917\ERMS\Javascript\routes\riskCategories\index.sas";

/* Risk Appetite Framework (CRO-only section) - added without touching any line above */
%include "C:\Users\62917\ERMS\Javascript\routes\riskAppetiteFramework\index.sas";


%macro Routes;

	%buildDashboardTable;

	%buildRiskCategories;

	%buildAnalyticsDash;

	%regulatoryReports;

	%Saibor;

	/* Risk Appetite Framework (CRO-only section) - added without touching any line above */
	%RAF_Routes;

%mend Routes;



	
	
