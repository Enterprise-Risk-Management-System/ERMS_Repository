
/* ============================================================================
   SMC GROUP -> ERMS CATEGORY MAPPING
   ----------------------------------------------------------------------------
   Single source of truth translating raw SMC group names into the risk
   category keys already used by config/riskModule/riskModulesConfig.sas and
   components/components.sas (generate_sidebar): regulatory, credit,
   operational, market, liquidity, icaap, ilaap.

   If an SMC group gets renamed, or a new group is added, this is the only
   file that changes - riskModulesConfig.sas, the sidebar, and
   resolveUserAccess.sas all read category keys, never raw SMC group names.
   ============================================================================ */

%macro groupCategoryMapping;
    proc format;
        value $groupcat
            "ERMS_Regulatory_Reporting"        = "regulatory"
            "ERMS_Credit_Risk_Analysts"        = "credit"
            "ERMS_Operational_Risk_Analysts"   = "operational"
            "ERMS_Market_Risk_Analysts"        = "market"
            "ERMS_Liquidity_Risk_Analysts"     = "liquidity"
            "ERMS_Capital_Planning"            = "icaap"
            "ERMS_Liquidity_Planning"          = "ilaap"
            other                              = " "
        ;
    run;
%mend groupCategoryMapping;

/* Category keys every user sees regardless of SMC group membership.
   Add more keys here (space-separated) if another card becomes universal. */
%macro alwaysVisibleCategories;
saibor
%mend alwaysVisibleCategories;
