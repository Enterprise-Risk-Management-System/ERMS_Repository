/* ============================================================================
   RAF STATUS MODULE
   Pure evaluation functions - turns a metric's thresholds + direction +
   current value into one of 4 canonical status codes, and into the pixel/
   percent geometry the threshold-band meter draws. No DOM access here; kept
   separate from RAFResults (which does the actual HTML rendering) so the
   evaluation logic is independently testable and reusable (the CRO
   Dashboard zones and the category detail meters both call this).

   CANONICAL STATUS CODES (used everywhere in the app - dashboard zones,
   heatmap, treemap, category tiles, metric detail):
     "good"             -> CSS class "good"     -> label "Within Appetite"
     "watch"            -> CSS class "warning"  -> label "Watch"
     "breach"           -> CSS class "serious"  -> label "Breach"
     "regulatoryBreach" -> CSS class "critical" -> label "Regulatory Breach"

   BAND LOGIC (lower-is-better direction - the placeholder default for all
   64 metrics today, see appetiteMetricsConfig.sas):
     value <= green            -> good
     green  < value <= amber   -> watch
     amber  < value <= red     -> breach
     value  > red              -> regulatoryBreach
   (The `regulatory` threshold is drawn as a reference line INSIDE the
   regulatoryBreach band, not as a 5th tier - there is no sheet-confirmed
   business rule for how to treat "past red but not yet past regulatory"
   as a distinct status, so this app does not invent one. Flag with the
   business owner if that gap between Red and Regulatory should carry its
   own status.)

   For "higher-is-better" metrics (not used by any metric yet, but the
   `direction` field already carries this option - see the config file
   header) the same 4 bands apply mirrored: value >= green is good, etc.
   ============================================================================ */
%macro generate_javascript_rastatus;
    put '// RAF Status Module';
    put 'const RAF_STATUS_CSS_CLASS = { good: "good", watch: "warning", breach: "serious", regulatoryBreach: "critical" };';
    put 'const RAF_STATUS_LABEL = { good: "Within Appetite", watch: "Watch", breach: "Breach", regulatoryBreach: "Regulatory Breach" };';
    put 'const RAF_STATUS_ICON = { good: "ic-good", watch: "ic-warning", breach: "ic-serious", regulatoryBreach: "ic-critical" };';

    put 'const RAFStatus = {';
    put '  // Evaluates one metric object (as shaped in appetiteMetricsConfig.sas) against';
    put '  // its own thresholds/direction, using its own currentValue (or an override,';
    put '  // e.g. a value pulled from the backend rather than the config placeholder).';
    put '  evaluateStatus(metric, valueOverride) {';
    put '    const value = typeof valueOverride === "number" ? valueOverride : metric.currentValue;';
    put '    const t = metric.thresholds;';
    put '    const higherIsBetter = metric.direction === "higher-is-better";';
    put '    if (typeof value !== "number" || !t) return "good";';
    put '    if (higherIsBetter) {';
    put '      if (value >= t.green) return "good";';
    put '      if (value >= t.amber) return "watch";';
    put '      if (value >= t.red) return "breach";';
    put '      return "regulatoryBreach";';
    put '    }';
    put '    if (value <= t.green) return "good";';
    put '    if (value <= t.amber) return "watch";';
    put '    if (value <= t.red) return "breach";';
    put '    return "regulatoryBreach";';
    put '  },';

    /* Geometry for the 4-band threshold meter drawn on each metric card.
       scaleMax gives the regulatory line some breathing room rather than
       sitting flush against the right edge - matches the signed-off mockup
       (raf_dashboard_mockup.html), which used scaleMax = regulatory * 1.2. */
    put '  // Computes the threshold-band meter geometry: 4 band widths (as % of the';
    put '  // scale), the value marker''s left position (%), and the regulatory';
    put '  // reference line''s left position (%). Handles both directions.';
    put '  computeMeterGeometry(metric, valueOverride) {';
    put '    const value = typeof valueOverride === "number" ? valueOverride : metric.currentValue;';
    put '    const t = metric.thresholds;';
    put '    const higherIsBetter = metric.direction === "higher-is-better";';
    put '    const scaleMax = t.regulatory * 1.2;';
    put '    const pct = v => Math.max(0, Math.min(100, (v / scaleMax) * 100));';
    put '    if (higherIsBetter) {';
    put '      // Mirrored: the "good" band sits at the high end of the scale.';
    put '      return {';
    put '        bandWidthPct: {';
    put '          regulatoryBreach: pct(t.red),';
    put '          breach: pct(t.amber) - pct(t.red),';
    put '          watch: pct(t.green) - pct(t.amber),';
    put '          good: 100 - pct(t.green)';
    put '        },';
    put '        bandOrder: ["regulatoryBreach", "breach", "watch", "good"],';
    put '        markerLeftPct: pct(value),';
    put '        regulatoryLeftPct: pct(t.regulatory),';
    put '        scaleMax';
    put '      };';
    put '    }';
    put '    return {';
    put '      bandWidthPct: {';
    put '        good: pct(t.green),';
    put '        watch: pct(t.amber) - pct(t.green),';
    put '        breach: pct(t.red) - pct(t.amber),';
    put '        regulatoryBreach: 100 - pct(t.red)';
    put '      },';
    put '      bandOrder: ["good", "watch", "breach", "regulatoryBreach"],';
    put '      markerLeftPct: pct(value),';
    put '      regulatoryLeftPct: pct(t.regulatory),';
    put '      scaleMax';
    put '    };';
    put '  },';

    put '  // Rolls up a list of metrics into { good, watch, breach, regulatoryBreach }';
    put '  // counts - used by category tiles, domain cards and dashboard zones.';
    put '  rollUpStatusCounts(metrics) {';
    put '    const counts = { good: 0, watch: 0, breach: 0, regulatoryBreach: 0 };';
    put '    metrics.forEach(m => { counts[RAFStatus.evaluateStatus(m)]++; });';
    put '    return counts;';
    put '  }';
    put '};';
%mend generate_javascript_rastatus;
