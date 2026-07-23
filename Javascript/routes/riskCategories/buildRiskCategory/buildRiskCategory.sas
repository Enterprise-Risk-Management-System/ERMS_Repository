

%macro buildRiskCategories;
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
%mend buildRiskCategories;
