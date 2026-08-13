/* ============================================================================
   RAF UTILS MODULE (ERMS-embedded)
   Pure, side-effect-free helpers only - NOT a replacement for ERMS's own
   showLoading()/hideLoading()/showNotification()/closeModal(), which the
   Risk Appetite Framework section calls directly (see appetiteReportGeneration.sas,
   reportHistory.sas) rather than duplicating. Keeping this object to pure
   formatting helpers avoids ever redefining any of ERMS's existing global
   function names.
   ============================================================================ */
%macro generate_raf_utils;
    put '// RAF Utils Module (pure helpers only - see file header)';
    put 'const RAFUtils = {';
    put '  // Formats a 0-1 decimal (the sheet''s native threshold/value format) as a percent string';
    put '  formatPercent(value, decimals = 1) {';
    put '    if (typeof value !== "number" || isNaN(value)) return "-";';
    put '    return (value * 100).toFixed(decimals) + "%";';
    put '  },';
    put '  // Formats a date string (yyyy-mm-dd) as dd-Mon-yyyy';
    put '  formatDate(dateStr) {';
    put '    if (!dateStr) return "-";';
    put '    const d = new Date(dateStr + "T00:00:00");';
    put '    if (isNaN(d.getTime())) return dateStr;';
    put '    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];';
    put '    return String(d.getDate()).padStart(2, "0") + "-" + months[d.getMonth()] + "-" + d.getFullYear();';
    put '  },';
    put '  // Returns today''s date as a yyyy-mm-dd string';
    put '  getTodayDate() {';
    put '    return new Date().toISOString().split("T")[0];';
    put '  }';
    put '};';
%mend generate_raf_utils;
