

%macro buildDashboardTable;

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

%mend buildDashboardTable;


%macro buildAnalyticsDash;

  put '  // Analytics HTML Generator - embeds Tableau Risk Management dashboard (no iframe)';
  put '  function getAnalyticsHTML() {';
  put '    var html = "";';
  put '    html += "<h2 style=\"margin-bottom:20px;color:#1f2937;font-size:1.5rem;\">Risk Management Analytics</h2>";';
  put '    html += "<p style=\"margin-bottom:20px;color:#6b7280;\">Embedded Tableau dashboard providing a comprehensive overview of enterprise risk metrics and compliance status.</p>";';
  put '    html += "<div style=\"background:white;border-radius:12px;box-shadow:0 4px 15px rgba(0,0,0,0.08);padding:10px;\">";';
  /* DO NOT add a second <script> tag here — the API script is already loaded in <head> */
  put '    html += "<div class=\"tableauPlaceholder\" style=\"width:1850px;height:927px;\">";';
  put '    html += "  <object class=\"tableauViz\" width=\"1850\" height=\"927\" style=\"display:none;\">";';
  put '    html += "    <param name=\"host_url\" value=\"https%3A%2F%2Ftableau.anb.net%2F\" />";';
  put '    html += "    <param name=\"embed_code_version\" value=\"3\" />";';
  /* Use real slashes in site_root and name, not HTML entity codes */
  put '    html += "    <param name=\"site_root\" value=\"/t/ANB\" />";';
  put '    html += "    <param name=\"name\" value=\"RevenueDashboard_17055050791960/RevenueDashboard\" />";';
  put '    html += "    <param name=\"tabs\" value=\"no\" />";';
  put '    html += "    <param name=\"toolbar\" value=\"yes\" />";';
  put '    html += "    <param name=\"showAppBanner\" value=\"false\" />";';
  put '    html += "  </object>";';
  put '    html += "</div>";';
  put '    html += "</div>";';
  put '    return html;';
  put '  }';



%mend buildAnalyticsDash;




