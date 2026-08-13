
/* ============================================================================
   Module: config/riskAppetiteFramework/index.sas
   Description: Includes the Risk Appetite Framework's config modules and
   bundles them into %raf_config_new. NEW module, added to ERMS to embed the
   CRO-only Risk Appetite Framework section - does not modify any existing
   ERMS config file. Paths below match the existing codebase's convention
   (C:\Users\62917\ERMS\...) so they update together with every other
   %include in this project on real deployment.
   ============================================================================ */

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
