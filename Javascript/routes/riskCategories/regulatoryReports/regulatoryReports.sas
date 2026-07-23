

%macro regulatoryReports;

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

%mend regulatoryReports;




