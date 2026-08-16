/* ============================================================================
   RAF CRO DASHBOARD VIEW MODULE
   Renders the CRO Dashboard's zones from croDashboardConfig.sas: Heatmap by
   Criticality (Zone 2), Treemap by Ownership (Zone 3), Trend Analysis by
   Pillar (Zone 4). (Critical Risk Indicators / Zone 1 has been removed -
   not currently required; see buildRAF.sas/croDashboardConfig.sas/
   rafDashboardAggregates.sas for the matching removal. Zone numbering below
   is left as-is/2-3-4 to match those other files rather than renumbered.)
   Kept separate from the route builder (buildCroDashboard.sas), which only
   assembles the filter bar + zone shells - this file renders the
   data-driven parts, mirroring the reference app's separation between a
   route builder and its results view.
   ============================================================================ */
%macro generate_cro_dashboard_view;
    put '// RAF CRO Dashboard View Module';
    put 'const RAFDashboardView = {';

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
    put '  },';

    put '  // Zone 4: a 2-line SVG trend chart, Pillar 1 vs Pillar 2 watch/breach counts';
    put '  renderTrendByPillar() {';
    put '    const cfg = croDashboardConfig.trendByPillar;';
    put '    const periods = cfg.periods;';
    put '    const p1 = cfg.pillar1WatchBreachCount;';
    put '    const p2 = cfg.pillar2WatchBreachCount;';
    put '    const maxVal = Math.max(...p1, ...p2, 4);';
    put '    const left = 40, right = 520, top = 20, bottom = 180;';
    put '    const xAt = i => left + (i * (right - left)) / (periods.length - 1);';
    put '    const yAt = v => bottom - (v / maxVal) * (bottom - top);';
    put '    const pointsFor = arr => arr.map((v, i) => xAt(i).toFixed(1) + "," + yAt(v).toFixed(1)).join(" ");';
    put '    let html = ''<div class="trend-legend"><span><i style="background:var(--brand-2)"></i>Pillar 1</span>'';';
    put '    html += ''<span><i style="background:var(--series-2)"></i>Pillar 2</span></div>'';';
    put '    html += ''<div class="trend-chart-wrap"><svg viewBox="0 0 560 210" role="img" aria-label="Trend of watch/breach indicator counts by pillar">'';';
    put '    [0, 0.25, 0.5, 0.75, 1].forEach(f => {';
    put '      const y = bottom - f * (bottom - top);';
    put '      html += ''<line x1="'' + left + ''" y1="'' + y.toFixed(1) + ''" x2="'' + right + ''" y2="'' + y.toFixed(1) + ''" stroke="#e5e7eb" stroke-width="1"/>'';';
    put '      html += ''<text x="'' + (left - 6) + ''" y="'' + (y + 4).toFixed(1) + ''" text-anchor="end" font-size="11" fill="#9ca3af">'' + Math.round(f * maxVal) + ''</text>'';';
    put '    });';
    put '    html += ''<polyline points="'' + pointsFor(p1) + ''" fill="none" stroke="#3b82f6" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/>'';';
    put '    html += ''<polyline points="'' + pointsFor(p2) + ''" fill="none" stroke="#7c3aed" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/>'';';
    put '    periods.forEach((d, i) => {';
    put '      html += ''<circle cx="'' + xAt(i).toFixed(1) + ''" cy="'' + yAt(p1[i]).toFixed(1) + ''" r="4" fill="#3b82f6" stroke="#fff" stroke-width="2"><title>Pillar 1 - '' + RAFUtils.formatDate(d) + '': '' + p1[i] + ''</title></circle>'';';
    put '      html += ''<circle cx="'' + xAt(i).toFixed(1) + ''" cy="'' + yAt(p2[i]).toFixed(1) + ''" r="4" fill="#7c3aed" stroke="#fff" stroke-width="2"><title>Pillar 2 - '' + RAFUtils.formatDate(d) + '': '' + p2[i] + ''</title></circle>'';';
    put '      html += ''<text x="'' + xAt(i).toFixed(1) + ''" y="198" text-anchor="middle" font-size="11" fill="#6b7280">'' + RAFUtils.formatDate(d) + ''</text>'';';
    put '    });';
    put '    html += "</svg></div>";';
    put '    return html;';
    put '  }';
    put '};';
%mend generate_cro_dashboard_view;
