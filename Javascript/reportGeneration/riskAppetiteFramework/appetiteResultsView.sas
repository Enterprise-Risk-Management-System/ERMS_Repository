/* ============================================================================
   RAF RESULTS VIEW MODULE
   Turns one metric config object (appetiteMetricsConfig.sas) into the full
   metric-card HTML: name/definition/tags, current value, status chip, the
   4-band threshold meter with a value marker and a regulatory reference
   line, and the trend block. This is the single place that HTML is built,
   reused by both the category detail route and (for the featured subset)
   the CRO Dashboard's Zone 1 cards.
   ============================================================================ */
%macro generate_appetite_results_view;
    put '// RAF Results View Module';
    put 'const RAFResults = {';

    put '  // Renders one metric as a full detail card (name, definition, tags,';
    put '  // current value, status chip, threshold-band meter, trend block).';
    put '  renderMetricCard(metric) {';
    put '    const status = RAFStatus.evaluateStatus(metric);';
    put '    const cssClass = RAF_STATUS_CSS_CLASS[status];';
    put '    const label = RAF_STATUS_LABEL[status];';
    put '    const icon = RAF_STATUS_ICON[status];';
    put '    const geo = RAFStatus.computeMeterGeometry(metric);';
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
    put '    html += ''    <div class="metric-current"><span class="num">'' + displayValue';
    put '      + (metric.currentValuePlaceholder ? ''<span class="ph">Placeholder value</span>'' : '''') + ''</span></div>'';';
    put '    html += ''    <div class="status-chip '' + cssClass + ''"><svg><use href="#'' + icon + ''"/></svg>'' + label + ''</div>'';';
    put '    html += ''  </div>'';';
    put '    html += this.renderMeter(metric, geo);';
    put '    html += ''  <div class="metric-bottom">'';';
    put '    html += this.renderTrendBlock();';
    put '    html += ''  </div>'';';
    put '    html += ''</div>'';';
    put '    return html;';
    put '  },';

    put '  // Renders the 4-band threshold gauge: a value marker positioned by percent,';
    put '  // proportional Green/Amber/Red/Regulatory-breach bands, a dashed regulatory';
    put '  // reference line, and the numeric scale underneath.';
    put '  renderMeter(metric, geo) {';
    put '    const t = metric.thresholds;';
    put '    const cssClass = RAF_STATUS_CSS_CLASS[RAFStatus.evaluateStatus(metric)];';
    put '    const valueLabel = RAFUtils.formatPercent(metric.currentValue);';
    put '    const order = geo.bandOrder;';
    put '    let bands = "";';
    put '    order.forEach((key, idx) => {';
    put '      const cls = RAF_STATUS_CSS_CLASS[key];';
    put '      const isLastCritBand = key === "regulatoryBreach";';
    put '      bands += ''<div class="band '' + cls + ''" style="width:'' + geo.bandWidthPct[key].toFixed(1) + ''%">'';';
    put '      if (isLastCritBand) {';
    put '        const regLeftWithinBand = order.indexOf("regulatoryBreach") === order.length - 1';
    put '          ? ((geo.regulatoryLeftPct - (100 - geo.bandWidthPct.regulatoryBreach)) / geo.bandWidthPct.regulatoryBreach) * 100';
    put '          : (geo.regulatoryLeftPct / geo.bandWidthPct.regulatoryBreach) * 100;';
    put '        bands += ''<div class="reg-line" style="left:'' + regLeftWithinBand.toFixed(1) + ''%"><span class="reg-label">Reg '' + RAFUtils.formatPercent(t.regulatory, 0) + ''</span></div>'';';
    put '      }';
    put '      bands += ''</div>'';';
    put '    });';
    put '    let html = "";';
    put '    html += ''<div class="meter"><div class="meter-track">'';';
    put '    html += ''<div class="meter-marker '' + cssClass + ''" style="left:'' + geo.markerLeftPct.toFixed(1) + ''%">'';';
    put '    html += ''<span class="mval">'' + valueLabel + ''</span><span class="mline"></span><span class="mdot"></span></div>'';';
    put '    html += bands;';
    put '    html += ''</div><div class="meter-scale">'';';
    put '    html += ''<span>0%</span><span>Green '' + RAFUtils.formatPercent(t.green, 0) + ''</span>'';';
    put '    html += ''<span>Amber '' + RAFUtils.formatPercent(t.amber, 0) + ''</span><span>Red '' + RAFUtils.formatPercent(t.red, 0) + ''</span>'';';
    put '    html += ''<span>'' + RAFUtils.formatPercent(geo.scaleMax, 0) + ''</span></div></div>'';';
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
