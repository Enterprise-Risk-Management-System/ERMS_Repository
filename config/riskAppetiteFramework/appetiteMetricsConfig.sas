/* ============================================================================
   APPETITE METRICS CONFIGURATION
   Every Risk Indicator row from RAF_Q2_2026.xlsx, grouped by Risk Area
   (category key - matches riskCategoriesConfig.sas). Single source of
   truth for every metric shown anywhere in the app (category detail
   meters, CRO Dashboard Zone 1 cards, the heatmap and treemap zones).

   NOW FULLY DYNAMIC: each metric object below is emitted verbatim from
   work.raf_metrics_final's pre-built `js_line` (one row per Risk Indicator,
   sorted by category then S.No), built by rafDataLoader.sas straight from
   the live sheet on this run. See that file's header for exactly how each
   field is derived - in short:

     thresholds        - { green, amber, red, regulatory } parsed straight
                         off the sheet's own cells, as decimals (0.02 = 2%);
                         null for any tier the sheet left blank/unparseable.
     thresholdOps      - { green, amber, red, regulatory } the comparison
                         sign (">=","<=",">","<") each tier was tested with -
                         either read straight off the cell, or (for a
                         sign-less plain number) inferred from that row's
                         own Green/Amber/Red ordering.
     status             - "green" | "amber" | "red", already evaluated by
                         testing Utilization against Green's own condition
                         first, then Amber's, then Red's (first match wins).
     currentValue       - Utilization Q2-2026, verbatim off the sheet.
     meter               - precomputed threshold-band + pointer geometry
                         (percent positions, already clamped to the visible
                         track) - see RAFStatus/RAFResults for how the UI
                         consumes it.

   No metric-specific value, range, classification or colour is written
   literally in this file - every `key: [` group and every metric object
   below comes from the dataset built by %raf_load_excel_data.

   Uses a DO/SET-POINT= loop, not a nested DATA step - see
   riskDomainsConfig.sas's header for why.
   ============================================================================ */
%macro appetiteMetricsConfig;
    length _raf_prevcat $80 _raf_catline $100 _raf_catline_len 8;
    put 'const appetiteMetricsConfig = Object.freeze({';
    %if %eval(&RAF_METRIC_NOBS. > 0) %then %do;
        _raf_prevcat = '';
        do _raf_i = 1 to &RAF_METRIC_NOBS.;
            set work.raf_metrics_final point=_raf_i;
            if category_key ne _raf_prevcat then do;
                if _raf_i > 1 then put '  ],';
                /* category_key is quoted here - it's a slug derived from the
                   sheet's own Risk Area text (e.g. "concentration-risk") and
                   routinely contains hyphens, which are illegal in a bare/
                   unquoted JS object-literal key. */
                _raf_catline = '  "' || strip(category_key) || '": [';
                _raf_catline_len = length(_raf_catline);
                put _raf_catline $varying100. _raf_catline_len;
            end;
            else put ',';
            put js_line $varying6000. js_len @;
            put;
            _raf_prevcat = category_key;
        end;
        put '  ]';
    %end;
    put '});';
%mend appetiteMetricsConfig;
