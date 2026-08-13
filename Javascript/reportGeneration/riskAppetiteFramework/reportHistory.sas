/* ============================================================================
   RAF RUN HISTORY MODULE (ERMS-embedded)
   RAFHistory keeps a record, in the browser's own localStorage (never sent
   to any server), of every category run. Reuses ERMS's own shared modal
   (#reportModal / modalTitle / modalBody) rather than a second modal -
   never redefines closeModal()/showNotification(), only calls them.
   ============================================================================ */
%macro generate_report_history;
    put '// RAF Run History Module';
    put 'const raf_historyStorageKey = "raf_run_history";';
    put 'const RAFHistory = {';

    put '  _readAll() {';
    put '    try {';
    put '      const raw = localStorage.getItem(raf_historyStorageKey);';
    put '      return raw ? JSON.parse(raw) : {};';
    put '    } catch (e) { return {}; }';
    put '  },';
    put '  _writeAll(all) {';
    put '    try { localStorage.setItem(raf_historyStorageKey, JSON.stringify(all)); }';
    put '    catch (e) { console.error("Could not write RAF run history:", e); }';
    put '  },';

    put '  // Records a completed run. meta: { reportingDate, metrics, source }';
    put '  recordRun(categoryKey, meta) {';
    put '    const all = this._readAll();';
    put '    if (!all[categoryKey]) all[categoryKey] = [];';
    put '    all[categoryKey].unshift({';
    put '      runAt: new Date().toISOString(),';
    put '      reportingDate: meta.reportingDate,';
    put '      source: meta.source || "live",';
    put '      metrics: meta.metrics';
    put '    });';
    put '    all[categoryKey] = all[categoryKey].slice(0, 25);';
    put '    this._writeAll(all);';
    put '  },';
    put '  getHistory(categoryKey) {';
    put '    return this._readAll()[categoryKey] || [];';
    put '  },';
    put '  count(categoryKey) {';
    put '    return this.getHistory(categoryKey).length;';
    put '  },';

    put '  // Opens ERMS''s shared modal listing every past run for a category, grouped by day';
    put '  view(categoryKey) {';
    put '    const runs = this.getHistory(categoryKey);';
    put '    const modalTitleEl = document.getElementById("modalTitle");';
    put '    const modalBodyEl = document.getElementById("modalBody");';
    put '    const modal = document.getElementById("reportModal");';
    put '    if (!modalTitleEl || !modalBodyEl || !modal) return;';
    put '    modalTitleEl.textContent = RAFUI.getCategoryTitle(categoryKey) + " - Run History";';
    put '    if (!runs.length) {';
    put '      modalBodyEl.innerHTML = ''<p style="color:#6b7280;">No runs recorded yet for this risk area.</p>'';';
    put '      modal.classList.add("show");';
    put '      return;';
    put '    }';
    /* NOTE: this HTML is injected into ERMS's own #reportModal, which sits
       outside the .raf-app scoped container - so it deliberately uses ERMS's
       own .btn/.btn-primary/.btn-secondary classes (not RAF's own button
       styling) and plain inline styles rather than any RAF-only class name,
       so it renders correctly wherever it lands. */
    put '    let html = ''<div style="margin-bottom:12px; text-align:right;">'';';
    put '    html += ''<button class="btn btn-secondary" onclick="RAFHistory.clearAll(&apos;'' + categoryKey + ''&apos;)">Clear All</button></div>'';';
    put '    runs.forEach((run, idx) => {';
    put '      const when = new Date(run.runAt);';
    put '      const dateLabel = when.toLocaleDateString() + " " + when.toLocaleTimeString();';
    put '      html += ''<div style="border:1px solid #e5e7eb; border-radius:10px; padding:12px 14px; margin-bottom:10px; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;">'';';
    put '      html += ''  <div style="font-size:.85rem; color:#374151;"><b>'' + escapeHtml(dateLabel) + ''</b><br/>'';';
    put '      html += ''  Reporting date: '' + escapeHtml(run.reportingDate || "-") + '' - Source: '' + escapeHtml(run.source) + ''</div>'';';
    put '      html += ''  <div style="display:flex; gap:8px;">'';';
    put '      html += ''    <button class="btn btn-primary" onclick="RAFHistory.replay(&apos;'' + categoryKey + ''&apos;,'' + idx + '')">View Results</button>'';';
    put '      html += ''    <button class="btn btn-secondary" onclick="RAFHistory.clearEntry(&apos;'' + categoryKey + ''&apos;,'' + idx + '')">Delete</button>'';';
    put '      html += ''  </div>'';';
    put '      html += ''</div>'';';
    put '    });';
    put '    modalBodyEl.innerHTML = html;';
    put '    modal.classList.add("show");';
    put '  },';

    put '  // Renders a past run''s saved metrics straight back through RAFResults - no';
    put '  // second call to the backend.';
    put '  replay(categoryKey, index) {';
    put '    const runs = this.getHistory(categoryKey);';
    put '    const run = runs[index];';
    put '    if (!run) return;';
    put '    closeModal();';
    put '    RAFRouting.showCategory(categoryKey);';
    put '    setTimeout(() => {';
    put '      RAFReports.applyBackendResult(categoryKey, { metrics: run.metrics });';
    put '      showNotification("Showing a saved run from " + new Date(run.runAt).toLocaleString(), "success");';
    put '    }, 60);';
    put '  },';

    put '  clearEntry(categoryKey, index) {';
    put '    const all = this._readAll();';
    put '    if (all[categoryKey]) { all[categoryKey].splice(index, 1); this._writeAll(all); }';
    put '    this.view(categoryKey);';
    put '  },';
    put '  clearAll(categoryKey) {';
    put '    const all = this._readAll();';
    put '    all[categoryKey] = [];';
    put '    this._writeAll(all);';
    put '    this.view(categoryKey);';
    put '  }';
    put '};';
%mend generate_report_history;
