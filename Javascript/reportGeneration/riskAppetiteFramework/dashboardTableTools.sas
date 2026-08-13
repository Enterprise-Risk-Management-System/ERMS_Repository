/* ============================================================================
   RAF DASHBOARD TABLE TOOLS (ERMS-embedded)
   Generic tooling shared by every results table in the Risk Appetite
   Framework section: a free-text filter bar (field OPERATOR value, AND/OR,
   contains/like) and a hand-built SpreadsheetML (.xls) Export to Excel,
   entirely client-side, no external library - matching the pattern already
   used elsewhere in this family of apps. Calls ERMS's own showNotification()
   global (never redefines it).
   ============================================================================ */
%macro generate_dashboard_table_tools;

    put '// RAF Dashboard Table Tools (filter + export) Module';

    /* ---- Filter bar markup -------------------------------------------- */
    put 'function filterBarHtml(tableId) {';
    put '  return "<div class=\"table-toolbar\">"';
    put '    + "<input type=\"text\" class=\"table-filter-input\" id=\"" + tableId + "-filter-input\" "';
    put '    + "placeholder=\"e.g. Green > 15 AND Criticality = Level 1  |  Date contains 2026\" "';
    put '    + "onkeydown=\"if(event.key===&apos;Enter&apos;){applyTableFilter(&apos;" + tableId + "&apos;);}\">"';
    put '    + "<button class=\"btn btn-sm\" onclick=\"applyTableFilter(&apos;" + tableId + "&apos;)\">Apply</button>"';
    put '    + "<button class=\"btn ghost btn-sm\" onclick=\"clearTableFilter(&apos;" + tableId + "&apos;)\">Clear</button>"';
    put '    + "<span class=\"table-filter-count\" id=\"" + tableId + "-filter-count\"></span>"';
    put '    + "</div>";';
    put '}';

    put 'function normalizeFieldToken(s) {';
    put '  return String(s).toLowerCase().replace(/[^a-z0-9]/g, "");';
    put '}';

    put '// Strips commas and % so "15%" and "15" compare on the same numeric scale.';
    put 'function parseNumericToken(raw) {';
    put '  if (raw === null || raw === undefined) return null;';
    put '  var s = String(raw).trim().replace(/,/g, "").replace(/%$/, "");';
    put '  var m = s.match(/^([+-]?\d+(\.\d+)?)$/);';
    put '  return m ? parseFloat(m[1]) : null;';
    put '}';

    put 'function findColumnIndex(table, fieldText) {';
    put '  var headers = table.querySelectorAll("thead th");';
    put '  var target = normalizeFieldToken(fieldText);';
    put '  var best = -1;';
    put '  headers.forEach(function(th, idx) {';
    put '    var norm = normalizeFieldToken(th.textContent);';
    put '    if (norm === target && best === -1) best = idx;';
    put '  });';
    put '  if (best !== -1) return best;';
    put '  headers.forEach(function(th, idx) {';
    put '    var norm = normalizeFieldToken(th.textContent);';
    put '    if (best === -1 && (norm.indexOf(target) !== -1 || target.indexOf(norm) !== -1)) best = idx;';
    put '  });';
    put '  return best;';
    put '}';

    put 'var RAF_FILTER_OPERATOR_RE = /^(.*?)\s*(>=|<=|!=|<>|=|>|<|contains|like)\s*(.+)$/i;';

    put 'function evaluateClause(table, row, clause) {';
    put '  clause = clause.trim();';
    put '  if (!clause) return true;';
    put '  var m = clause.match(RAF_FILTER_OPERATOR_RE);';
    put '  if (!m) return row.textContent.toLowerCase().indexOf(clause.toLowerCase()) !== -1;';
    put '  var fieldText = m[1].trim();';
    put '  var op = m[2].toLowerCase();';
    put '  var valueText = m[3].trim().replace(/^["\x27]|["\x27]$/g, "");';
    put '  if (!fieldText) return row.textContent.toLowerCase().indexOf(clause.toLowerCase()) !== -1;';
    put '  var colIdx = findColumnIndex(table, fieldText);';
    put '  if (colIdx === -1) return true;';
    put '  var cell = row.children[colIdx];';
    put '  var cellText = cell ? cell.textContent.trim() : "";';
    put '  if (op === "contains" || op === "like") return cellText.toLowerCase().indexOf(valueText.toLowerCase()) !== -1;';
    put '  var cellNum = parseNumericToken(cellText);';
    put '  var valueNum = parseNumericToken(valueText);';
    put '  if (cellNum !== null && valueNum !== null) {';
    put '    switch (op) {';
    put '      case ">": return cellNum > valueNum;';
    put '      case "<": return cellNum < valueNum;';
    put '      case ">=": return cellNum >= valueNum;';
    put '      case "<=": return cellNum <= valueNum;';
    put '      case "=": return cellNum === valueNum;';
    put '      case "!=": case "<>": return cellNum !== valueNum;';
    put '    }';
    put '  }';
    put '  var cellStr = cellText.toLowerCase(), valueStr = valueText.toLowerCase();';
    put '  switch (op) {';
    put '    case "=": return cellStr === valueStr;';
    put '    case "!=": case "<>": return cellStr !== valueStr;';
    put '    case ">": return cellStr > valueStr;';
    put '    case "<": return cellStr < valueStr;';
    put '    case ">=": return cellStr >= valueStr;';
    put '    case "<=": return cellStr <= valueStr;';
    put '    default: return cellStr.indexOf(valueStr) !== -1;';
    put '  }';
    put '}';

    put 'function applyTableFilter(tableId) {';
    put '  var table = document.getElementById(tableId);';
    put '  var input = document.getElementById(tableId + "-filter-input");';
    put '  var countEl = document.getElementById(tableId + "-filter-count");';
    put '  if (!table || !input) return;';
    put '  var query = input.value.trim();';
    put '  var rows = table.querySelectorAll("tbody tr");';
    put '  if (!query) {';
    put '    rows.forEach(function(r) { r.style.display = ""; });';
    put '    if (countEl) countEl.textContent = "";';
    put '    return;';
    put '  }';
    put '  var orGroups = query.split(/\s+OR\s+/i).map(function(group) { return group.split(/\s+AND\s+/i); });';
    put '  var shown = 0;';
    put '  rows.forEach(function(row) {';
    put '    var pass = orGroups.some(function(clauses) {';
    put '      return clauses.every(function(clause) { return evaluateClause(table, row, clause); });';
    put '    });';
    put '    row.style.display = pass ? "" : "none";';
    put '    if (pass) shown++;';
    put '  });';
    put '  if (countEl) countEl.textContent = "Showing " + shown + " of " + rows.length + " rows";';
    put '}';

    put 'function clearTableFilter(tableId) {';
    put '  var input = document.getElementById(tableId + "-filter-input");';
    put '  if (input) input.value = "";';
    put '  applyTableFilter(tableId);';
    put '}';

    /* ---- Export to Excel: generic table scraper ------------------------ */
    put 'function tableToWorksheetXml(tableId, sheetName) {';
    put '  var table = document.getElementById(tableId);';
    put '  if (!table) return "";';
    put '  var headerCells = Array.prototype.slice.call(table.querySelectorAll("thead th"));';
    put '  var headers = headerCells.map(function(th) { return th.textContent.trim(); });';
    put '  var rows = Array.prototype.filter.call(table.querySelectorAll("tbody tr"), function(r) {';
    put '    return r.style.display !== "none";';
    put '  });';
    put '  var xml = "<Worksheet ss:Name=\"" + escapeHtml(sheetName) + "\"><Table>";';
    put '  xml += "<Row>" + headers.map(function(h) {';
    put '    return "<Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">" + escapeHtml(h) + "</Data></Cell>";';
    put '  }).join("") + "</Row>";';
    put '  rows.forEach(function(row) {';
    put '    xml += "<Row>" + Array.prototype.map.call(row.children, function(td) {';
    put '      return "<Cell><Data ss:Type=\"String\">" + escapeHtml(td.textContent.trim()) + "</Data></Cell>";';
    put '    }).join("") + "</Row>";';
    put '  });';
    put '  xml += "</Table></Worksheet>";';
    put '  return xml;';
    put '}';

    put '// Blob + object URL only, nothing here ever reaches outside the bank''s network.';
    put 'function downloadWorkbook(worksheetsXml, filenamePrefix) {';
    put '  var doc = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"';
    put '    + "<?mso-application progid=\"Excel.Sheet\"?>"';
    put '    + "<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" "';
    put '    + "xmlns:o=\"urn:schemas-microsoft-com:office:office\" "';
    put '    + "xmlns:x=\"urn:schemas-microsoft-com:office:excel\" "';
    put '    + "xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\">"';
    put '    + "<Styles><Style ss:ID=\"sHeader\"><Font ss:Bold=\"1\" ss:Color=\"#FFFFFF\"/>"';
    put '    + "<Interior ss:Color=\"#1E3A8A\" ss:Pattern=\"Solid\"/></Style></Styles>"';
    put '    + worksheetsXml';
    put '    + "</Workbook>";';
    put '  var blob = new Blob([doc], { type: "application/vnd.ms-excel" });';
    put '  var url = URL.createObjectURL(blob);';
    put '  var ts = new Date().toISOString().slice(0, 10);';
    put '  var link = document.createElement("a");';
    put '  link.href = url;';
    put '  link.download = filenamePrefix + "_" + ts + ".xls";';
    put '  document.body.appendChild(link);';
    put '  link.click();';
    put '  document.body.removeChild(link);';
    put '  URL.revokeObjectURL(url);';
    put '}';

    put '// Generic export for any set of on-screen table ids';
    put 'function exportTableToExcel(tableId, sheetName, filenamePrefix) {';
    put '  var xml = tableToWorksheetXml(tableId, sheetName);';
    put '  if (!xml) { showNotification("Nothing to export yet.", "error"); return; }';
    put '  downloadWorkbook(xml, filenamePrefix);';
    put '  showNotification(sheetName + " exported.", "success");';
    put '}';

    /* ---- Export to Excel: category detail metric cards (data-driven,
       since the cards are not rendered as a <table> - see appetiteResultsView.sas). ---- */
    put 'function exportMetricCardsToExcel(categoryKey) {';
    put '  var metrics = appetiteMetricsConfig[categoryKey];';
    put '  if (!metrics || !metrics.length) { showNotification("Nothing to export yet.", "error"); return; }';
    put '  var headers = ["Indicator", "Definition", "Current Value", "Status", "Green", "Amber", "Red", "Regulatory", "Criticality", "Owner", "Committee", "Frequency", "Comment"];';
    put '  var xml = "<Worksheet ss:Name=\"" + escapeHtml(RAFUI.getCategoryTitle(categoryKey)) + "\"><Table>";';
    put '  xml += "<Row>" + headers.map(function(h) {';
    put '    return "<Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">" + escapeHtml(h) + "</Data></Cell>";';
    put '  }).join("") + "</Row>";';
    put '  metrics.forEach(function(m) {';
    put '    var status = RAF_STATUS_LABEL[RAFStatus.evaluateStatus(m)];';
    put '    var cells = [';
    put '      m.indicator, m.definition, RAFUtils.formatPercent(m.currentValue), status,';
    put '      RAFUtils.formatPercent(m.thresholds.green), RAFUtils.formatPercent(m.thresholds.amber),';
    put '      RAFUtils.formatPercent(m.thresholds.red), RAFUtils.formatPercent(m.thresholds.regulatory),';
    put '      m.criticality, m.owner, m.committee, m.frequency, m.comment';
    put '    ];';
    put '    xml += "<Row>" + cells.map(function(c) {';
    put '      return "<Cell><Data ss:Type=\"String\">" + escapeHtml(String(c)) + "</Data></Cell>";';
    put '    }).join("") + "</Row>";';
    put '  });';
    put '  xml += "</Table></Worksheet>";';
    put '  downloadWorkbook(xml, "RAF_" + categoryKey);';
    put '  showNotification(RAFUI.getCategoryTitle(categoryKey) + " exported.", "success");';
    put '}';

%mend generate_dashboard_table_tools;
