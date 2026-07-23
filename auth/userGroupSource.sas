
/* ============================================================================
   USER GROUP SOURCE, MOCK - stand-in for SAS Management Console
   ============================================================================ */

%macro build_mock_user_groups;
    /* Sample roster only - replace/extend freely while SMC groups don't
       exist yet. One row per user, group membership; a user can belong
       to more than one group. */
       
    data work.mock_user_groups;
        length erms_user $32 smc_group $64;
        input erms_user $ smc_group $;
        datalines;
62917 ERMS_Market_Risk_Analysts
62917 ERMS_Credit_Risk_Analysts
70001 ERMS_Credit_Risk_Analysts
70002 ERMS_Operational_Risk_Analysts
70003 ERMS_Regulatory_Reporting
70004 ERMS_Liquidity_Risk_Analysts
70005 ERMS_Capital_Planning
70006 ERMS_Liquidity_Planning
;
    run;
%mend build_mock_user_groups;

%macro fetch_user_groups(user=);

    %global USER_GROUPS_RAW;
    %let USER_GROUPS_RAW=;

    %build_mock_user_groups;

    proc sql noprint;
        select distinct smc_group into :USER_GROUPS_RAW separated by ' '
        from work.mock_user_groups
        where upcase(erms_user) = upcase("&user");
    quit;

    %let USER_GROUPS_RAW = %sysfunc(strip(&USER_GROUPS_RAW));

%mend fetch_user_groups;
