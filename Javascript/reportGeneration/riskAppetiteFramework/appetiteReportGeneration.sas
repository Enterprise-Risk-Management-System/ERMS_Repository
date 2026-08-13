/* ============================================================================
   RAF REPORT GENERATION MODULE (ERMS-embedded)
   RAFReports runs a category's data pull against RAF_Metrics_Backend, using
   the same plain fetch() pattern ERMS's own fetchJson() already uses (see
   Javascript/api_Integration/croDashboard/cro_dashboard_api.sas) rather than
   introducing a second HTTP-handling convention. Calls ERMS's own
   showLoading()/hideLoading()/showNotification() globals directly.
   ============================================================================ */
%macro generate_appetite_report_generation;
    put '// RAF Report Generation Module';
    put 'const raf_metricsEndpoint = "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Risk Appetite Framework/RAF_Metrics_Backend";';

    put 'const RAFReports = {';

    put '  // Runs (or re-runs) a category''s data pull against RAF_Metrics_Backend.sas.';
    put '  runCategory(categoryKey, reportingDate) {';
    put '    const metrics = appetiteMetricsConfig[categoryKey];';
    put '    if (!metrics) { showNotification("No metrics configured for this risk area.", "error"); return; }';
    put '    const date = reportingDate || RAFUtils.getTodayDate();';
    put '    showLoading();';
    put '    fetch(raf_metricsEndpoint, {';
    put '      method: "POST",';
    put '      body: new URLSearchParams({ risk_area: categoryKey, reporting_date: date })';
    put '    })';
    put '      .then(function (response) {';
    put '        if (!response.ok) throw new Error("Network response was not ok: " + response.status);';
    put '        return response.json();';
    put '      })';
    put '      .then(function (data) {';
    put '        hideLoading();';
    put '        RAFReports.applyBackendResult(categoryKey, data);';
    put '        RAFHistory.recordRun(categoryKey, { reportingDate: date, metrics: data.metrics && data.metrics.length ? data.metrics : metrics, source: "live" });';
    put '        showNotification(RAFUI.getCategoryTitle(categoryKey) + " updated.", "success");';
    put '      })';
    put '      .catch(function (err) {';
    put '        hideLoading();';
    put '        console.error("RAF_Metrics_Backend call failed:", err);';
    put '        showNotification("Could not reach the backend - showing the last configured values instead.", "warning");';
    put '        RAFReports.applyBackendResult(categoryKey, { metrics: metrics });';
    put '        RAFHistory.recordRun(categoryKey, { reportingDate: date, metrics: metrics, source: "fallback" });';
    put '      });';
    put '  },';

    put '  // Re-renders a category''s metric cards from a { metrics: [...] } payload - shared';
    put '  // by the live-success path, the offline-fallback path, and RAFHistory''s replay.';
    put '  applyBackendResult(categoryKey, data) {';
    put '    const container = document.getElementById("raf-metric-cards-" + categoryKey);';
    put '    if (!container) return;';
    put '    const metrics = (data.metrics && data.metrics.length) ? data.metrics : (appetiteMetricsConfig[categoryKey] || []);';
    put '    container.innerHTML = metrics.map(function (m) { return RAFResults.renderMetricCard(m); }).join("");';
    put '  },';

    put '  viewHistory(categoryKey) {';
    put '    RAFHistory.view(categoryKey);';
    put '  }';
    put '};';
%mend generate_appetite_report_generation;
