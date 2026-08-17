/* ============================================================================
   RAF RESULTS VIEW MODULE
   Turns one metric config object (appetiteMetricsConfig.sas, itself now
   built straight off RAF_Q2_2026.xlsx by rafDataLoader.sas) into the full
   metric-card HTML: name/definition/tags, current value, status chip, the
   threshold-band meter with a value pointer and a grey regulatory
   reference line, and the trend block. This is the single place that HTML
   is built, reused by both the category detail route and (for the
   featured subset) the CRO Dashboard's Zone 1 cards.
   ============================================================================ */
%macro generate_appetite_results_view;
    put '// RAF Results View Module';
    put 'const RAFResults = {';

    put '  // Renders one metric as a full detail card (name, definition, tags,';
    put '  // current value, status chip, threshold-band meter, trend block). The';
    put '  // current-value number and the meter''s pointer/status chip always share';
    put '  // the same cssClass, so they can never disagree on colour.';
    put '  renderMetricCard(metric) {';
    put '    const status = RAFStatus.evaluateStatus(metric);';
    put '    const cssClass = RAF_STATUS_CSS_CLASS[status];';
    put '    const label = RAF_STATUS_LABEL[status];';
    put '    const icon = RAF_STATUS_ICON[status];';
    put '    const displayValue = RAFUtils.formatPercent(metric.currentValue);';
    put '    let html = "";';
    put '    html += ''<div class="metric-card">'';';
    put '    html += ''  <div class="metric-top">'';';
    put '    html += ''    <div>'';';
    put '    html += ''      <div class="metric-name">'' + escapeHtml(metric.indicator) + ''</div>'';';
    put '    html += ''      <div class="metric-def">'' + escapeHtml(metric.definition) + ''</div>'';';
    put '    html += ''      <div class="metric-tags">'';';
    put '    html += ''        <span class="chip level">'' + escapeHtml(metric.criticality) + ''</span>'';';
    put '    html += ''        <span class="chip comment">'' + escapeHtml(metric.comment) + ''</span>'';';
    put '    html += ''      </div>'';';
    put '    html += ''    </div>'';';
    put '    html += ''    <div class="metric-current"><span class="num '' + cssClass + ''">'' + displayValue + ''</span></div>'';';
    put '    html += ''    <div class="status-chip '' + cssClass + ''"><svg><use href="#'' + icon + ''"/></svg>'' + label + ''</div>'';';
    put '    html += ''  </div>'';';
    put '    html += this.renderMeter(metric, cssClass, displayValue);';
    put '    html += ''  <div class="metric-bottom">'';';
    put '    html += this.renderTrendBlock();';
    put '    html += ''  </div>'';';
    put '    html += ''</div>'';';
    put '    return html;';
    put '  },';

    /* geo.bands is a precomputed, already-ordered list of { color, leftPct,
       widthPct } segments (computed in SAS from however many of Green/
       Amber/Red actually parsed for this metric - see rafDataLoader.sas),
       so this just draws whatever it is given instead of assuming a fixed
       4-band shape. The regulatory line is its own absolutely-positioned
       grey marker across the full track (geo.regulatoryLeftPct), not tied
       to sitting "inside" any particular band. */
    put '  // Renders the threshold gauge: a value pointer positioned by percent,';
    put '  // the sheet''s own Green/Amber/Red bands, and a grey regulatory';
    put '  // reference line - plus the numeric scale underneath, each label';
    put '  // carrying the sheet''s own comparison sign (e.g. "Green >=12%").';
    put '  renderMeter(metric, cssClass, valueLabel) {';
    put '    const geo = RAFStatus.computeMeterGeometry(metric);';
    put '    const t = metric.thresholds || {};';
    put '    const ops = metric.thresholdOps || {};';
    put '    const labels = metric.thresholdLabels || {};';
    put '    // Prefers the full sign-aware label built in rafDataLoader.sas (handles a';
    put '    // range tier like ">=3.5%,<7%" correctly); falls back to reconstructing one';
    put '    // from thresholds/thresholdOps for any older data that lacks thresholdLabels.';
    put '    const tierLabel = key => labels[key] || ((t[key] === null || t[key] === undefined)';
    put '      ? "-" : ((ops[key] || "") + RAFUtils.formatPercent(t[key], 0)));';
    put '    let bands = "";';
    put '    /* .meter-track lays bands out with flexbox (see raStyles.sas), so';
    put '       only width matters here - the bands are already contiguous and';
    put '       left-to-right ordered by rafDataLoader.sas, same as flex''s own';
    put '       natural stacking order. */';
    put '    (geo.bands || []).forEach(b => {';
    put '      bands += ''<div class="band '' + RAF_STATUS_CSS_CLASS[b.color] + ''" style="width:'' + b.widthPct.toFixed(1) + ''%"></div>'';';
    put '    });';
    put '    let html = "";';
    put '    html += ''<div class="meter"><div class="meter-track">'';';
    put '    html += bands;';
    put '    if (typeof geo.regulatoryLeftPct === "number") {';
    put '      html += ''<div class="reg-line" style="left:'' + geo.regulatoryLeftPct.toFixed(1) + ''%"><span class="reg-label">Reg '' + RAFUtils.formatPercent(t.regulatory, 0) + ''</span></div>'';';
    put '    }';
    put '    if (typeof geo.markerLeftPct === "number") {';
    put '      html += ''<div class="meter-marker '' + cssClass + ''" style="left:'' + geo.markerLeftPct.toFixed(1) + ''%">'';';
    put '      html += ''<span class="mval">'' + valueLabel + ''</span><span class="mline"></span><span class="mdot"></span></div>'';';
    put '    }';
    put '    html += ''</div><div class="meter-scale">'';';
    put '    html += ''<span>Green '' + tierLabel("green") + ''</span>'';';
    put '    html += ''<span>Amber '' + tierLabel("amber") + ''</span><span>Red '' + tierLabel("red") + ''</span>'';';
    put '    html += ''</div></div>'';';
    put '    return html;';
    put '  },';

    /* Trend is always rendered as the dashed "no prior period" glyph today -
       the sheet has only one reporting period (Q2-2026), so there is
       genuinely nothing to compare against yet. Once real historical data
       exists, this becomes real up/down series - the signature intentionally
       takes no arguments yet so that swap-in is additive, not breaking. */
    put '  // Renders the trend indicator. Always "no prior period" today - see the';
    put '  // file header note on why this app never fabricates a trend number.';
    put '  renderTrendBlock() {';
    put '    let html = "";';
    put '    html += ''<div class="trend-block">'';';
    put '    html += ''<svg width="64" height="20" aria-hidden="true">'';';
    put '    html += ''<line x1="2" y1="10" x2="62" y2="10" stroke="#d1d5db" stroke-width="2" stroke-dasharray="3 4" stroke-linecap="round"/>'';';
    put '    html += ''<circle cx="2" cy="10" r="2.5" fill="#d1d5db"/><circle cx="32" cy="10" r="2.5" fill="#d1d5db"/><circle cx="62" cy="10" r="2.5" fill="#d1d5db"/>'';';
    put '    html += ''</svg>'';';
    put '    html += ''<span class="trend-caption">No prior period - trend unavailable</span>'';';
    put '    html += ''</div>'';';
    put '    return html;';
    put '  }';
    put '};';
%mend generate_appetite_results_view;
