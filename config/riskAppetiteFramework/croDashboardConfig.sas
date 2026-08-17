/* ============================================================================
   CRO DASHBOARD CONFIGURATION
   Drives 2 of the CRO Dashboard's zones (reached via the navbar's Dashboard
   dropdown -> CRO Dashboard -> RAF - Risk Appetite Framework): Heatmap by
   Criticality and Treemap by Ownership - plus the (currently unused) KPI
   strip. (Critical Risk Indicators/Zone 1 is built client-side straight off
   appetiteMetricsConfig - see croDashboardView.sas - so it needs no entry
   here. Trend Analysis by Pillar has been removed along with its tab - not
   currently required; see buildRAF.sas/croDashboardView.sas/
   rafDashboardAggregates.sas for the matching removal.)

   NOW DATA-DRIVEN off work.raf_metrics_final wherever the sheet has the
   answer: KPI counts and the NEWEST period of the Heatmap/Treemap zones are
   all real, computed by rafDashboardAggregates.sas. RAF_Q2_2026.xlsx has
   exactly one reporting period, so the 3 "prior period" columns those 2
   zones display have no real data to compute from - each is the SAME
   group's real current count copied forward, clearly commented at its
   build site in rafDashboardAggregates.sas as the swap-in point for when a
   real period-over-period backend exists. `isPlaceholderData: true`
   reflects that those prior-period columns are still illustrative.

   No visual/interaction change versus before - croDashboardView.sas's
   render functions already consume this exact shape; only what builds the
   data changed. Uses a DO/SET-POINT= loop, not a nested DATA step - see
   riskDomainsConfig.sas's header for why.

   POINT= is always given as a variable (_raf_pt), never a bare numeric
   literal (not even "point=1") - every other emitting macro in this app
   (riskDomainsConfig.sas/riskCategoriesConfig.sas/appetiteMetricsConfig.sas)
   already does it this way inside their DO-loops; raf_kpi_final and
   raf_treemap_final are each exactly one row, so no loop is needed here,
   but POINT= still takes a variable set to 1 rather than the literal 1.
   ============================================================================ */
%macro croDashboardConfig;
    put 'const croDashboardConfig = Object.freeze({';
    put '  isPlaceholderData: true,';

    _raf_pt = 1;
    set work.raf_kpi_final point=_raf_pt;
    put js_line $varying500. js_len @;
    put ',';

    put '  heatmapByCriticality: [';
    %if %eval(&RAF_CRITICALITY_NOBS. > 0) %then %do;
        do _raf_hc = 1 to &RAF_CRITICALITY_NOBS.;
            set work.raf_criticality_final point=_raf_hc;
            put js_line $varying6000. js_len @;
            if _raf_hc < &RAF_CRITICALITY_NOBS. then put ',';
            else put;
        end;
    %end;
    put '  ],';

    _raf_pt = 1;
    set work.raf_treemap_final point=_raf_pt;
    put opts_line $varying8100. opts_len @;
    put ',';
    put treemap_line $varying8100. treemap_len;

    put '});';
%mend croDashboardConfig;
