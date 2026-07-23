/* ============================================================================
   JAVASCRIPT UTILITIES
   ============================================================================ */
%macro generate_javascript_utils;
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
%mend generate_javascript_utils;
