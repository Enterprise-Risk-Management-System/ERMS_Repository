


%macro generate_javascript_modal;
   
    put 'function showModalMessage(payload) {';
    put '  var modal = document.getElementById("reportModal");';
    put ' console.log(modal);';
    put '  var modalTitle = document.getElementById("modalTitle");';
    put '  var modalBody = document.getElementById("modalBody");';
    put '  if (!modal || !modalTitle || !modalBody) {';
    put '    console.error("Modal elements not found in DOM");';
    put '    return;';
    put '  };';

    put '  var title = payload && payload.title ? payload.title : "Notification";';
    put '  var message = payload && payload.message ? payload.message : "No message provided.";';
    put '  var type = payload && payload.type ? payload.type : "info";';

    put '  modalTitle.textContent = title;';
    put '  var theme = getModalTheme(type);';
    put '  var html = "<div style=\"background:" + theme.bg + "; color:" + theme.text + "; padding:15px; border-radius:8px; text-align:left;\">";';
    put '  html += "<div style=\"font-size:1rem; font-weight:600; margin-bottom:8px;\">" + escapeHtml(message) + "</div>";';
    put '  html += "</div>";';
    put '  modalBody.innerHTML = html;';
    put '  modal.classList.add("show");';
    put '}';

    put 'function getModalTheme(type) {';
    put '  var themes = {';
    put '    error: { bg: "#fee2e2", text: "#b91c1c" },';
    put '    warning: { bg: "#fef3c7", text: "#92400e" },';
    put '    success: { bg: "#d1fae5", text: "#065f46" },';
    put '    info: { bg: "#e0f2fe", text: "#0369a1" }';
    put '  };';
    put '  return themes[type] || { bg: "#f9fafb", text: "#1f2937" };';
    put '}';

    put 'function escapeHtml(str) {';
    put '  if (str === null || str === undefined) return "";';
    put '  return String(str)';
    put '    .replace(/&/g, "&amp;")';
    put '    .replace(/</g, "&lt;")';
    put '    .replace(/>/g, "&gt;")';
    put '    .replace(/"/g, "&quot;")';
    put '    .replace(/''/g, "&#39;");';
    put '}';

    put 'function closeModal() {';
    put '  var modal = document.getElementById("reportModal");';
    put '  if (modal) modal.classList.remove("show");';
    put '}';

    put 'var modalEl = document.getElementById("reportModal");';
    put 'if (modalEl) {';
    put '  modalEl.addEventListener("click", function(e) {';
    put '    if (e.target === this) {';
    put '      closeModal();';
    put '    }';
    put '  });';
    put '}';

%mend generate_javascript_modal;
