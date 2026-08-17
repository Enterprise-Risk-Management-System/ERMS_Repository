/* ============================================================================
   RAF CRO DASHBOARD VIEW MODULE
   Renders the CRO Dashboard's zones from croDashboardConfig.sas: Critical
   Risk Indicators (Zone 1), Heatmap by Criticality (Zone 2), Treemap by
   Ownership (Zone 3). (Trend Analysis by Pillar / Zone 4 has been removed -
   not currently required; see buildRAF.sas/croDashboardConfig.sas/
   rafDashboardAggregates.sas for the matching removal.)
   Kept separate from the route builder (buildCroDashboard.sas), which only
   assembles the filter bar + zone shells - this file renders the
   data-driven parts, mirroring the reference app's separation between a
   route builder and its results view.
   ============================================================================ */
%macro generate_cro_dashboard_view;
    put '// RAF CRO Dashboard View Module';

    /* Zone 1: Critical Risk Indicators - a small, business-curated set of
       featured metrics ("critical" here means "marked for CRO visibility",
       not a Criticality Level rollup - Criticality Level is its own real
       sheet column, already used elsewhere, e.g. the metric-card chip and
       Zone 2's heatmap rows). The 6 {category, id} pairs below are the only
       hand-picked thing about this zone - every value/status/label shown
       for them is looked up live from appetiteMetricsConfig, so nothing
       metric-specific is hardcoded, only WHICH 6 metrics are featured. A
       pair that no longer resolves (e.g. an id changed upstream) is simply
       skipped, not a broken card. */
    put 'const RAF_CRITICAL_INDICATORS = [';
    put '  { category: "liquidity-risk", id: "liquidity-coverage-ratio-lcr" },';
    put '  { category: "capital", id: "total-capital-by-rwa-pillar-1-pillar-2" },';
    put '  { category: "market-risk", id: "value-at-risk-var" },';
    put '  { category: "interest-rate-in-the-banking-book-irrbb", id: "economic-value-of-equity-eve" },';
    put '  { category: "credit-risk", id: "non-performing-loans-npl-ratio-total" },';
    put '  { category: "liquidity-risk", id: "net-stability-funding-ratio-nsfr" }';
    put '];';

    put 'const RAFDashboardView = {';

    /* Reporting-date row = the sheet''s one real period plus 2 placeholder
       rows (same real current value/status copied forward) - identical
       convention to the Heatmap/Treemap "SWAP-IN POINT" pattern in
       rafDashboardAggregates.sas, applied here in JS since this zone''s
       card content is looked up client-side rather than pre-aggregated in
       SAS. Swap to real history later by replacing this loop''s per-period
       lookup without touching the card markup. */
    put '  // Zone 1: renders the 6 curated Critical Risk Indicator cards. Real';
    put '  // value/status for the sheet''s one period, on all 3 displayed rows -';
    put '  // see the file header note above for why.';
    put '  renderCriticalIndicators() {';
    put '    const periods = ["2026-06-30", "2026-03-31", "2025-12-31"];';
    put '    let html = "";';
    put '    RAF_CRITICAL_INDICATORS.forEach(f => {';
    put '      const list = appetiteMetricsConfig[f.category] || [];';
    put '      const metric = list.find(m => m.id === f.id);';
    put '      if (!metric) return;';
    put '      const cat = riskCategoriesConfig.find(c => c.key === f.category);';
    put '      const riskArea = cat ? cat.title : f.category;';
    put '      const status = RAFStatus.evaluateStatus(metric);';
    put '      const cssClass = RAF_STATUS_CSS_CLASS[status];';
    put '      const valueLabel = RAFUtils.formatPercent(metric.currentValue);';
    put '      html += ''<div class="ind-card" onclick="RAFRouting.showCategory(&apos;'' + f.category + ''&apos;)">'';';
    put '      html += ''<span class="ind-label">Risk Area</span><span class="ind-value">'' + escapeHtml(riskArea) + ''</span>'';';
    put '      html += ''<span class="ind-label">Risk Indicator</span><span class="ind-value">'' + escapeHtml(metric.indicator) + ''</span>'';';
    put '      html += ''<table class="ind-table"><thead><tr><th>Reporting Date</th><th>Value</th></tr></thead><tbody>'';';
    put '      periods.forEach(d => {';
    put '        html += ''<tr><td>'' + RAFUtils.formatDate(d) + ''</td><td><span class="rag-pill '' + cssClass + ''">'' + valueLabel + ''</span></td></tr>'';';
    put '      });';
    put '      html += ''</tbody></table></div>'';';
    put '    });';
    put '    return html;';
    put '  },';

    /* Zone 2: criticality x period heatmap - ONE row per criticality level,
       with each period''s Green/Amber/Red as its own 3-column group running
       left-to-right, instead of one row per criticality/period pair. A
       3-row table with the periods spread out horizontally uses the panel''s
       full width properly (was a tall, narrow list before); the single flat
       header row (rather than a rowspan/colspan header) keeps every column
       lining up 1-for-1 with the body rows, so the existing generic
       filterBarHtml()/applyTableFilter()/exportTableToExcel() tooling (see
       dashboardTableTools.sas), which matches by counting <thead th>/<tbody
       tr> cells, keeps working unchanged. Drops the per-cell trend glyph -
       it referenced ic-thumb-up/ic-thumb-down symbols that were never
       actually defined anywhere, so it never rendered; comparing periods is
       now done by eye directly across the row instead. */
    put '  renderHeatmapByCriticality() {';
    put '    const periods = (croDashboardConfig.heatmapByCriticality[0] || {}).periods || [];';
    put '    let html = ''<table class="heatmap-table"><thead><tr><th>Criticality</th>'';';
    put '    periods.forEach(p => {';
    put '      const d = RAFUtils.formatDate(p.date);';
    put '      html += ''<th class="num good">'' + d + '' Green</th><th class="num warning">'' + d + '' Amber</th><th class="num critical">'' + d + '' Red</th>'';';
    put '    });';
    put '    html += ''</tr></thead><tbody>'';';
    put '    croDashboardConfig.heatmapByCriticality.forEach(row => {';
    put '      html += ''<tr><td class="crit-cell">'' + escapeHtml(row.criticality)';
    put '        + ''<br/><span style="font-weight:400;font-size:.68rem;">'' + row.totalIndicators + '' indicators</span></td>'';';
    put '      row.periods.forEach(p => {';
    put '        html += ''<td class="num good">'' + p.good + ''</td><td class="num warning">'' + p.watch + ''</td><td class="num critical">'' + p.breach + ''</td>'';';
    put '      });';
    put '      html += "</tr>";';
    put '    });';
    put '    html += "</tbody></table>";';
    put '    return html;';
    put '  },';

    put '  // Zone 3: 2x2 grid of proportional Green/Amber/Red treemap blocks per period,';
    put '  // for the currently-selected Ownership.';
    put '  renderTreemapByOwnership(ownerName) {';
    put '    const periods = croDashboardConfig.treemapByOwnership[ownerName]';
    put '      || croDashboardConfig.treemapByOwnership[croDashboardConfig.ownershipOptions[0]] || [];';
    put '    let html = ''<div class="treemap-grid">'';';
    put '    periods.forEach(p => {';
    put '      const total = p.good + p.watch + p.breach;';
    put '      const rightTotal = p.watch + p.breach || 1;';
    put '      const greenPct = total ? (p.good / total) * 100 : 0;';
    put '      const rightPct = 100 - greenPct;';
    put '      const amberPct = (p.watch / rightTotal) * 100;';
    put '      const redPct = (p.breach / rightTotal) * 100;';
    put '      html += ''<div class="treemap-block"><div class="treemap-date">'' + RAFUtils.formatDate(p.date) + ''</div>'';';
    put '      html += ''<div class="treemap-rect"><div class="tm-green" style="width:'' + greenPct.toFixed(1) + ''%">'' + p.good + ''</div>'';';
    put '      html += ''<div class="tm-right" style="width:'' + rightPct.toFixed(1) + ''%">'';';
    put '      html += ''<div class="tm-amber" style="height:'' + amberPct.toFixed(1) + ''%">'' + p.watch + ''</div>'';';
    put '      html += ''<div class="tm-red" style="height:'' + redPct.toFixed(1) + ''%">'' + p.breach + ''</div>'';';
    put '      html += ''</div></div></div>'';';
    put '    });';
    put '    html += "</div>";';
    put '    return html;';
    put '  }';
    put '};';
%mend generate_cro_dashboard_view;
