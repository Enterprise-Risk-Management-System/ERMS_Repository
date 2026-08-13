

/* ============================================================================
   JAVASCRIPT API
   ============================================================================ */


/* ============================================================================
   JAVASCRIPT UTILITIES
   ============================================================================ */
%macro generate_javascript_utils;
    put '<script>';
    put 'function showLoading() { document.getElementById("loading").style.display = "flex"; }';

    put 'function hideLoading() { document.getElementById("loading").style.display = "none"; }';

    put 'function showNotification(message, type) {';
    put '  if (!type) type = "success";';
    put '  var notification = document.getElementById("notification");';
    put '  var notificationText = document.getElementById("notification-text");';
    put '  notification.className = "notification " + type;';
    put '  notificationText.textContent = message;';
    put '  notification.classList.add("show");';
    put '  setTimeout(function() { notification.classList.remove("show"); }, 4000);';
    put '}';

    put 'function closeModal() { document.getElementById("reportModal").classList.remove("show"); }';
    put '</script>';
%mend generate_javascript_utils;



/* ============================================================================
   JAVASCRIPT EVENT HANDLERS
   ============================================================================ */
%macro generate_javascript_events;
    put '<script>';
    put 'document.addEventListener("DOMContentLoaded", function() {';
    put '  initializeDashboard();';
    put '  setupEventListeners();';
/*    put '  animateStats();';*/
    put '});';
    put 'function initializeDashboard() { console.log("ERMS Dashboard initialized"); }';
    put 'function setupEventListeners() {';
    put '  var riskModules = document.querySelectorAll(".risk-module");';
    put '  for (var i = 0; i < riskModules.length; i++) {';
    put '    riskModules[i].addEventListener("click", function() {';
    put '      var moduleType = this.getAttribute("data-module");';
    put '      generateReport(moduleType);';
    put '    });';
    put '  }';
    put '}';
    put 'function generateReport(moduleType) {';
    put '  showLoading();';
    put '  ermsDashboardApi.generateReport(moduleType, {';
    put '    report_date: new Date().toISOString(),';
    put '    user_id: "current_user",';
    put '    parameters: "default"';
    put '  }).then(function(result) {';
    put '    hideLoading();';
    put '    showNotification("Report generated successfully! (" + result.processingTime + "ms)");';
    put '    displayReportDetails(result);';
    put '    updateStats();';
    put '  }).catch(function(error) {';
    put '    hideLoading();';
    put '    showNotification("Error generating report: " + error.message, "error");';
    put '  });';
    put '}';
    put '</script>';
%mend generate_javascript_events;



/* ============================================================================
   JAVASCRIPT API INTEGRATION
   ============================================================================ */



%macro generate_javascript_api_integ();
    put '<script>';
    put 'const dashboardApiEndpoints = Object.freeze({';
    put '  limitCompliance: "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Market Risk/API_Handler",';
    put '  loanPortfolio: "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Market Risk/Loan Portfolio API"';
    put '});';
   
    put 'function fetchJson(url) {';
    put '  return fetch(url)';
    put '    .then(function (response) {';
    put '      if (!response.ok) {';
    put '        throw new Error("Network response was not ok: " + response.status);';
    put '      }';
    put '      return response.json();';
    put '    })';
    put '    .then(function (data) {';
    put '      if (data.status === "success") {';
    put '        return data;';
    put '      }';
    put '      throw new Error(data.error_message || "Failed to fetch data");';
    put '    });';
    put '}';

    put 'const ermsDashboardApi = {';
    put '  getLimitCompliance: function () {';
    put '    return fetchJson(dashboardApiEndpoints.limitCompliance);';
    put '  },';
    put '  getLoanPortfolio: function () {';
    put '    return fetchJson(dashboardApiEndpoints.loanPortfolio);';
    put '  },';
    put '  getDashboardData: function () {';
    put '    return Promise.all([';
    put '      this.getLimitCompliance(),';
    put '      this.getLoanPortfolio()';
    put '    ]).then(function (responses) {';
    put '      return {';
    put '        limit_compliance: responses[0],';
    put '        loan_portfolio: responses[1]';
    put '      };';
    put '    });';
    put '  }';
    put '};';

    put 'function refreshDashboardData() {';
    put '  showLoading();';
    put '  ermsDashboardApi.getDashboardData()';
    put '    .then(function (data) {';
    put '      updateDashboardTables(data);';
    put '      hideLoading();';
    put '      showNotification("Dashboard data refreshed successfully", "success");';
    put '    })';
    put '    .catch(function (error) {';
    put '      hideLoading();';
    put '      showNotification("Error refreshing dashboard data: " + error.message, "error");';
    put '    });';
    put '}';

    put 'function updateDashboardTables(data) {';
    put '  if (data.limit_compliance) {';
    put '    updateLimitComplianceTable(data.limit_compliance);';
    put '  }';
    put '  if (data.loan_portfolio) {';
    put '    updateLoanPortfolioTable(data.loan_portfolio);';
    put '  }';
    put '}';

    put 'function asRecordArray(data) {';
    put '  if (Array.isArray(data)) {';
    put '    return data;';
    put '  }';
    put '  if (data && Array.isArray(data.data)) {';
    put '    return data.data;';
    put '  }';
    put '  return [];';
    put '}';

    put 'function updateLimitComplianceTable(data) {';
    put '  const tableBody = document.getElementById("limit-compliance-tbody");';
    put '  if (!tableBody) {';
    put '    return;';
    put '  }';
    put '  const records = asRecordArray(data);';
    put '  if (!records.length) {';
    put '    tableBody.innerHTML = buildNoDataRow(7);';
    put '    return;';
    put '  }';
    put '  const rows = records.map(function (item) {';
    put '    let html = "<tr>";';
    put '    html += "<td>" + (item.limit_type || "") + "</td>";';
    put '    html += "<td>" + (item.limit_sama || "") + "</td>";';
    put '    html += "<td>" + (item.limit_board || "") + "</td>";';
    put '    html += "<td>" + (item.mat_alco || "") + "</td>";';
    put '    html += "<td>" + (item.mat_cro || "") + "</td>";';
    put '    html += "<td>" + (item.current_value || "") + "</td>";';
    put '    html += "<td><span class=\"status-badge " + getStatusClass(item.compliance_status) + "\">" + (item.compliance_status || "") + "</span></td>";';
    put '    html += "</tr>";';
    put '    return html;';
    put '  });';   /* <-- closes the function and map */

    put '  tableBody.innerHTML = rows.join("");';
    put '}';

    put 'function updateLoanPortfolioTable(data) {';
    put '  const tableBody = document.getElementById("loan-portfolio-tbody");';
    put '  if (!tableBody) {';
    put '    return;';
    put '  }';
    put '  const records = asRecordArray(data);';
    put '  if (!records.length) {';
    put '    tableBody.innerHTML = buildNoDataRow(14);';
    put '    return;';
    put '  }';
    put '  const rows = records.map(function(item) {';
    put '    let html = "<tr>";';
    put '    html += "<td>" + (item.loan_category || "") + "</td>";';
    put '    html += "<td>" + formatNumber(item.nb_of_customers) + "</td>";';
    put '    html += "<td>" + (item.fair_value_sar || "") + "</td>";';
    put '    html += "<td>" + formatPercentage(item.weighted_average_rate) + "</td>";';
    put '    html += "<td>" + formatNumber(item.weighted_average_remaining_tenor) + " months</td>";';
    put '    html += "<td>" + (item["<1Y"] || "") + "</td>";';
    put '    html += "<td>" + (item["1-3 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["3-5 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["5-7 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["7-10 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["10-12 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["12-15 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["15-20 Years"] || "") + "</td>";';
    put '    html += "<td>" + (item["20+ Years"] || "") + "</td>";';
    put '    html += "</tr>";';
    put '    return html;';
    put '  });';
    put '  tableBody.innerHTML = rows.join("");';
    put '}';

    put 'function buildNoDataRow(colspan) {';
    put '  return "<tr><td colspan=\"" + colspan + "\" style=\"text-align: center; padding: 20px; color: #6b7280;\">No data available</td></tr>";';
    put '}';


    put 'function formatNumber(value) {';
    put '  if (value === undefined || value === null) {';
    put '    return "0";';
    put '  }';
    put '  const num = parseFloat(String(value).replace(/[^\d.-]/g, ""));';
    put '  if (Number.isNaN(num)) {';
    put '    return "0";';
    put '  }';
    put '  return num.toLocaleString();';
    put '}';

    put 'function formatCurrency(value) {';
    put '  if (value === undefined || value === null) {';
    put '    return "SAR 0";';
    put '  }';
    put '  const num = parseFloat(String(value).replace(/[^\d.-]/g, ""));';
    put '  if (Number.isNaN(num)) {';
    put '    return "SAR 0";';
    put '  }';
    put '  if (Math.abs(num) >= 1e9) {';
    put '    return "SAR " + (num / 1e9).toFixed(2) + "B";';
    put '  }';
    put '  if (Math.abs(num) >= 1e6) {';
    put '    return "SAR " + (num / 1e6).toFixed(2) + "M";';
    put '  }';
    put '  if (Math.abs(num) >= 1e3) {';
    put '    return "SAR " + (num / 1e3).toFixed(2) + "K";';
    put '  }';
    put '  return "SAR " + num.toLocaleString();';
    put '}';
 
    put 'function formatPercentage(value) {';
    put '  if (value === undefined || value === null) {';
    put '    return "0%";';
    put '  }';
    put '  const num = parseFloat(String(value).replace(/[^\d.-]/g, ""));';
    put '  if (Number.isNaN(num)) {';
    put '    return "0%";';
    put '  }';
    put '  return (num * 100).toFixed(2) + "%";';
    put '}';
  
    put 'function getStatusClass(status) {';
    put '  if (!status) {';
    put '    return "warning";';
    put '  }';
    put '  switch (status.toLowerCase()) {';
    put '    case "ok":';
    put '      return "compliant";';
    put '    case "warning":';
    put '      return "warning";';
    put '    case "critical":';
    put '      return "danger";';
    put '    default:';
    put '      return "warning";';
    put '  }';
    put '}';

    put 'setInterval(function () {';
    put '  if (currentRoute === "#dashboard") {';
    put '    refreshDashboardData();';
    put '  }';
    put '}, 300000);';
    put '</script>';
%mend generate_javascript_api_integ;

/* ============================================================================
   JAVASCRIPT MODAL HANDLERS
   ============================================================================ */
%macro generate_javascript_modal;
    put '<script>';
    put 'function displayReportDetails(reportResult) {';
    put '  var modal = document.getElementById("reportModal");';
    put '  var modalTitle = document.getElementById("modalTitle");';
    put '  var modalBody = document.getElementById("modalBody");';
    put '  modalTitle.textContent = reportResult.reportName;';
    put '  var summary = reportResult.data.summary;';
    put '  var details = reportResult.data.details;';
    put '  var html = "<div style=\"display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px;\">";';
    put '  for (var key in summary) {';
    put '    if (summary.hasOwnProperty(key)) {';
    put '      html += "<div style=\"background: #f9fafb; padding: 15px; border-radius: 8px; text-align: center;\">";';
    put '      html += "<div style=\"font-size: 1.5rem; font-weight: 700; color: #1f2937; margin-bottom: 5px;\">" + formatValue(summary[key]) + "</div>";';
    put '      html += "<div style=\"font-size: 0.9rem; color: #6b7280; text-transform: uppercase; letter-spacing: 0.5px;\">" + formatLabel(key) + "</div>";';
    put '      html += "</div>";';
    put '    }';
    put '  }';
    put '  html += "</div><div style=\"margin-top: 20px;\">";';
    put '  html += "<h4 style=\"color: #1f2937; margin-bottom: 15px;\">Report Details</h4>";';
    put '  html += "<pre style=\"background: #f7fafc; padding: 15px; border-radius: 8px; overflow-x: auto; font-size: 0.9rem;\">" + JSON.stringify(details, null, 2) + "</pre>";';
    put '  html += "</div>";';
    put '  modalBody.innerHTML = html;';
    put '  modal.classList.add("show");';
    put '}';
    put 'function formatValue(value) {';
    put '  if (typeof value === "number") {';
    put '    if (value >= 1000000) {';
    put '      return "$" + (value / 1000000).toFixed(1) + "M";';
    put '    } else if (value >= 1000) {';
    put '      return value.toLocaleString();';
    put '    } else {';
    put '      return value.toFixed(1);';
    put '    }';
    put '  }';
    put '  return value;';
    put '}';
    put 'function formatLabel(key) {';
    put '  return key.replace(/([A-Z])/g, " $1").replace(/^./, function(str) { return str.toUpperCase(); });';
    put '}';
    put 'document.getElementById("reportModal").addEventListener("click", function(e) {';
    put '  if (e.target === this) {';
    put '    closeModal();';
    put '  }';
    put '});';
    put '</script>';
%mend generate_javascript_modal;

%macro generate_route_container;
    put '<div class="dashboard-grid">';
    put '<div id="main-panel" class="main-panel">';
    put '<!-- Content will be loaded dynamically by JavaScript -->';
    put '</div>';
    put '</div>';
%mend generate_route_container;


/* ============================================================================
   JAVASCRIPT ROUTING SYSTEM
   ============================================================================ */
%macro generate_javascript_routing;
    put '<script>';
    put '// Global routing variables';
    put 'var currentRoute = "#dashboard";';
    put 'var routes = {';
    put '  "#dashboard": getDashboardTableHTML,';
    put '  "#risk-categories": getRiskCategoriesHTML,';
    put '  "#analytics": getAnalyticsHTML,';
    put '  "#regulatory-reports": getRegulatoryReportsHTML,';
    put '  "#saibor-saibid": getSaiborHTML';
    put '};';
    put '// Main routing function';
    put 'function showRoute(route) {';
    put '  console.log("Navigating to:", route);';
    put '  currentRoute = route;';
    put '  updateContent();';
    put '  // Update URL without page reload';
    put '  if (window.history && window.history.pushState) {';
    put '    window.history.pushState(null, null, route);';
    put '  }';
    put '}';
    put '// Update content based on current route';
    put 'function updateContent() {';
    put '  var mainPanel = document.getElementById("main-panel");';
    put '  if (!mainPanel) return;';
    put '  var routeFunction = routes[currentRoute];';
    put '  if (routeFunction && typeof routeFunction === "function") {';
    put '    mainPanel.innerHTML = routeFunction();';
    put '    // Initialize route-specific functionality';
    put '    initializeRouteFunctionality();';
    put '  } else {';
    put '    mainPanel.innerHTML = "<div style=\"text-align: center; padding: 50px;\"><h2>Page Not Found</h2><p>The requested page could not be found.</p></div>";';
    put '  }';
    put '}';
    put '// Initialize route-specific functionality';
    put 'function initializeRouteFunctionality() {';
    put '  if (currentRoute === "#dashboard") {';
    put '    // Load API data for dashboard';
    put '    setTimeout(function() {';
    put '      refreshDashboardData();';
    put '    }, 100);';
    put '  }';
    put '}';
    put '// Handle browser back/forward buttons';
    put 'window.addEventListener("popstate", function() {';
    put '  currentRoute = window.location.hash || "#dashboard";';
    put '  updateContent();';
    put '});';
    put '// Initialize on page load';
    put 'document.addEventListener("DOMContentLoaded", function() {';
    put '  currentRoute = window.location.hash || "#dashboard";';
    put '  updateContent();';
    put '});';
    put '</script>';
%mend generate_javascript_routing;


%macro generate_js_dashboard_builders;

    put 'function getDashboardTableHTML() {';
    put '  const sections = [';
    put '    buildSectionTitle("Risk Dashboard Overview"),';
    put '    buildDashboardTable(dashboardTableConfig.limitCompliance),';
    put '    buildDashboardTable(dashboardTableConfig.loanPortfolio)';
    put '  ];';
    put '  return sections.join("");';
    put '}';
    
    put 'function buildSectionTitle(title) {';
    put '  return "<h2 style=\"margin-bottom: 20px; color: #1f2937; font-size: 1.5rem;\">" + title + "</h2>";';
    put '}';
    
    put 'function buildDashboardTable(config) {';
    put '  const headerRow = config.headers.map(function (header) {';
    put '    return "<th>" + header + "</th>";';
    put '  }).join("");';
    put '  let html = "<div class=\"dashboard-table-container\" style=\"margin-bottom: 30px;\">";';
    put '  html += "<h3 style=\"margin-bottom: 15px; color: #374151; font-size: 1.2rem;\">" + config.title + "</h3>";';
    put '  html += "<table class=\"dashboard-table\"" + (config.tableId ? " id=\"" + config.tableId + "\"" : "") + ">";';
    put '  html += "<thead><tr>" + headerRow + "</tr></thead>";';
    put '  html += "<tbody id=\"" + config.bodyId + "\">" + buildLoadingRow(config.headers.length) + "</tbody>";';
    put '  html += "</table></div>";';
    put '  return html;';
    put '}';
    
    put 'function buildLoadingRow(colspan) {';
    put '  return "<tr><td colspan=\"" + colspan + "\" style=\"text-align: center; padding: 20px; color: #6b7280;\">Loading data...</td></tr>";';
    put '}';
    
    put 'function getRiskCategoriesHTML() {';
    put '  const modules = riskModulesConfig.map(buildRiskModuleCard).join("");';
    put '  return buildSectionTitle("Risk Categories") + "<div class=\"risk-modules\">" + modules + "</div>";';
    put '}';
    
    put 'function buildRiskModuleCard(config) {';
    put '  const stats = (config.stats || []).map(buildModuleStat).join("");';
    put '  const routeAttr = config.route ? " onclick=\"showRoute(&apos;" + config.route + "&apos;)\"" : "";';
    put '  let html = "<div class=\"risk-module\" data-module=\"" + config.key + "\" " + routeAttr + ">";';
    put '  html += "<div class=\"module-header\">";';
    put '  html += "<div class=\"module-icon " + config.key + "\"><i class=\"" + config.iconClass + "\"></i></div>";';
    put '  html += "<h3 class=\"module-title\">" + config.title + "</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=\"module-description\">" + config.description + "</p>";';
    put '  html += "<div class=\"module-stats\">" + stats + "</div>";';
    put '  html += "</div>";';
    put '  return html;';
    put '}';
    
    put 'function buildModuleStat(stat) {';
    put '  return "<div class=\"stat-item\"><div class=\"stat-value\">" + stat.value + "</div><div class=\"stat-label\">" + stat.label + "</div></div>";';
    put '}';
    
    put 'function getAnalyticsHTML() {';
    put '  return "<h2 style=\"margin-bottom: 20px; color: #1f2937; font-size: 1.5rem;\">Analytics Dashboard</h2><div style=\"text-align: center; padding: 50px;\"><h3>Analytics Module</h3><p>Advanced analytics and reporting features coming soon.</p></div>";';
    put '}';
    

%mend generate_js_dashboard_builders;


/* ============================================================================
   Module: js_regulatory_reports.sas
   Description: Regulatory reports HTML generators (SAIBOR, SAMA Q17, SAMA P3)
   Dependencies: js_helpers.sas, js_config.sas
   ============================================================================ */

%macro generate_js_regulatory_reports;
  
    put 'function getSaiborHTML() {';
    put '  const today = new Date().toISOString().split("T")[0];';
    put '  let html = "<div style=\"max-width: 1200px; margin: 0 auto; padding: 20px;\">";';
    put '  html += "<div style=\"background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer;\" onmouseover=\"this.style.transform=\''translateY(-3px)\''; this.style.boxShadow=\''0 8px 25px rgba(0, 0, 0, 0.15)\''; this.style.borderColor=\''#3b82f6\'';\" onmouseout=\"this.style.transform=\''translateY(0)\''; this.style.boxShadow=\''0 4px 15px rgba(0, 0, 0, 0.08)\''; this.style.borderColor=\''transparent\'';\" data-report=\"Saibor\">";';
    put '  html += "<div style=\"display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px;\">";';
    put '  html += "<div style=\"width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; flex-shrink: 0;\"><i class=\"fas fa-chart-bar\"></i></div>";';
    put '  html += "<div style=\"flex: 1;\"><h3 style=\"font-size: 1.3rem; font-weight: 600; color: #1f2937; margin-bottom: 8px;\">SAIBOR</h3><p style=\"color: #6b7280; font-size: 0.9rem; line-height: 1.5;\">Daily regulatory report for Saibor Submission.</p></div>";';
    put '  html += "</div>";';
    put '  html += "<div style=\"margin-bottom: 20px; padding: 15px; background: #f9fafb; border-radius: 8px;\">";';
    put '  html += "<div style=\"display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;\"><span style=\"font-weight: 500; color: #374151;\">Frequency:</span><span style=\"color: #6b7280;\">Daily</span></div>";';
    put '  html += "<div style=\"display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;\"><span style=\"font-weight: 500; color: #374151;\">Submission Date:</span><span id=\"saibor-date-display\" style=\"color: #6b7280; font-weight: 600;\">" + today + "</span></div>";';
    put '  html += "<input type=\"hidden\" id=\"saibor-date\" value=\"" + today + "\">";';
    put '  html += "</div>";';
    put '  html += "<div style=\"display: flex; gap: 10px;\"><button onclick=\"generateRegulatoryReport(''saibor'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;\">Generate Report</button>";';
    put '  html += "<button onclick=\"viewReportHistory(''saibor'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;\">View History</button></div>";';
    put '  html += "</div></div>";';
    put '  return html;';
    put '}';
    
    put 'function getRegulatoryReportsHTML() {';
    put '  const cards = regulatoryReportsConfig.map(buildRegulatoryReportCard).join("");';
    put '  return "<div style=\"max-width: 1200px; margin: 0 auto; padding: 20px;\"><div style=\"display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px; margin-bottom: 30px;\">" + cards + "</div></div>";';
    put '}';
    
    put 'function buildRegulatoryReportCard(config) {';
    put '  let html = "<div style=\"background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer;\" onmouseover=\"this.style.transform=\''translateY(-3px)\''; this.style.boxShadow=\''0 8px 25px rgba(0, 0, 0, 0.15)\''; this.style.borderColor=\''#3b82f6\'';\" onmouseout=\"this.style.transform=\''translateY(0)\''; this.style.boxShadow=\''0 4px 15px rgba(0, 0, 0, 0.08)\''; this.style.borderColor=\''transparent\'';\" data-report=\"" + config.key + "\">";';
    put '  html += "<div style=\"display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px;\"><div style=\"width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; flex-shrink: 0;\"><i class=\"" + config.iconClass + "\"></i></div>";';
    put '  html += "<div style=\"flex: 1;\"><h3 style=\"font-size: 1.3rem; font-weight: 600; color: #1f2937; margin-bottom: 8px;\">" + config.title + "</h3><p style=\"color: #6b7280; font-size: 0.9rem; line-height: 1.5;\">" + config.description + "</p></div></div>";';
    put '  html += "<div style=\"margin-bottom: 20px; padding: 15px; background: #f9fafb; border-radius: 8px;\">";';
    put '  html += "<div style=\"display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;\"><span style=\"font-weight: 500; color: #374151;\">Frequency:</span><span style=\"color: #6b7280;\">" + config.frequency + "</span></div>";';
    put '  html += "<div style=\"display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;\"><span style=\"font-weight: 500; color: #374151;\">As of Date:</span><input type=\"date\" id=\"" + config.key + "-date\" style=\"color: #6b7280; border: none; background: transparent; font-size: 14px;\"></div>";';
    put '  html += "<div style=\"display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;\"><span style=\"font-weight: 500; color: #374151;\">Latest Date Available:</span><span style=\"color: #6b7280;\">" + config.latestDate + "</span></div>";';
    put '  html += "</div>";';
    put '  html += "<div style=\"display: flex; gap: 10px;\">";';
    put '  html += "<button onclick=\"generateRegulatoryReport(''" + config.key + "'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;\">Generate Report</button>";';
    put '  html += "<button onclick=\"viewReportHistory(''" + config.key + "'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;\">View History</button>";';
    put '  html += "</div></div>";';
    put '  return html;';
    put '}';


%mend generate_js_regulatory_reports;


%macro generate_javascript_content_gen;
    put '<script>';
    put '// Dashboard HTML Generator';

    %erms_config_new;

    %generate_js_dashboard_builders;

    %generate_js_regulatory_reports;

    %generate_js_report_generation;



    put '</script>';
%mend generate_javascript_content_gen;



%macro generate_js_report_generation;
    put 'function resolveReportDate(reportType) {';
    put '  if (reportType === "saibor") {';
    put '    const hiddenDate = document.getElementById("saibor-date");';
    put '    const displayDate = document.getElementById("saibor-date-display");';
    put '    return (hiddenDate && hiddenDate.value) || (displayDate && displayDate.textContent) || new Date().toISOString().split("T")[0];';
    put '  }';
    put '  const dateInput = document.getElementById(reportType + "-date");';
    put '  if (!dateInput || !dateInput.value) {';
    put '    showNotification("Please select a valid date for the report", "error");';
    put '    throw new Error("Invalid report date for " + reportType);';
    put '  }';
    put '  return dateInput.value;';
    put '}';

    put 'function generateRegulatoryReport(reportType) {';
    put '  let selectedDate;';
    put '  try {';
    put '    selectedDate = resolveReportDate(reportType);';
    put '  } catch (error) {';
    put '    console.warn(error.message);';
    put '    return;';
    put '  }';
    put '  const storedProcedureUrl = regulatoryReportEndpoints[reportType];';
    put '  if (!storedProcedureUrl) {';
    put '    showNotification("No endpoint configured for " + reportType, "error");';
    put '    return;';
    put '  }';
    put '  showLoading();';
    put '  const formData = new URLSearchParams();';
    put '  formData.append("param_date", selectedDate);';
    put '  fetch(storedProcedureUrl, {';
    put '    method: "POST",';
    put '    headers: {';
    put '      "Content-Type": "application/x-www-form-urlencoded",';
    put '      "Accept": "text/html"';
    put '    },';
    put '    body: formData.toString()';
    put '  })';
    put '    .then(function (response) {';
    put '      if (!response.ok) {';
    put '        throw new Error("Network response was not ok: " + response.status);';
    put '      }';
    put '      return response.text();';
    put '    })';
    put '    .then(function () {';
    put '      showNotification("Report generated successfully for " + selectedDate + ". Downloading file...", "success");';
    put '      triggerReportDownload(reportType);';
    put '      hideLoading();';
    put '    })';
    put '    .catch(function (error) {';
    put '      hideLoading();';
    put '      console.error("Error executing stored procedure:", error);';
    put '      showNotification("Error generating report: " + error.message, "error");';
    put '    });';
    put '}';

    put 'function triggerReportDownload(reportType) {';
    put '  const metadata = reportDownloadMetadata[reportType];';
    put '  if (!metadata) {';
    put '    showNotification("No downloadable artifact configured for " + reportType, "info");';
    put '    return;';
    put '  }';
    put '  const link = document.createElement("a");';
    put '  link.href = metadata.url;';
    put '  link.download = metadata.fileName;';
    put '  link.target = "_blank";';
    put '  document.body.appendChild(link);';
    put '  link.click();';
    put '  document.body.removeChild(link);';
    put '  showNotification("File download initiated");';
    put '}';

    put 'function viewReportHistory(reportType) {';
    put '  console.log("Viewing report history for:", reportType);';
    put '  showNotification("Report history feature coming soon", "info");';
    put '}';
%mend generate_js_report_generation;
