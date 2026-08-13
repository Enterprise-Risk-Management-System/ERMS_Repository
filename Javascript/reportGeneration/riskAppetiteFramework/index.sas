
/* ============================================================================
   Module: Javascript/reportGeneration/riskAppetiteFramework/index.sas
   Description: Includes the Risk Appetite Framework's report-generation
   modules and bundles them into %RAF_Report_Generation. NEW module - does
   not modify any existing ERMS reportGeneration file.
   ============================================================================ */

%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\raUtils.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\raStatus.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\appetiteResultsView.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\croDashboardView.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\dashboardTableTools.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\reportHistory.sas";
%include "C:\Users\62917\ERMS\Javascript\reportGeneration\riskAppetiteFramework\appetiteReportGeneration.sas";

%macro RAF_Report_Generation;

    %generate_raf_utils;

    %generate_javascript_rastatus;

    %generate_appetite_results_view;

    %generate_cro_dashboard_view;

    %generate_dashboard_table_tools;

    %generate_report_history;

    %generate_appetite_report_generation;

%mend RAF_Report_Generation;
