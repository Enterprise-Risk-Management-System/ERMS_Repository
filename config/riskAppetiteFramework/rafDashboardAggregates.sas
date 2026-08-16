/* ============================================================================
   CRO DASHBOARD AGGREGATES  (NEW module)
   Builds the datasets croDashboardConfig.sas loops over, straight off the
   already-parsed/classified work.raf_metrics_final (see rafDataLoader.sas -
   this file adds no new parsing, it only groups/counts columns that step
   already computed: status, criticality, ownership, comments).

   REAL vs. DUMMY, per zone (the sheet has exactly one reporting period,
   Q2-2026 - see the plan discussed with the business owner):
     - KPI strip, the NEWEST period of Zone 2 (Heatmap by Criticality), the
       NEWEST period of Zone 3 (Treemap by Ownership), and the NEWEST point
       of Zone 4 (Trend by Pillar) are all computed for real from the sheet.
     - The other 3 "prior period" columns in Zones 2/3/4 have no real data
       to compute from (one period exists) - each is a flat copy-forward of
       that same group's real current counts, clearly commented at each
       site below as the swap-in point for when a real period-over-period
       backend exists. Nothing here is a fabricated per-group number; it is
       the real current count, repeated, until real history exists.
   ============================================================================ */
%macro raf_build_dashboard_aggregates;

    /* ---- KPI strip (currently unused by any render function, but kept
       real/derived rather than hand-typed, same "don't hardcode what the
       sheet already gives you" rule applied everywhere else in RAF) ---- */
    proc sql noprint;
        select sum(status='green'), sum(status='amber'), sum(status='red'), count(*)
            into :raf_kpi_green trimmed, :raf_kpi_amber trimmed, :raf_kpi_red trimmed, :raf_kpi_total trimmed
            from work.raf_metrics_final;
    quit;

    data work.raf_kpi_final;
        length js_line $500;
        _g = input("&raf_kpi_green.", ?? best.); _a = input("&raf_kpi_amber.", ?? best.);
        _r = input("&raf_kpi_red.", ?? best.); _t = input("&raf_kpi_total.", ?? best.);
        if missing(_g) then _g = 0; if missing(_a) then _a = 0;
        if missing(_r) then _r = 0; if missing(_t) then _t = 0;
        _pct = ifn(_t > 0, round(_g / _t * 100, 0.1), 0);
        js_line = 'kpi: { withinAppetitePct: ' || strip(put(_pct,8.1)) || ', withinAppetiteCount: ' || strip(put(_g,best.-L))
          || ', watchCount: ' || strip(put(_a,best.-L)) || ', breachCount: ' || strip(put(_r,best.-L))
          || ', totalCount: ' || strip(put(_t,best.-L)) || ' }';
        js_len = length(js_line);
        keep js_line js_len;
    run;

    /* ---- Zone 2: Heatmap by Criticality - one row per distinct
       Criticality Level present, real Green/Amber/Red counts for the
       current period. ---- */
    proc sql;
        create table work._raf_crit_counts as
        select criticality,
               sum(status='green') as n_green, sum(status='amber') as n_amber,
               sum(status='red') as n_red, count(*) as n_total
        from work.raf_metrics_final
        group by criticality
        order by criticality;
    quit;

    data work.raf_criticality_final;
        length js_line $2000 _cur $300;
        set work._raf_crit_counts;
        _cur = '{date:"2026-06-30",good:' || strip(put(n_green,best.-L)) || ',watch:' || strip(put(n_amber,best.-L))
          || ',breach:' || strip(put(n_red,best.-L)) || ',trend:"up"}';
        /* SWAP-IN POINT: the 3 lines below are the same real current counts
           copied forward as illustrative stand-ins for 2026-03-31,
           2025-12-31 and 2025-09-30 - replace with a real historical query
           once one exists; nothing else in this file or in
           croDashboardView.sas needs to change to do that. */
        js_line = '{ criticality: "' || strip(criticality) || '", totalIndicators: ' || strip(put(n_total,best.-L))
          || ', periods: [' || strip(_cur)
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2026-03-31')
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2025-12-31')
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2025-09-30')
          || '] }';
        js_len = length(js_line);
        keep js_line js_len;
    run;

    /* ---- Zone 3: Treemap by Ownership - ownershipOptions is the real
       distinct Ownership list (not a hardcoded 4); real Green/Amber/Red
       counts per owner for the current period. Same copy-forward
       placeholder treatment as Zone 2 for the 3 prior periods. ---- */
    proc sql;
        create table work._raf_own_counts as
        select ownership,
               sum(status='green') as n_green, sum(status='amber') as n_amber,
               sum(status='red') as n_red
        from work.raf_metrics_final
        group by ownership
        order by ownership;
    quit;

    data work._raf_own_rows;
        length js_line $2000 opt_js $2000 _cur $300;
        set work._raf_own_counts;
        _cur = '{date:"2026-06-30",good:' || strip(put(n_green,best.-L)) || ',watch:' || strip(put(n_amber,best.-L))
          || ',breach:' || strip(put(n_red,best.-L)) || '}';
        opt_js = '"' || strip(ownership) || '"';
        /* SWAP-IN POINT - see the matching note in raf_criticality_final above. */
        js_line = '"' || strip(ownership) || '": [' || strip(_cur)
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2026-03-31')
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2025-12-31')
          || ',' || tranwrd(strip(_cur), '2026-06-30', '2025-09-30')
          || ']';
        js_len = length(js_line);
        keep js_line js_len opt_js;
    run;

    data work.raf_treemap_final;
        length _opts $8000 _body $8000 opts_line $8100 treemap_line $8100;
        retain _opts _body;
        set work._raf_own_rows end=eof;
        _opts = catx(',', _opts, opt_js);
        _body = catx(',', _body, js_line);
        if eof then do;
            opts_line = 'ownershipOptions: [' || strip(_opts) || ']';
            treemap_line = 'treemapByOwnership: {' || strip(_body) || '}';
            opts_len = length(opts_line);
            treemap_len = length(treemap_line);
            output;
        end;
        keep opts_line opts_len treemap_line treemap_len;
    run;

    /* ---- Zone 4: Trend by Pillar - Pillar 1 / Pillar 2 = metrics whose
       sheet Comments column is literally "P1" / "P2" (a real column, same
       tag already shown as the metric-card chip - see
       appetiteMetricsConfig.sas). Real current watch+breach (amber+red)
       count per pillar; same copy-forward placeholder treatment for the 3
       prior points (a trend line needs multiple real periods, which this
       sheet does not have yet - matches the "insufficient history -> use
       dummy for demonstration" rule agreed with the business owner). ---- */
    proc sql noprint;
        select sum((comments='P1') and status in ('amber','red')),
               sum((comments='P2') and status in ('amber','red'))
            into :raf_p1_wb trimmed, :raf_p2_wb trimmed
            from work.raf_metrics_final;
    quit;

    data work.raf_pillar_final;
        length js_line $1000;
        _p1 = input("&raf_p1_wb.", ?? best.); _p2 = input("&raf_p2_wb.", ?? best.);
        if missing(_p1) then _p1 = 0; if missing(_p2) then _p2 = 0;
        js_line = 'trendByPillar: { periods: ["2025-09-30","2025-12-31","2026-03-31","2026-06-30"], '
          || 'pillar1WatchBreachCount: [' || strip(put(_p1,best.-L)) || ',' || strip(put(_p1,best.-L))
          || ',' || strip(put(_p1,best.-L)) || ',' || strip(put(_p1,best.-L)) || '], '
          || 'pillar2WatchBreachCount: [' || strip(put(_p2,best.-L)) || ',' || strip(put(_p2,best.-L))
          || ',' || strip(put(_p2,best.-L)) || ',' || strip(put(_p2,best.-L)) || '] }';
        js_len = length(js_line);
        keep js_line js_len;
    run;

    %global RAF_CRITICALITY_NOBS;
    proc sql noprint;
        select count(*) into :RAF_CRITICALITY_NOBS trimmed from work.raf_criticality_final;
    quit;

%mend raf_build_dashboard_aggregates;
