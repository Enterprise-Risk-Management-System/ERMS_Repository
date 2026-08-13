/* ============================================================================
   ROUTE BUILDER: Risk Appetite Framework (ERMS route #risk-appetite-framework)
   NEW module - registered as one additional key in ERMS's existing routes
   object (see router.sas), reached via the new "CRO Dashboard" item in the
   navbar's Dashboard dropdown (see components.sas). Renders entirely inside
   ERMS's own #main-panel, under ERMS's own navbar/sidebar/page-header -
   this file contributes content only, never a second page shell.

   INTEGRATION RULES THIS FILE FOLLOWS (see also reportGeneration/riskAppetiteFramework/*):
     1. Every CSS rule is scoped under ".raf-app" so it can never affect
        ERMS's own navbar/sidebar/buttons/modal, and ERMS's global CSS can
        never accidentally restyle RAF's content either.
     2. RAF ships NO navbar/sidebar/loading-spinner/notification-banner/modal
        of its own - it reuses ERMS's real ones (showLoading(), hideLoading(),
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
     4. RAF keeps its OWN distinct blue palette (navy/brand/sky gradient) -
        deliberately different from ERMS's blue, so the topbar strip below
        signals "you have entered a distinct, CRO-scoped tool" rather than
        blending in as just another ERMS page.
     5. No real access control exists yet (ERMS has no auth/role layer) - the
        "CRO Only" badge in the topbar is a labeling convention, not
        enforcement. Revisit once ERMS gets role-based access.
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
    put '    RAFUI.setTitle("CRO Risk Appetite Dashboard", "15 risk areas - 64 indicators tracked against Board-approved appetite limits.");';
    put '    raf_updateFilterNote();';
    put '  },';
    put '  showDomains() {';
    put '    this.render(buildRafDomainsHTML());';
    put '    RAFUI.renderBreadcrumb([';
    put '      { label: "CRO Dashboard", onClick: "RAFRouting.showDashboard()" },';
    put '      { label: "Risk Domains" }';
    put '    ]);';
    put '    RAFUI.setTitle("Risk Domains", "15 risk areas grouped into 4 domains - 64 indicators - Q2-2026. Choose a domain to see its risk areas.");';
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
    put '  let html = RAF_STYLE_BLOCK;';
    put '  html += RAF_ICON_DEFS;';
    put '  html += ''<div class="raf-app">'';';
    put '  html += ''  <div class="raf-topbar">'';';
    put '  html += ''    <div class="raf-topbar-brand">'';';
    put '  html += ''      <svg width="26" height="26" viewBox="0 0 32 32" fill="none" aria-hidden="true">'';';
    put '  html += ''        <path d="M9 17 L14 9 L18 13 L24 5" stroke="#ffffff" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>'';';
    put '  html += ''        <circle cx="24" cy="5" r="2.3" fill="#8fd0f7"/>'';';
    put '  html += ''      </svg>'';';
    put '  html += ''      <span>Risk Appetite Framework</span>'';';
    put '  html += ''    </div>'';';
    put '  html += ''    <span class="raf-cro-badge">CRO Only</span>'';';
    put '  html += ''  </div>'';';
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

    /* ---- Zone 1-4 dashboard shell (filter bar + zone panels) ---- */
    put 'function buildRafDashboardHTML() {';
    put '  let html = "";';
    put '  html += ''<div class="filter-panel">'';';
    put '  html += ''  <div class="filter-fields">'';';
    put '  html += ''    <div class="filter-field"><label for="rafFrequency">Frequency</label>'';';
    put '  html += ''      <select id="rafFrequency" onchange="raf_updateFilterNote()">'';';
    put '  html += ''        <option>Daily</option><option selected>Quarterly</option><option>Monthly</option>'';';
    put '  html += ''      </select>'';';
    put '  html += ''    </div>'';';
    put '  html += ''    <div class="filter-field"><label for="rafCriticality">Criticality</label>'';';
    put '  html += ''      <select id="rafCriticality" onchange="raf_updateFilterNote()">'';';
    put '  html += ''        <option selected>All</option><option>Level 1</option><option>Level 2A</option><option>Level 2B</option>'';';
    put '  html += ''      </select>'';';
    put '  html += ''    </div>'';';
    put '  html += ''    <div class="filter-field"><label for="rafRiskArea">Risk Area</label>'';';
    put '  html += ''      <select id="rafRiskArea" onchange="raf_updateFilterNote()">'';';
    put '  html += ''        <option selected>All</option>'';';
    put '  html += riskCategoriesConfig.map(c => ''<option>'' + escapeHtml(c.title) + ''</option>'').join("");';
    put '  html += ''      </select>'';';
    put '  html += ''    </div>'';';
    put '  html += ''  </div>'';';
    put '  html += ''  <div class="note-box">'';';
    put '  html += ''    <div class="note-box-title">Note on the dashboard</div>'';';
    put '  html += ''    <div class="note-line">Frequency, when selected as <b>Daily</b> - displays the last 31 days / until today (whichever is lower)</div>'';';
    put '  html += ''    <div class="note-line">Frequency, when selected as <b>Monthly</b> - displays the last 12 months of the current reporting year</div>'';';
    put '  html += ''    <div class="note-line">Frequency, when selected as <b>Quarter</b> - displays the last 4 quarters of the current reporting year</div>'';';
    put '  html += ''  </div>'';';
    put '  html += ''  <div class="filter-note" id="rafFilterNote"></div>'';';
    put '  html += ''</div>'';';

    put '  html += ''<div class="zone-panel"><div class="zone-head"><h3>Critical Risk Indicators</h3></div>'';';
    put '  html += ''  <div class="zone-body">'';';
    put '  html += ''    <p class="zone-desc">Top indicators marked for the CRO dashboard. Each card shows the Reporting Date vs. Value across the last 3 periods. Click a card to open its full metric detail.</p>'';';
    put '  html += ''    <div class="ind-grid">'' + RAFDashboardView.renderCriticalIndicators() + ''</div>'';';
    put '  html += ''  </div></div>'';';

    put '  html += ''<div class="zone-panel"><div class="zone-head"><h3>Risk Indicator Heatmap - by Criticality</h3></div>'';';
    put '  html += ''  <div class="zone-body">'';';
    put '  html += ''    <p class="zone-desc">Number of risk indicators in Green, Amber and Red zones, by criticality level, over the last 4 reporting periods.</p>'';';
    put '  html += filterBarHtml("raf-heatmap-table");';
    put '  html += ''    <div style="overflow-x:auto;">'' + RAFDashboardView.renderHeatmapByCriticality().replace(''<table class="heatmap-table">'', ''<table class="heatmap-table" id="raf-heatmap-table">'') + ''</div>'';';
    put '  html += ''    <div style="margin-top:10px; text-align:right;"><button class="btn" onclick="exportTableToExcel(&apos;raf-heatmap-table&apos;,&apos;Heatmap by Criticality&apos;,&apos;RAF_Heatmap&apos;)">Export to Excel</button></div>'';';
    put '  html += ''  </div></div>'';';

    put '  html += ''<div class="zone-panel"><div class="zone-head"><h3>Risk Indicator Treemap - by Ownership</h3>'';';
    put '  html += ''  <div class="zone-select"><label for="rafOwner">Ownership</label>'';';
    put '  html += ''    <select id="rafOwner" onchange="raf_updateTreemapOwner(this)">'';';
    put '  html += croDashboardConfig.ownershipOptions.map(o => ''<option>'' + escapeHtml(o) + ''</option>'').join("");';
    put '  html += ''    </select>'';';
    put '  html += ''  </div></div>'';';
    put '  html += ''  <div class="zone-body">'';';
    put '  html += ''    <p class="zone-desc">Number of risk indicators in Green, Amber and Red zones for the selected owner, across the last 4 reporting periods.</p>'';';
    put '  html += ''    <div id="rafTreemapZoneBody">'' + RAFDashboardView.renderTreemapByOwnership(croDashboardConfig.ownershipOptions[0]) + ''</div>'';';
    put '  html += ''  </div></div>'';';

    put '  html += ''<div class="zone-panel"><div class="zone-head"><h3>Risk Indicator Trend Analysis - by Pillar</h3></div>'';';
    put '  html += ''  <div class="zone-body">'';';
    put '  html += ''    <p class="zone-desc">Count of indicators in Watch or Breach (Amber + Red), Pillar 1 vs. Pillar 2, over the last 4 reporting periods.</p>'';';
    put '  html += RAFDashboardView.renderTrendByPillar();';
    put '  html += ''  </div></div>'';';
    put '  return html;';
    put '}';

    put 'function raf_updateFilterNote() {';
    put '  const freqEl = document.getElementById("rafFrequency");';
    put '  const critEl = document.getElementById("rafCriticality");';
    put '  const areaEl = document.getElementById("rafRiskArea");';
    put '  const note = document.getElementById("rafFilterNote");';
    put '  if (!freqEl || !note) return;';
    put '  const periodEnd = { Daily: RAFUtils.getTodayDate(), Monthly: "2026-06-30", Quarterly: "2026-06-30" };';
    put '  const freq = freqEl.value, crit = critEl.value, area = areaEl.value;';
    put '  note.innerHTML = "Filter selection: report generated for the period <b>" + freq + " - "';
    put '    + RAFUtils.formatDate(periodEnd[freq]) + "</b>, <b>" + crit + "</b> Criticality, showing <b>"';
    put '    + area + "</b> Risk Area" + (area === "All" ? "s" : "") + ".";';
    put '}';
    put 'function raf_updateTreemapOwner(select) {';
    put '  const body = document.getElementById("rafTreemapZoneBody");';
    put '  if (body) body.innerHTML = RAFDashboardView.renderTreemapByOwnership(select.value);';
    put '}';

    /* ---- Risk Domains (4 grouping cards) ---- */
    put 'function buildRafDomainsHTML() {';
    put '  let html = ''<div class="domain-grid">'';';
    put '  riskDomainsConfig.forEach(domain => {';
    put '    const counts = domain.ragSplitPlaceholder;';
    put '    const total = counts.good + counts.watch + counts.breach + counts.regulatoryBreach;';
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
    put '    html += ''    <span style="width:'' + pct(counts.good) + ''%; background:var(--good)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.watch) + ''%; background:var(--warning)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.breach) + ''%; background:var(--serious)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.regulatoryBreach) + ''%; background:var(--critical)"></span>'';';
    put '    html += ''  </div>'';';
    put '    html += ''  <div class="domain-split-caption">'' + counts.good + '' within appetite - '' + counts.watch + '' watch - ''';
    put '      + counts.breach + '' breach - '' + counts.regulatoryBreach + '' regulatory breach</div>'';';
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
    put '    const counts = cat.ragSplitPlaceholder;';
    put '    const total = counts.good + counts.watch + counts.breach + counts.regulatoryBreach;';
    put '    const pct = n => total ? ((n / total) * 100).toFixed(1) : 0;';
    put '    const parts = [];';
    put '    if (counts.good) parts.push(counts.good + " within appetite");';
    put '    if (counts.watch) parts.push(counts.watch + " watch");';
    put '    if (counts.breach) parts.push(counts.breach + " breach");';
    put '    if (counts.regulatoryBreach) parts.push(counts.regulatoryBreach + " regulatory breach");';
    put '    html += ''<div class="tile" onclick="RAFRouting.showCategory(&apos;'' + cat.key + ''&apos;)">'';';
    put '    html += ''  <div class="tile-head"><div class="tile-icon">'' + cat.icon + ''</div>'';';
    put '    html += ''    <div><div class="tile-title">'' + escapeHtml(cat.title) + ''</div>'';';
    put '    html += ''    <div class="tile-count">'' + cat.indicatorCount + '' indicators</div></div></div>'';';
    put '    html += ''  <div class="tile-desc">'' + escapeHtml(cat.description) + ''</div>'';';
    put '    html += ''  <div class="tile-split">'';';
    put '    html += ''    <span style="width:'' + pct(counts.good) + ''%; background:var(--good)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.watch) + ''%; background:var(--warning)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.breach) + ''%; background:var(--serious)"></span>'';';
    put '    html += ''    <span style="width:'' + pct(counts.regulatoryBreach) + ''%; background:var(--critical)"></span>'';';
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
    put '  html += ''  <div class="direction-note">Lower is better - placeholder direction, applies to all bands below</div>'';';
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
    put '}';
    put 'document.addEventListener("click", function (e) {';
    put '  const wrap = document.getElementById("rafDashboardDropdown");';
    put '  if (wrap && !wrap.contains(e.target)) raf_closeDashboardDropdown();';
    put '});';
    put 'document.addEventListener("keydown", function (e) {';
    put '  if (e.key === "Escape") raf_closeDashboardDropdown();';
    put '});';

%mend buildRAF;
