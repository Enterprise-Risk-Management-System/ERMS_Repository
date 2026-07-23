
/* ============================================================================
   JAVASCRIPT API INTEGRATION
   ============================================================================ */



%macro cro_Dashboard_Api_Integ;

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
 
%mend cro_Dashboard_Api_Integ;
