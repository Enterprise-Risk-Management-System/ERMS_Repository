
/* ============================================================================
   Module: config/riskAppetiteFramework/index.sas
   Description: Includes the Risk Appetite Framework's config modules and
   bundles them into %raf_config_new. NEW module, added to ERMS to embed the
   CRO-only Risk Appetite Framework section - does not modify any existing
   ERMS config file. Paths below match the existing codebase's convention
   (C:\Users\62917\ERMS\...) so they update together with every other
   %include in this project on real deployment.
   ============================================================================ */

/* Reads RAF_Q2_2026.xlsx and builds the work.raf_* datasets the 3 configs
   below loop over - must be %include'd here (so %raf_load_excel_data is
   defined) but is CALLED separately, once, before ERMS_Application.sas's
   big data _null_ step starts - see that macro's own header for why, and
   ERMS_Application.sas for the call site. */
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\rafDataLoader.sas";

/* Aggregates work.raf_metrics_final into what croDashboardConfig.sas loops
   over for the CRO Dashboard's Heatmap/Treemap/Trend/KPI zones - see that
   file's own header. %raf_build_dashboard_aggregates is called from
   %raf_load_excel_data (rafDataLoader.sas), right after the domain/category
   aggregation it depends on. */
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\rafDashboardAggregates.sas";

%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\riskDomainsConfig.sas";
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\riskCategoriesConfig.sas";
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\appetiteMetricsConfig.sas";
%include "C:\Users\62917\ERMS\config\riskAppetiteFramework\croDashboardConfig.sas";

%macro raf_config_new;

    %riskDomainsConfig;

    %riskCategoriesConfig;

    %appetiteMetricsConfig;

    %croDashboardConfig;

%mend raf_config_new;
