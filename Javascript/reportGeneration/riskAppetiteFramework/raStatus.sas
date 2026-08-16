/* ============================================================================
   RAF STATUS MODULE
   Turns a metric's precomputed classification/geometry into what the UI
   needs - status CSS class/label/icon, threshold-band meter geometry, and
   rolled-up counts. No DOM access here; kept separate from RAFResults
   (which does the actual HTML rendering) so this stays independently
   reusable - the CRO Dashboard zones, the heatmap/treemap, the category
   tiles and the metric detail meters all call this.

   NOW DATA-DRIVEN: the sign-aware Green/Amber/Red parsing, the RAG
   classification and the meter geometry are all computed once, in SAS,
   straight off the live RAF_Q2_2026.xlsx on every run (see
   rafDataLoader.sas) - not recomputed here. Every metric object already
   carries its own `status` and `meter` fields; the functions below are
   thin, safe passthroughs so every existing call site keeps working
   exactly as before, without duplicating the sign/threshold-parsing
   algorithm in JS as well as SAS.

   CANONICAL STATUS CODES (used everywhere in the app - dashboard zones,
   heatmap, treemap, category tiles, metric detail):
     "green" -> CSS class "good"     -> label "Within Tolerance"
     "amber" -> CSS class "warning"  -> label "Watch"
     "red"   -> CSS class "critical" -> label "Breach"
   Green/Amber/Red are evaluated by testing Utilization against Green's own
   sheet condition first, then Amber's, then Red's - first match wins - so
   direction (higher-is-safer vs. lower-is-safer) never has to be uniform
   across metrics; it is read straight off each Risk Area's own sheet
   cells. Regulatory is never a 4th colour - it is always drawn as a grey
   reference marker (see RAFResults.renderMeter).
   ============================================================================ */
%macro generate_javascript_rastatus;
    put '// RAF Status Module';
    /* good/watch/breach/regulatoryBreach are kept as aliases of green/amber/
       red/red - croDashboardConfig.sas''s own illustrative history entries
       (a separate, untouched module - see that file''s header) still use
       that older 4-way vocabulary directly as literal strings, and
       croDashboardView.sas looks them up in this same table. */
    put 'const RAF_STATUS_CSS_CLASS = { green: "good", amber: "warning", red: "critical",';
    put '  good: "good", watch: "warning", breach: "critical", regulatoryBreach: "critical" };';
    put 'const RAF_STATUS_LABEL = { green: "Within Tolerance", amber: "Watch", red: "Breach",';
    put '  good: "Within Tolerance", watch: "Watch", breach: "Breach", regulatoryBreach: "Breach" };';
    put 'const RAF_STATUS_ICON = { green: "ic-good", amber: "ic-warning", red: "ic-critical",';
    put '  good: "ic-good", watch: "ic-warning", breach: "ic-critical", regulatoryBreach: "ic-critical" };';

    put 'const RAFStatus = {';
    put '  // Returns one metric''s already-computed status ("green"/"amber"/"red").';
    put '  // A metric whose sheet data could not be classified (every tolerance';
    put '  // cell blank/unparseable) carries no status - default to "green" here,';
    put '  // the same safe/neutral fallback this module has always used.';
    put '  evaluateStatus(metric) {';
    put '    if (!metric || !metric.status) return "green";';
    put '    return metric.status;';
    put '  },';

    put '  // Returns one metric''s already-computed threshold-band meter geometry';
    put '  // ({ bands, markerLeftPct, regulatoryLeftPct, scaleMin, scaleMax }).';
    put '  computeMeterGeometry(metric) {';
    put '    if (metric && metric.meter) return metric.meter;';
    put '    return { bands: [], markerLeftPct: null, regulatoryLeftPct: null, scaleMin: 0, scaleMax: 1 };';
    put '  },';

    put '  // Rolls up a list of metrics into { green, amber, red } counts - used by';
    put '  // category tiles, domain cards and dashboard zones.';
    put '  rollUpStatusCounts(metrics) {';
    put '    const counts = { green: 0, amber: 0, red: 0 };';
    put '    (metrics || []).forEach(m => { counts[RAFStatus.evaluateStatus(m)]++; });';
    put '    return counts;';
    put '  }';
    put '};';
%mend generate_javascript_rastatus;
