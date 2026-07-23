


%macro Saibor;

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
    put '  html += "<div style=\"display: flex; gap: 10px;\"><button onclick=\"generateSaiborReport(''saibor'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #3b82f6; color: white;\">Generate Report</button>";';
    put '  html += "<button onclick=\"viewReportHistory(''saibor'')\" style=\"padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; font-size: 0.9rem; background: #6b7280; color: white;\">View History</button></div>";';
    put '  html += "</div></div>";';
    put '  return html;';
    put '}';

%mend;
    
