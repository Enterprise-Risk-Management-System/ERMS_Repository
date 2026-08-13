/* ============================================================================
   ROUTE BUILDERS: Under-process placeholders for Market Risk / Credit Risk /
   Operational Risk (ERMS routes #market / #credit / #operational).
   These 3 hashes were already referenced by the existing sidebar
   (components.sas) but were never registered in router.sas's routes object,
   so clicking them today shows "Page Not Found". Registering them here is a
   small, additive fix to that pre-existing gap - not new scope invented for
   the Risk Appetite Framework - each one just shows a clean "Under process"
   notice until ERMS's own team builds the real page.
   ============================================================================ */
%macro buildUnderProcessPlaceholders;
    put 'function raf_buildUnderProcessHTML(title) {';
    put '  let html = "";';
    put '  html += ''<div class="page-header" style="margin-bottom:0;">'';';
    put '  html += ''<h1 class="page-title">'' + title + ''</h1>'';';
    put '  html += ''<p class="page-subtitle">This page is under process. Check back soon.</p>'';';
    put '  html += ''</div>'';';
    put '  return html;';
    put '}';
    put 'function getMarketRiskPlaceholderHTML() { return raf_buildUnderProcessHTML("Market Risk"); }';
    put 'function getCreditRiskPlaceholderHTML() { return raf_buildUnderProcessHTML("Credit Risk"); }';
    put 'function getOperationalRiskPlaceholderHTML() { return raf_buildUnderProcessHTML("Operational Risk"); }';
%mend buildUnderProcessPlaceholders;
