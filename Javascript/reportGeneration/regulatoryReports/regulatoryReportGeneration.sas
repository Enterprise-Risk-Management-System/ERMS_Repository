

%macro regulatoryReportGeneration;
    put 'function resolveReportDate(reportType) {';
    put '  const dateInput = document.getElementById(reportType + "-date");';
    put '  if (!dateInput || !dateInput.value) {';
    put '    showNotification("Please select a valid date for the report", "error");';
    put '    throw new Error("Invalid report date for " + reportType);';
    put ' }';
    put '  	 return dateInput.value;';
    put '}';

    put 'function generateRegulatoryReport(reportType) {';
    put '  let selectedDate;';
    put '  try {';
    put '    selectedDate = resolveReportDate(reportType);';
    put '  } catch (error) {';
    put '    console.warn(error.message);';
    put '   return;';
    put '  }';
    put '  const storedProcedureUrl = regulatoryReportEndpoints[reportType];';
    put '  if (!storedProcedureUrl) {';
    put '    showNotification("No endpoint configured for " + reportType, "error");';
    put '    return;';
    put '  }';
    put '  showLoading();';
    put '  const formData = new URLSearchParams();';
    put '  formData.append("param_date", selectedDate);';
    put '  fetch(storedProcedureUrl, {';
    put '    method: "POST",';
    put '    headers: {';
    put '      "Content-Type": "application/x-www-form-urlencoded",';
    put '      "Accept": "text/html"';
    put '    },';
    put '    body: formData.toString()';
    put '  })';
    put '    .then(function (response) {';
    put '      if (!response.ok) {';
    put '        throw new Error("Network response was not ok: " + response.status);';
    put '      }';
    put '      return response.text();';
    put '    })';
    put '    .then(function () {';
    put '      showNotification("Report generated successfully for " + selectedDate + ". Downloading file...", "success");';
    put '      triggerReportDownload(reportType);';
    put '      hideLoading();';
    put '    })';
    put '    .catch(function (error) {';
    put '      hideLoading();';
    put '      console.error("Error executing stored procedure:", error);';
    put '      showNotification("Error generating report: " + error.message, "error");';
    put '    });';
    put '}';

%mend regulatoryReportGeneration;

