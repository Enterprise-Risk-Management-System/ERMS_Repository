/* ============================================================================
   ROUTE BUILDER: Risk Appetite Framework (ERMS route #risk-appetite-framework)
   NEW module - registered as one additional key in ERMS's existing routes
   object (see router.sas), reached via the new "CRO Dashboard" item in the
   navbar's Dashboard dropdown (see components.sas). Renders entirely inside
   ERMS's own #main-panel, under ERMS's own navbar/page-header -
   this file contributes content only, never a second page shell.

   INTEGRATION RULES THIS FILE FOLLOWS (see also reportGeneration/riskAppetiteFramework/*):
     1. Every CSS rule is scoped under ".raf-app" so it can never affect
        ERMS's own navbar/buttons/modal, and ERMS's global CSS can never
        accidentally restyle RAF's content either.
     2. RAF ships NO navbar/loading-spinner/notification-banner/modal of its
        own - it reuses ERMS's real ones (showLoading(), hideLoading(),
        showNotification(), the #reportModal shell) rather than duplicating them.
     3. RAF's internal drill-down (Dashboard -> Domains -> Categories -> Metric
        detail) does NOT use window.location.hash - ERMS's own router only
        exact-matches hashes it knows about, so a RAF sub-hash would show
        "Page Not Found" there. RAFRouting below manages navigation with an
        in-memory JS variable instead, re-rendering only inside #raf-main-panel.
        Trade-off: RAF's inner steps are not individually bookmarkable/Back-
        button-able - only the top-level #risk-appetite-framework entry is a
        real URL. Only ERMS's own top-level routes (including this one) use
        the hash.
     4. RAF's palette (see raStyles.sas) is drawn directly from ERMS's own
        navbar gradient / gray scale / status-badge colors, so the CRO
        Dashboard reads as part of ERMS rather than a visually distinct
        tool bolted on.
     5. No real access control exists yet (ERMS has no auth/role layer) - the
        page carries no "CRO Only" labeling convention (removed along with
        the topbar - not currently required). Revisit once ERMS gets
        role-based access.
   ============================================================================ */
%macro buildRAF;

    /* ---- RAFUI: title lookups + breadcrumb rendering (RAF-internal only) ---- */
    put '// RAF UI Module (internal to the Risk Appetite Framework section)';
    put 'const RAFUI = {';
    put '  getDomainTitle(domainKey) {';
    put '    const found = riskDomainsConfig.find(d => d.key === domainKey);';
    put '    return found ? found.title : domainKey;';
    put '  },';
    put '  getCategoryTitle(categoryKey) {';
    put '    const found = riskCategoriesConfig.find(c => c.key === categoryKey);';
    put '    return found ? found.title : categoryKey;';
    put '  },';
    put '  getDomainForCategory(categoryKey) {';
    put '    const found = riskDomainsConfig.find(d => d.categories.includes(categoryKey));';
    put '    return found ? found.key : null;';
    put '  },';
    put '  renderBreadcrumb(crumbs) {';
    put '    const trail = document.getElementById("raf-breadcrumb-trail");';
    put '    if (!trail) return;';
    put '    let html = "";';
    put '    crumbs.forEach((crumb, idx) => {';
    put '      const isLast = idx === crumbs.length - 1;';
    put '      if (idx > 0) html += "<span> &rsaquo; </span>";';
    put '      if (!isLast && crumb.onClick) {';
    put '        html += "<b onclick=\"" + crumb.onClick + "\">" + escapeHtml(crumb.label) + "</b>";';
    put '      } else {';
    put '        html += "<span class=\"crumb-current\">" + escapeHtml(crumb.label) + "</span>";';
    put '      }';
    put '    });';
    put '    trail.innerHTML = html;';
    put '  },';
    put '  setTitle(title, subtitle) {';
    put '    const t = document.getElementById("raf-page-title");';
    put '    const s = document.getElementById("raf-page-subtitle");';
    put '    if (t) t.textContent = title;';
    put '    if (s) s.textContent = subtitle || "";';
    put '  }';
    put '};';

    /* ---- RAFRouting: in-memory sub-router (see rule 3 in the file header) ---- */
    put '// RAF internal router - in-memory only, does not touch window.location.hash';
    put 'const RAFRouting = {';
    put '  currentDomain: "financial",';
    put '  render(html) {';
    put '    const panel = document.getElementById("raf-main-panel");';
    put '    if (panel) panel.innerHTML = html;';
    put '  },';
    put '  showDashboard() {';
    put '    this.render(buildRafDashboardHTML());';
    put '    RAFUI.renderBreadcrumb([{ label: "CRO Dashboard" }]);';
    /* Risk-area/indicator counts read straight off the loaded config
       instead of being hardcoded, so this line never drifts from the sheet
       (same "don''t hardcode what''s derivable" principle applied elsewhere
       in RAF - see rafDataLoader.sas). */
    put '    const totalIndicators = Object.values(appetiteMetricsConfig).reduce((sum, arr) => sum + arr.length, 0);';
    /* "CRO Dashboard" (matches the breadcrumb label just above), not "Risk
       Appetite Framework" - that text now belongs solely to the shared
       shell header set once in getRAFHTML(), so it isn''t shown twice. */
    put '    RAFUI.setTitle("CRO Dashboard", riskCategoriesConfig.length + " risk areas - " + totalIndicators + " indicators tracked against Board-approved appetite limits.");';
    put '  },';
    put '  showDomains() {';
    put '    this.render(buildRafDomainsHTML());';
    put '    RAFUI.renderBreadcrumb([';
    put '      { label: "CRO Dashboard", onClick: "RAFRouting.showDashboard()" },';
    put '      { label: "Risk Domains" }';
    put '    ]);';
    put '    const domTotalIndicators = Object.values(appetiteMetricsConfig).reduce((sum, arr) => sum + arr.length, 0);';
    put '    RAFUI.setTitle("Risk Domains", riskCategoriesConfig.length + " risk areas grouped into " + riskDomainsConfig.length + " domains - " + domTotalIndicators + " indicators - Q2-2026. Choose a domain to see its risk areas.");';
    put '  },';
    put '  showDomain(domainKey) {';
    put '    this.currentDomain = domainKey;';
    put '    this.render(buildRafCategoriesHTML(domainKey));';
    put '    const domain = riskDomainsConfig.find(d => d.key === domainKey);';
    put '    const catCount = domain ? domain.categories.length : 0;';
    put '    const indCount = domain ? domain.categories.reduce((sum, key) => {';
    put '      const c = riskCategoriesConfig.find(x => x.key === key);';
    put '      return sum + (c ? c.indicatorCount : 0);';
    put '    }, 0) : 0;';
    put '    RAFUI.renderBreadcrumb([';
    put '      { label: "CRO Dashboard", onClick: "RAFRouting.showDashboard()" },';
    put '      { label: "Risk Domains", onClick: "RAFRouting.showDomains()" },';
    put '      { label: RAFUI.getDomainTitle(domainKey) }';
    put '    ]);';
    put '    RAFUI.setTitle(RAFUI.getDomainTitle(domainKey), catCount + " risk areas - " + indCount + " indicators - Q2-2026. Click a category to view its metrics.");';
    put '  },';
    put '  showCategory(categoryKey) {';
    put '    this.render(buildRafCategoryDetailHTML(categoryKey));';
    put '    const domainKey = RAFUI.getDomainForCategory(categoryKey) || this.currentDomain;';
    put '    this.currentDomain = domainKey;';
    put '    RAFUI.renderBreadcrumb([';
    put '      { label: "CRO Dashboard", onClick: "RAFRouting.showDashboard()" },';
    put '      { label: "Risk Domains", onClick: "RAFRouting.showDomains()" },';
    put '      { label: RAFUI.getDomainTitle(domainKey), onClick: "RAFRouting.showDomain(&apos;" + domainKey + "&apos;)" },';
    put '      { label: RAFUI.getCategoryTitle(categoryKey) }';
    put '    ]);';
    put '    RAFUI.setTitle(RAFUI.getCategoryTitle(categoryKey), "");';
    put '  }';
    put '};';

    /* ---- Entry point: registered in ERMS's routes object as #risk-appetite-framework ---- */
    put '// Entry point for the ERMS route #risk-appetite-framework';
    put 'function getRAFHTML() {';
    /* Shared shell header (components.sas) is retitled here so it reads
       "Risk Appetite Framework" while on this route instead of its default
       "Risk Management Dashboard" - router.sas's updateContent() resets it
       back to the default before every route render, so leaving RAF for
       another route un-stales it automatically; nothing else about that
       shared header (breadcrumb, subtitle) changes. This is also now the
       ONLY place "Risk Appetite Framework" appears - the CRO Dashboard
       sub-view''s own in-page title (see RAFRouting.showDashboard()) was
       the duplicate and has been reworded accordingly. */
    put '  var shellTitleEl = document.getElementById("page-title");';
    put '  if (shellTitleEl) shellTitleEl.textContent = "Risk Appetite Framework";';
    put '  let html = RAF_STYLE_BLOCK;';
    put '  html += RAF_ICON_DEFS;';
    /* The navy/blue ".raf-topbar" gradient bar (brand icon + "CRO Only"
       badge) that used to sit above .raf-body has been removed entirely -
       not currently required. .raf-body now opens .raf-app directly. */
    put '  html += ''<div class="raf-app">'';';
    put '  html += ''  <div class="raf-body">'';';
    put '  html += ''    <div class="crumb" id="raf-breadcrumb-trail"></div>'';';
    put '  html += ''    <h2 class="raf-pagetitle" id="raf-page-title"></h2>'';';
    put '  html += ''    <p class="raf-pagesub" id="raf-page-subtitle"></p>'';';
    put '  html += ''    <div id="raf-main-panel"></div>'';';
    put '  html += ''  </div>'';';
    put '  html += ''</div>'';';
    put '  setTimeout(function () { RAFRouting.showDashboard(); }, 0);';
    put '  return html;';
    put '}';

    /* ---- Zone 1-3 dashboard shell (tab bar + zone panels) ---- */
    put 'function buildRafDashboardHTML() {';
    put '  let html = "";';

    /* Tab bar - one tab per indicator view, only one panel visible at a time
       (raf_showTab below) so each gets the full main-panel width instead of
       all 3 stacking down the page. "Risk Domains & Drill Down" is a 4th tab
       in the same bar, but unlike the other 3 it isn't a same-page
       show/hide panel - it is a multi-level drill-down (Domains -> Risk
       Categories -> Metric detail, see buildRafDomainsHTML/
       buildRafCategoriesHTML/buildRafCategoryDetailHTML below), so clicking
       it hands off to RAFRouting.showDomains() (a full #raf-main-panel
       navigation, already built - the breadcrumb it renders links "CRO
       Dashboard" back to RAFRouting.showDashboard(), which rebuilds this
       tab bar fresh).
       Fixed order per the business owner - do not reorder: Critical
       Indicators, Risk Indicator Treemap, Risk Indicator Heatmap, Risk
       Domains & Drill Down. Critical Indicators is the default-active tab. */
    put '  html += ''<div class="raf-tabs" role="tablist">'';';
    put '  html += ''  <button type="button" class="raf-tab active" data-raf-tab="critical" onclick="raf_showTab(&apos;critical&apos;)">Critical Indicators</button>'';';
    put '  html += ''  <button type="button" class="raf-tab" data-raf-tab="treemap" onclick="raf_showTab(&apos;treemap&apos;)">Risk Indicator Treemap</button>'';';
    put '  html += ''  <button type="button" class="raf-tab" data-raf-tab="heatmap" onclick="raf_showTab(&apos;heatmap&apos;)">Risk Indicator Heatmap</button>'';';
    put '  html += ''  <button type="button" class="raf-tab" onclick="RAFRouting.showDomains()">Risk Domains &amp; Drill Down &rarr;</button>'';';
    put '  html += ''</div>'';';

    /* Critical Indicators tab: a blue header ribbon (ERMS''s own navy ->
       brand-2 gradient, for visual consistency with the rest of the app)
       with a right-aligned, reference-style "Show" control, followed by the 6
       curated indicator cards. The "Show" select is a visual/reference
       reproduction of the design being matched, not a live filter - the 6
       featured cards are a fixed business-curated set (see the comment in
       croDashboardView.sas), same as the reference''s own fixed 5. */
    put '  html += ''<div class="raf-tabpanel active" id="raf-tabpanel-critical">'';';
    put '  html += ''  <div class="zone-panel">'';';
    put '  html += ''    <div class="crit-header"><h3>Critical Risk Indicators</h3>'';';
    put '  html += ''      <div class="crit-header-show">Show'';';
    put '  html += ''        <select aria-label="Critical indicators view"><option>Top 5 &middot; Monthly</option><option>Top 5 &middot; Quarterly</option><option>Top 10 &middot; Monthly</option></select>'';';
    put '  html += ''      </div>'';';
    put '  html += ''    </div>'';';
    put '  html += ''    <div class="zone-body">'';';
    put '  html += ''      <p class="zone-desc">Indicators marked for CRO visibility. Each card shows the Reporting Date vs. Value across the last 3 periods - the 2026-06-30 row is live from the sheet; earlier rows are placeholders pending a historical data connection. Click a card to open its full metric detail.</p>'';';
    put '  html += ''      <div class="ind-grid">'' + RAFDashboardView.renderCriticalIndicators() + ''</div>'';';
    put '  html += ''    </div>'';';
    put '  html += ''  </div>'';';
    put '  html += ''</div>'';';

    put '  html += ''<div class="raf-tabpanel" id="raf-tabpanel-treemap">'';';
    put '  html += ''  <div class="zone-panel">'';';
    put '  html += ''    <div class="zone-toolbar"><div class="zone-select"><label for="rafOwner">Ownership</label>'';';
    put '  html += ''      <select id="rafOwner" onchange="raf_updateTreemapOwner(this)">'';';
    put '  html += croDashboardConfig.ownershipOptions.map(o => ''<option>'' + escapeHtml(o) + ''</option>'').join("");';
    put '  html += ''      </select>'';';
    put '  html += ''    </div></div>'';';
    put '  html += ''    <div class="zone-body">'';';
    put '  html += ''      <p class="zone-desc">Number of risk indicators in Green, Amber and Red zones for the selected owner. The 2026-06-30 column is live from the sheet; earlier columns are placeholders pending a historical data connection.</p>'';';
    put '  html += ''      <div id="rafTreemapZoneBody">'' + RAFDashboardView.renderTreemapByOwnership(croDashboardConfig.ownershipOptions[0]) + ''</div>'';';
    put '  html += ''    </div>'';';
    put '  html += ''  </div>'';';
    put '  html += ''</div>'';';

    put '  html += ''<div class="raf-tabpanel" id="raf-tabpanel-heatmap">'';';
    put '  html += ''  <div class="zone-panel"><div class="zone-body">'';';
    put '  html += ''    <p class="zone-desc">Number of risk indicators in Green, Amber and Red zones, by criticality level. The 2026-06-30 column is live from the sheet; earlier columns are placeholders pending a historical data connection.</p>'';';
    put '  html += filterBarHtml("raf-heatmap-table");';
    put '  html += ''    <div style="overflow-x:auto;">'' + RAFDashboardView.renderHeatmapByCriticality().replace(''<table class="heatmap-table">'', ''<table class="heatmap-table" id="raf-heatmap-table">'') + ''</div>'';';
    put '  html += ''    <div style="margin-top:10px; text-align:right;"><button class="btn" onclick="exportTableToExcel(&apos;raf-heatmap-table&apos;,&apos;Heatmap by Criticality&apos;,&apos;RAF_Heatmap&apos;)">Export to Excel</button></div>'';';
    put '  html += ''  </div></div>'';';
    put '  html += ''</div>'';';
    put '  return html;';
    put '}';

    put '// Switches the CRO Dashboard tab (Critical Indicators / Treemap / Heatmap) -';
    put '// pure show/hide over already-rendered panels, no re-fetch or re-render.';
    put 'function raf_showTab(tabKey) {';
    put '  document.querySelectorAll(".raf-tab").forEach(function (el) {';
    put '    el.classList.toggle("active", el.getAttribute("data-raf-tab") === tabKey);';
    put '  });';
    put '  document.querySelectorAll(".raf-tabpanel").forEach(function (el) {';
    put '    el.classList.toggle("active", el.id === "raf-tabpanel-" + tabKey);';
    put '  });';
    put '}';

    put 'function raf_updateTreemapOwner(select) {';
    put '  const body = document.getElementById("rafTreemapZoneBody");';
    put '  if (body) body.innerHTML = RAFDashboardView.renderTreemapByOwnership(select.value);';
    put '}';

    /* ---- Risk Domains (grouping cards) ---- */
    put 'function buildRafDomainsHTML() {';
    put '  let html = ''<div class="domain-grid">'';';
    put '  riskDomainsConfig.forEach(domain => {';
    put '    const metrics = domain.categories.flatMap(key => appetiteMetricsConfig[key] || []);';
    put '    const counts = RAFStatus.rollUpStatusCounts(metrics);';
    put '    const total = counts.green + counts.amber + counts.red;';
    put '    const pct = n => total ? ((n / total) * 100).toFixed(1) : 0;';
    put '    const indicatorCount = domain.categories.reduce((sum, key) => {';
    put '      const cat = riskCategoriesConfig.find(c => c.key === key);';
    put '      return sum + (cat ? cat.indicatorCount : 0);';
    put '    }, 0);';
    put '    html += ''<div class="domain-card" onclick="RAFRouting.showDomain(&apos;'' + domain.key + ''&apos;)">'';';
    put '    html += ''  <div class="domain-head"><div class="domain-icon">'' + domain.icon + ''</div>'';';
    put '    html += ''    <div><div class="domain-title">'' + escapeHtml(domain.title) + ''</div>'';';
    put '    html += ''    <div class="domain-meta">'' + domain.categories.length + '' risk areas - '' + indicatorCount + '' indicators</div></div>'';';
    put '    html += ''  </div>'';';
    put '    html += ''  <div class="domain-desc">'' + escapeHtml(domain.description) + ''</div>'';';
    put '    html += ''  <div class="domain-split">'';';
    put '    html += ''    <span style="width:'' + pct(counts.green) + ''%; background:var(--good)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.amber) + ''%; background:var(--warning)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.red) + ''%; background:var(--critical)"></span>'';';
    put '    html += ''  </div>'';';
    put '    html += ''  <div class="domain-split-caption">'' + counts.green + '' within tolerance - '' + counts.amber + '' watch - ''';
    put '      + counts.red + '' breach</div>'';';
    put '    html += ''  <div class="domain-foot"><span class="domain-link">Explore &rarr;</span></div>'';';
    put '    html += ''</div>'';';
    put '  });';
    put '  html += "</div>";';
    put '  return html;';
    put '}';

    /* ---- Category tiles within a domain ---- */
    put 'function buildRafCategoriesHTML(domainKey) {';
    put '  const categories = riskCategoriesConfig.filter(c => c.domain === domainKey);';
    put '  let html = ''<div class="tiles">'';';
    put '  categories.forEach(cat => {';
    put '    const counts = RAFStatus.rollUpStatusCounts(appetiteMetricsConfig[cat.key] || []);';
    put '    const total = counts.green + counts.amber + counts.red;';
    put '    const pct = n => total ? ((n / total) * 100).toFixed(1) : 0;';
    put '    const parts = [];';
    put '    if (counts.green) parts.push(counts.green + " within tolerance");';
    put '    if (counts.amber) parts.push(counts.amber + " watch");';
    put '    if (counts.red) parts.push(counts.red + " breach");';
    put '    html += ''<div class="tile" onclick="RAFRouting.showCategory(&apos;'' + cat.key + ''&apos;)">'';';
    put '    html += ''  <div class="tile-head"><div class="tile-icon">'' + cat.icon + ''</div>'';';
    put '    html += ''    <div><div class="tile-title">'' + escapeHtml(cat.title) + ''</div>'';';
    put '    html += ''    <div class="tile-count">'' + cat.indicatorCount + '' indicators</div></div></div>'';';
    put '    html += ''  <div class="tile-desc">'' + escapeHtml(cat.description) + ''</div>'';';
    put '    html += ''  <div class="tile-split">'';';
    put '    html += ''    <span style="width:'' + pct(counts.green) + ''%; background:var(--good)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.amber) + ''%; background:var(--warning)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.red) + ''%; background:var(--critical)"></span>'';';
    put '    html += ''  </div>'';';
    put '    html += ''  <div class="tile-split-caption">'' + parts.join(" - ") + ''</div>'';';
    put '    html += ''  <div class="tile-foot"><span class="tile-owner">'' + escapeHtml(cat.owner) + ''</span><span class="tile-freq">'' + escapeHtml(cat.frequency) + ''</span></div>'';';
    put '    html += ''</div>'';';
    put '  });';
    put '  html += "</div>";';
    put '  return html;';
    put '}';

    /* ---- Category detail (metric cards - the drill-down/detail report) ---- */
    put 'function buildRafCategoryDetailHTML(categoryKey) {';
    put '  const metrics = appetiteMetricsConfig[categoryKey];';
    put '  const cat = riskCategoriesConfig.find(c => c.key === categoryKey);';
    put '  if (!metrics || !cat) return ''<div class="detail-panel"><p>No metrics configured for this risk area.</p></div>'';';
    put '  const historyCount = RAFHistory.count(categoryKey);';
    put '  let html = ''<div class="detail-panel">'';';
    put '  html += ''  <div class="detail-head"><div>'';';
    put '  html += ''    <h3>'' + escapeHtml(cat.title) + '' - Appetite Metrics</h3>'';';
    put '  html += ''    <div class="detail-meta">'';';
    put '  html += ''      <span>Owner: <b>'' + escapeHtml(cat.owner) + ''</b></span>'';';
    put '  html += ''      <span>Review Committee: <b>'' + escapeHtml(cat.committee) + ''</b></span>'';';
    put '  html += ''      <span>Frequency: <b>'' + escapeHtml(cat.frequency) + ''</b></span>'';';
    put '  html += ''      <span>Period: <b>Q2-2026</b></span>'';';
    put '  html += ''    </div></div>'';';
    put '  html += ''    <div>'';';
    put '  html += ''      <button class="btn" onclick="RAFReports.runCategory(&apos;'' + categoryKey + ''&apos;)">Run Category</button>'';';
    put '  html += ''      <button class="btn ghost" onclick="RAFReports.viewHistory(&apos;'' + categoryKey + ''&apos;)">View History ('' + historyCount + '')</button>'';';
    put '  html += ''    </div>'';';
    put '  html += ''  </div>'';';
    /* No blanket "lower is better" banner any more - direction is read per
       metric straight off its own sheet cells (see rafDataLoader.sas) and
       can legitimately differ within the same Risk Area, so each metric's
       own meter-scale labels (with their own sign) are the source of
       truth instead of a single banner over the whole category. */
    put '  html += ''  <div id="raf-metric-cards-'' + categoryKey + ''">'';';
    put '  html += metrics.map(m => RAFResults.renderMetricCard(m)).join("");';
    put '  html += ''  </div>'';';
    put '  html += ''  <div style="margin-top:4px; display:flex; justify-content:flex-end;">'';';
    put '  html += ''    <button class="btn ghost" onclick="exportMetricCardsToExcel(&apos;'' + categoryKey + ''&apos;)">Export to Excel</button>'';';
    put '  html += ''  </div>'';';
    put '  html += ''</div>'';';
    put '  return html;';
    put '}';

    /* ---- Navbar "Dashboard" dropdown toggle (see components.sas generate_navbar).
       Defined once at page load, like everything else in this file, so it works
       immediately regardless of which route is currently showing - the dropdown
       lives in the permanent navbar, not inside .raf-app. ---- */
    put '// Dashboard nav dropdown open/close (navbar - see components.sas)';
    put 'function raf_toggleDashboardDropdown(event) {';
    put '  if (event) event.stopPropagation();';
    put '  const menu = document.getElementById("rafDashboardDropdownMenu");';
    put '  if (!menu) return;';
    put '  menu.style.display = (menu.style.display === "block") ? "none" : "block";';
    put '}';
    put 'function raf_closeDashboardDropdown() {';
    put '  const menu = document.getElementById("rafDashboardDropdownMenu");';
    put '  if (menu) menu.style.display = "none";';
    put '  raf_closeCroSubmenu();';
    put '}';
    /* "CRO Dashboard" submenu flyout (see components.sas generate_navbar) -
       same click-to-toggle idiom as the top-level dropdown above, just one
       level deeper. Closing the top-level dropdown always closes this too
       (see raf_closeDashboardDropdown), so the existing outside-click/
       Escape listeners below need no changes to cover it. */
    put 'function raf_toggleCroSubmenu(event) {';
    put '  if (event) event.stopPropagation();';
    put '  const sub = document.getElementById("rafCroSubmenuMenu");';
    put '  if (!sub) return;';
    put '  sub.style.display = (sub.style.display === "block") ? "none" : "block";';
    put '}';
    put 'function raf_closeCroSubmenu() {';
    put '  const sub = document.getElementById("rafCroSubmenuMenu");';
    put '  if (sub) sub.style.display = "none";';
    put '}';
    put 'document.addEventListener("click", function (e) {';
    put '  const wrap = document.getElementById("rafDashboardDropdown");';
    put '  if (wrap && !wrap.contains(e.target)) raf_closeDashboardDropdown();';
    put '});';
    put 'document.addEventListener("keydown", function (e) {';
    put '  if (e.key === "Escape") raf_closeDashboardDropdown();';
    put '});';

%mend buildRAF;
