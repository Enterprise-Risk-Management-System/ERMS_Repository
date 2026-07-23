

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
   JAVASCRIPT ANIMATIONS
   ============================================================================ */
%macro generate_javascript_animations;
    put '<script>';
    put 'function animateStats() {';
    put '  var stats = [';
    put '    { element: "total-reports", target: 156, suffix: "" },';
    put '    { element: "active-users", target: 42, suffix: "" },';
    put '    { element: "risk-score", target: 7.2, suffix: "" },';
    put '    { element: "compliance-rate", target: 98.5, suffix: "%" }';
    put '  ];';
    put '  for (var i = 0; i < stats.length; i++) {';
    put '    animateNumber(stats[i].element, stats[i].target, stats[i].suffix);';
    put '  }';
    put '}';
    put 'function animateNumber(elementId, target, suffix) {';
    put '  var element = document.getElementById(elementId);';
    put '  var duration = 2000;';
    put '  var start = 0;';
    put '  var increment = target / (duration / 16);';
    put '  var current = start;';
    put '  var timer = setInterval(function() {';
    put '    current += increment;';
    put '    if (current >= target) {';
    put '      current = target;';
    put '      clearInterval(timer);';
    put '    }';
    put '    if (suffix === "%") {';
    put '      element.textContent = current.toFixed(1) + suffix;';
    put '    } else if (target >= 1000) {';
    put '      element.textContent = Math.floor(current).toLocaleString() + suffix;';
    put '    } else {';
    put '      element.textContent = current.toFixed(1) + suffix;';
    put '    }';
    put '  }, 16);';
    put '}';
    put 'function updateStats() {';
    put '  var randomIncrement = Math.random() * 5;';
    put '  var currentReports = parseInt(document.getElementById("total-reports").textContent.replace(",", ""));';
    put '  document.getElementById("total-reports").textContent = (currentReports + Math.floor(randomIncrement)).toLocaleString();';
    put '}';
    put '</script>';
%mend generate_javascript_animations;

/* ============================================================================
   JAVASCRIPT API INTEGRATION
   ============================================================================ */


%macro generate_javascript_api_integ;
 put '<script>';
    put 'var ermsDashboardApi = {';
    put '  // Get limit compliance data';
    put '  getLimitCompliance: function() {';
    put '    return fetch("https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Market Risk/API_Handler")';
    put '      .then(response => response.json())';
    put '      .then(data => {';
    put '        if (data.status === "success") {';
    put '          return data;';
    put '        } else {';
    put '          throw new Error(data.error_message || "Failed to fetch limit compliance data");';
    put '        }';
    put '      });';
    put '  },';
    put '  // Get loan portfolio data';
    put '  getLoanPortfolio: function() {';
    put '    return fetch("https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Market Risk/Loan Portfolio API")';
    put '      .then(response => response.json())';
    put '      .then(data => {';
    put '        if (data.status === "success") {';
    put '          return data;';
    put '        } else {';
    put '          throw new Error(data.error_message || "Failed to fetch loan portfolio data");';
    put '        }';
    put '      });';
    put '  },';
    put '  // Get complete dashboard data';
    put '  getDashboardData: function() {';
    put '    return Promise.all([';
    put '      this.getLimitCompliance(),';
    put '      this.getLoanPortfolio()';
    put '    ])';
    put '      .then(([limitData, loanData]) => {';
    put '        return {';
    put '          limit_compliance: limitData,';
    put '          loan_portfolio: loanData';
    put '        };';
    put '      });';
    put '  }';
    put '};';
    put '// Function to refresh dashboard data';
    put 'function refreshDashboardData() {';
    put '  showLoading();';
    put '  ermsDashboardApi.getDashboardData()';
    put '    .then(data => {';
    put '      updateDashboardTables(data);';
    put '      hideLoading();';
    put '      showNotification("Dashboard data refreshed successfully", "success");';
    put '    })';
    put '    .catch(error => {';
    put '      hideLoading();';
    put '      showNotification("Error refreshing dashboard data: " + error.message, "error");';
    put '    });';
    put '}';
    put '// Function to update dashboard tables';
    put 'function updateDashboardTables(data) {';
    put '  // Update limit compliance table';
    put '  if (data.limit_compliance) {';
    put '    updateLimitComplianceTable(data.limit_compliance);';
    put '  }';
    put '  // Update loan portfolio table';
    put '  if (data.loan_portfolio) {';
    put '    updateLoanPortfolioTable(data.loan_portfolio);';
    put '  }';
    put '}';
    put '// Function to update limit compliance table';
    put 'function updateLimitComplianceTable(data) {';
    put '  var tableBody = document.getElementById("limit-compliance-tbody");';
    put '  if (!tableBody) return;';
    put '  var html = "";';
    put '  // Check if data is an array or has a data property';
    put '  var records = Array.isArray(data) ? data : (data.data || []);';
    put '  console.log("Updating limit compliance table with records:", records);';
    put '  ';
    put '  if (records.length === 0) {';
    put '    html = "<tr><td colspan=\"7\" style=\"text-align: center; padding: 20px; color: #6b7280;\">No data available</td></tr>";';
    put '  } else {';
    put '    records.forEach(function(item) {';
    put '      html += "<tr>";';
    put '      html += "<td>" + (item.limit_type || "") + "</td>";';
    put '      html += "<td>" + (item.limit_sama || "") + "</td>";';
    put '      html += "<td>" + (item.limit_board || "") + "</td>";';
    put '      html += "<td>" + (item.mat_alco || "") + "</td>";';
    put '      html += "<td>" + (item.mat_cro || "") + "</td>";';
    put '      html += "<td>" + (item.current_value || "") + "</td>";';
    put '      html += "<td><span class=\"status-badge " + getStatusClass(item.compliance_status) + "\">" + (item.compliance_status || "") + "</span></td>";';
    put '      html += "</tr>";';
    put '    });';
    put '  }';
    put '  tableBody.innerHTML = html;';
    put '}';
    put '// Function to update loan portfolio table';
    put 'function updateLoanPortfolioTable(data) {';
    put '  var tableBody = document.getElementById("loan-portfolio-tbody");';
    put '  if (!tableBody) return;';
    put '  var html = "";';
    put '  // Check if data is an array or has a data property';
    put '  var records = Array.isArray(data) ? data : (data.data || []);';
    put '  console.log("Updating loan portfolio table with records:", records);';
    put '  ';
    put '  if (records.length === 0) {';
    put '    html = "<tr><td colspan=\"14\" style=\"text-align: center; padding: 20px; color: #6b7280;\">No data available</td></tr>";';
    put '  } else {';
    put '    records.forEach(function(item) {';
    put '      html += "<tr>";';
    put '      html += "<td>" + (item.loan_category || "") + "</td>";';
    put '      html += "<td>" + formatNumber(item.nb_of_customers) + "</td>";';
    put '      html += "<td>" + item.fair_value_sar + "</td>";';
    put '      html += "<td>" + formatPercentage(item.weighted_average_rate) + "</td>";';
    put '      html += "<td>" + formatNumber(item.weighted_average_remaining_tenor) + " months</td>";';
    put '      html += "<td>" + item["<1Y"] + "</td>";';
    put '      html += "<td>" + item["1-3 Years"] + "</td>";';
    put '      html += "<td>" + item["3-5 Years"] + "</td>";';
    put '      html += "<td>" + item["5-7 Years"] + "</td>";';
    put '      html += "<td>" + item["7-10 Years"] + "</td>";';
    put '      html += "<td>" + item["10-12 Years"] + "</td>";';
    put '      html += "<td>" + item["12-15 Years"] + "</td>";';
    put '      html += "<td>" + item["15-20 Years"] + "</td>";';
    put '      html += "<td>" + item["20+ Years"] + "</td>";';
    put '      html += "</tr>";';
    put '    });';
    put '  }';
    put '  tableBody.innerHTML = html;';
    put '}';
    put '// Helper function to format numbers with commas';
    put 'function formatNumber(value) {';
    put '  if (!value) return "0";';
    put '  var num = parseFloat(value.toString().replace(/[^\d.-]/g, ""));';
    put '  if (isNaN(num)) return "0";';
    put '  return num.toLocaleString();';
    put '}';
    put '// Helper function to format currency';
    put 'function formatCurrency(value) {';
    put '  if (!value) return "SAR 0";';
    put '  var num = parseFloat(value.toString().replace(/[^\d.-]/g, ""));';
    put '  if (isNaN(num)) return "SAR 0";';
    put '  if (Math.abs(num) >= 1e9) {';
    put '    return "SAR " + (num / 1e9).toFixed(2) + "B";';
    put '  } else if (Math.abs(num) >= 1e6) {';
    put '    return "SAR " + (num / 1e6).toFixed(2) + "M";';
    put '  } else if (Math.abs(num) >= 1e3) {';
    put '    return "SAR " + (num / 1e3).toFixed(2) + "K";';
    put '  } else {';
    put '    return "SAR " + num.toLocaleString();';
    put '  }';
    put '}';
    put '// Helper function to format percentage';
    put 'function formatPercentage(value) {';
    put '  if (!value) return "0%";';
    put '  var num = parseFloat(value.toString().replace(/[^\d.-]/g, ""));';
    put '  if (isNaN(num)) return "0%";';
    put '  return (num * 100).toFixed(2) + "%";';
    put '}';
    put '// Helper function to get status badge class';
    put 'function getStatusClass(status) {';
    put '  if (!status) return "warning";';
    put '  switch(status.toLowerCase()) {';
    put '    case "ok": return "compliant";';
    put '    case "warning": return "warning";';
    put '    case "critical": return "danger";';
    put '    default: return "warning";';
    put '  }';
    put '}';
    put '// Auto-refresh dashboard every 5 minutes';
    put 'setInterval(function() {';
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
    put '  "#regulatory-reports": getRegulatoryReportsHTML';
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


/* ============================================================================
   CONTENT GENERATORS
   ============================================================================ */



%macro generate_javascript_content_gen;
    put '<script>';
    put '// Dashboard HTML Generator';

    put 'function getDashboardTableHTML() {';
    put '  var html = "";';
    put '  html += "<h2 style=''margin-bottom: 20px; color: #1f2937; font-size: 1.5rem;''>Risk Dashboard Overview</h2>";';
    put '  html += "<div class=''dashboard-table-container'' style=''margin-bottom: 30px;''>";';
    put '  html += "<h3 style=''margin-bottom: 15px; color: #374151; font-size: 1.2rem;''>     Limit Compliance Overview  -  30JUN2025</h3>";';
    put '  html += "<table class=''dashboard-table'' id=''limit-compliance-table''>";';
    put '  html += "<thead><tr>";';
    put '  html += "<th>Limit compliance</th>";';
    put '  html += "<th>Limit - SAMA</th>";';
    put '  html += "<th>Limit - Board</th>";';
    put '  html += "<th>MAT ALCO</th>";';
    put '  html += "<th>MAT CRO</th>";';
    put '  html += "<th>Value</th>";';
    put '  html += "<th>Compliance status</th>";';
    put '  html += "</tr></thead><tbody id=''limit-compliance-tbody''>";';
    put '  html += "<tr><td colspan=''7'' style=''text-align: center; padding: 20px; color: #6b7280;''>Loading data...</td></tr>";';
    put '  html += "</tbody></table></div>";';

    put '  html += "<div class=''dashboard-table-container''>";';
    put '  html += "<h3 style=''margin-bottom: 15px; color: #374151; font-size: 1.2rem;''>Loan Portfolio Analysis - 19AUG2025 - SAR in (MM)</h3>";';
    put '  html += "<table class=''dashboard-table''>";';
    put '  html += "<thead><tr>";';
    put '  html += "<th>Loan Category</th>";';
    put '  html += "<th>Nb of customers</th>";';
    put '  html += "<th>Fair Value SAR</th>";';
    put '  html += "<th>Weighted average rate</th>";';
    put '  html += "<th>Weighted average remaining tenor</th>";';
    put '  html += "<th><= 1 Year</th>";';
    put '  html += "<th>1 - 3 years</th>";';
    put '  html += "<th>3 - 5 years</th>";';
    put '  html += "<th>5 - 7 years</th>";';
    put '  html += "<th>7 - 10 years</th>";';
    put '  html += "<th>10 - 12 years</th>";';
    put '  html += "<th>12 - 15 years</th>";';
    put '  html += "<th>15 - 20 years</th>";';
    put '  html += "<th>20+ years</th>";';
    put '  html += "</tr></thead><tbody id=''loan-portfolio-tbody''>";';
    put '  html += "<tr><td colspan=''7'' style=''text-align: center; padding: 20px; color: #6b7280;''>Loading data...</td></tr>";';
    put '  html += "</tbody></table></div>";';
    put '  return html;';
    put '}';

    put '// Risk Categories HTML Generator';
    put 'function getRiskCategoriesHTML() {';
    put '  var html = "";';
    put '  html += "<h2 style=''margin-bottom: 20px; color: #1f2937; font-size: 1.5rem;''>Risk Categories</h2>";';
    put '  html += "<div class=''risk-modules''>";';
    put '  html += "<div class=''risk-module'' data-module=''regulatory'' onclick=''showRoute(\"#regulatory-reports\")''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon regulatory''><i class=''fas fa-gavel''></i></div>";';
    put '  html += "<h3 class=''module-title''>Regulatory Risk</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Comprehensive regulatory compliance reports and monitoring dashboards for regulatory authorities.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>24</div><div class=''stat-label''>Reports</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>98%</div><div class=''stat-label''>Compliance</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''credit''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon credit''><i class=''fas fa-credit-card''></i></div>";';
    put '  html += "<h3 class=''module-title''>Credit Risk</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Advanced credit risk assessment portfolio analysis and default probability modeling.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>1.2M</div><div class=''stat-label''>Exposure</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>2.3%</div><div class=''stat-label''>PD Rate</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''operational''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon operational''><i class=''fas fa-cogs''></i></div>";';
    put '  html += "<h3 class=''module-title''>Operational Risk</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Operational risk identification assessment and mitigation strategies across all business units.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>156</div><div class=''stat-label''>Incidents</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>$2.1M</div><div class=''stat-label''>Loss</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''market''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon market''><i class=''fas fa-chart-line''></i></div>";';
    put '  html += "<h3 class=''module-title''>Market Risk</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Real-time market risk monitoring VaR calculations and stress testing scenarios.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>$45M</div><div class=''stat-label''>VaR (95%)</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>12.5%</div><div class=''stat-label''>Volatility</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''liquidity''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon liquidity''><i class=''fas fa-water''></i></div>";';
    put '  html += "<h3 class=''module-title''>Liquidity Risk</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Liquidity risk assessment cash flow projections and funding stability analysis.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>145%</div><div class=''stat-label''>LCR Ratio</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>$850M</div><div class=''stat-label''>HQLA</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''icaap''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon icaap''><i class=''fas fa-balance-scale''></i></div>";';
    put '  html += "<h3 class=''module-title''>ICAAP</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Internal Capital Adequacy Assessment Process and capital planning strategies.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>18.5%</div><div class=''stat-label''>CAR</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>$2.8B</div><div class=''stat-label''>Capital</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "<div class=''risk-module'' data-module=''ilaap''>";';
    put '  html += "<div class=''module-header''>";';
    put '  html += "<div class=''module-icon ilaap''><i class=''fas fa-tint''></i></div>";';
    put '  html += "<h3 class=''module-title''>ILAAP</h3>";';
    put '  html += "</div>";';
    put '  html += "<p class=''module-description''>Internal Liquidity Adequacy Assessment Process and liquidity risk management.</p>";';
    put '  html += "<div class=''module-stats''>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>125%</div><div class=''stat-label''>NSFR</div></div>";';
    put '  html += "<div class=''stat-item''><div class=''stat-value''>$1.2B</div><div class=''stat-label''>Stable Funding</div></div>";';
    put '  html += "</div></div>";';
    put '  html += "</div>";';
    put '  return html;';
    put '}';

    put '// Analytics HTML Generator';
    put 'function getAnalyticsHTML() {';
    put '  var html = "";';
    put '  html += "<h2 style=''margin-bottom: 20px; color: #1f2937; font-size: 1.5rem;''>Analytics Dashboard</h2>";';
    put '  html += "<div style=''text-align: center; padding: 50px;''>";';
    put '  html += "<h3>Analytics Module</h3>";';
    put '  html += "<p>Advanced analytics and reporting features coming soon.</p>";';
    put '  html += "</div>";';
    put '  return html;';
    put '}';
    put '// Regulatory Reports HTML Generator';
    put 'function getRegulatoryReportsHTML() {';
    put '  var html = "";';
    put '  html += "<div style=''max-width: 1200px; margin: 0 auto; padding: 20px;''>";';
    put '  html += "<div style=''display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px; margin-bottom: 30px;''>";';
    put '  // SAMA Q17 Report Card';
    put '  html += "<div style=''background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer;'' onmouseover=''this.style.transform=\"translateY(-3px)\"; this.style.boxShadow=\"0 8px 25px rgba(0, 0, 0, 0.15)\"; this.style.borderColor=\"#3b82f6\";'' onmouseout=''this.style.transform=\"translateY(0)\"; this.style.boxShadow=\"0 4px 15px rgba(0, 0, 0, 0.08)\"; this.style.borderColor=\"transparent\";'' data-report=''sama-q17''>";';
    put '  html += "<div style=''display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px;''>";';
    put '  html += "<div style=''width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; flex-shrink: 0;''><i class=''fas fa-chart-bar''></i></div>";';
    put '  html += "<div style=''flex: 1;''>";';
    put '  html += "<h3 style=''font-size: 1.3rem; font-weight: 600; color: #1f2937; margin-bottom: 8px;''>SAMA Q17 Report</h3>";';
    put '  html += "<p style=''color: #6b7280; font-size: 0.9rem; line-height: 1.5;''>Quarterly regulatory report for SAMA compliance monitoring and risk assessment.</p>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
    put '  html += "<div style=''margin-bottom: 20px; padding: 15px; background: #f9fafb; border-radius: 8px;''>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Frequency:</span><span style=''color: #6b7280;''>Quarterly</span></div>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>As of Date:</span><span style=''color: #6b7280;''>2025-06-30</span></div>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Latest Date Available:</span><span style=''color: #6b7280;''>2025-09-30</span></div>";';
    put '  html += "</div>";';
    put '  html += "<div style=''display: flex; gap: 10px;''>";';
    put '  html += "<button onclick=''generateRegulatoryReport(\"sama-q17\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;'' onmouseover=''this.style.background=\"#2563eb\";'' onmouseout=''this.style.background=\"#3b82f6\";''>Generate Report</button>";';
    put '  html += "<button onclick=''viewReportHistory(\"sama-q17\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;'' onmouseover=''this.style.background=\"#4b5563\";'' onmouseout=''this.style.background=\"#6b7280\";''>View History</button>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
    put '  // SAMA P3 Report Card';
    put '  html += "<div style=''background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer;'' onmouseover=''this.style.transform=\"translateY(-3px)\"; this.style.boxShadow=\"0 8px 25px rgba(0, 0, 0, 0.15)\"; this.style.borderColor=\"#3b82f6\";'' onmouseout=''this.style.transform=\"translateY(0)\"; this.style.boxShadow=\"0 4px 15px rgba(0, 0, 0, 0.08)\"; this.style.borderColor=\"transparent\";'' data-report=''sama-p3''>";';
    put '  html += "<div style=''display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px;''>";';
    put '  html += "<div style=''width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; flex-shrink: 0;''><i class=''fas fa-file-alt''></i></div>";';
    put '  html += "<div style=''flex: 1;''>";';
    put '  html += "<h3 style=''font-size: 1.3rem; font-weight: 600; color: #1f2937; margin-bottom: 8px;''>SAMA P3 Report</h3>";';
    put '  html += "<p style=''color: #6b7280; font-size: 0.9rem; line-height: 1.5;''>Periodic regulatory report for SAMA portfolio analysis and risk exposure assessment.</p>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
    put '  html += "<div style=''margin-bottom: 20px; padding: 15px; background: #f9fafb; border-radius: 8px;''>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Frequency:</span><span style=''color: #6b7280;''>Quarterly/ Semi Annual / Annually</span></div>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>As of Date:</span><span style=''color: #6b7280;''>2025-06-30</span></div>";';
    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Latest Date Available:</span><span style=''color: #6b7280;''>2025-09-30</span></div>";';
/*    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0;''><span style=''font-weight: 500; color: #374151;''>Status:</span><span style=''padding: 4px 8px; border-radius: 6px; font-size: 0.8rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; background: #fef3c7; color: #92400e;''>Pending</span></div>";';*/
    put '  html += "</div>";';
    put '  html += "<div style=''display: flex; gap: 10px;''>";';
    put '  html += "<button onclick=''generateRegulatoryReport(\"sama-p3\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;'' onmouseover=''this.style.background=\"#2563eb\";'' onmouseout=''this.style.background=\"#3b82f6\";''>Generate Report</button>";';
    put '  html += "<button onclick=''viewReportHistory(\"sama-p3\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;'' onmouseover=''this.style.background=\"#4b5563\";'' onmouseout=''this.style.background=\"#6b7280\";''>View History</button>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
    put '  html += "</div>";';
/*    put '  return html;';*/
/*    put '  // SAMA Q27 Report Card';*/
/*    put '  html += "<div style=''background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer;'' onmouseover=''this.style.transform=\"translateY(-3px)\"; this.style.boxShadow=\"0 8px 25px rgba(0, 0, 0, 0.15)\"; this.style.borderColor=\"#3b82f6\";'' onmouseout=''this.style.transform=\"translateY(0)\"; this.style.boxShadow=\"0 4px 15px rgba(0, 0, 0, 0.08)\"; this.style.borderColor=\"transparent\";'' data-report=''sama-p3''>";';*/
/*    put '  html += "<div style=''display: flex; align-items: flex-start; gap: 15px; margin-bottom: 20px;''>";';*/
/*    put '  html += "<div style=''width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #1d4ed8); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; flex-shrink: 0;''><i class=''fas fa-file-alt''></i></div>";';*/
/*    put '  html += "<div style=''flex: 1;''>";';*/
/*    put '  html += "<h3 style=''font-size: 1.3rem; font-weight: 600; color: #1f2937; margin-bottom: 8px;''>SAMA Q27 Report</h3>";';*/
/*    put '  html += "<p style=''color: #6b7280; font-size: 0.9rem; line-height: 1.5;''>Periodic regulatory report for SAMA portfolio analysis and risk exposure assessment.</p>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "<div style=''margin-bottom: 20px; padding: 15px; background: #f9fafb; border-radius: 8px;''>";';*/
/*    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Frequency:</span><span style=''color: #6b7280;''>Monthly</span></div>";';*/
/*    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Due Date:</span><span style=''color: #6b7280;''>10th of following month</span></div>";';*/
/*    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #e5e7eb;''><span style=''font-weight: 500; color: #374151;''>Last Generated:</span><span style=''color: #6b7280;''>2024-12-10</span></div>";';*/
/*    put '  html += "<div style=''display: flex; justify-content: space-between; align-items: center; padding: 8px 0;''><span style=''font-weight: 500; color: #374151;''>Status:</span><span style=''padding: 4px 8px; border-radius: 6px; font-size: 0.8rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; background: #fef3c7; color: #92400e;''>Pending</span></div>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "<div style=''display: flex; gap: 10px;''>";';*/
/*    put '  html += "<button onclick=''generateRegulatoryReport(\"sama-p3\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;'' onmouseover=''this.style.background=\"#2563eb\";'' onmouseout=''this.style.background=\"#3b82f6\";''>Generate Report</button>";';*/
/*    put '  html += "<button onclick=''viewReportHistory(\"sama-p3\")'' style=''padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;'' onmouseover=''this.style.background=\"#4b5563\";'' onmouseout=''this.style.background=\"#6b7280\";''>View History</button>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "</div>";';*/
/*    put '  html += "</div>";';*/
    put '  return html;';
    put '}';
    put '</script>';
%mend generate_javascript_content_gen;


