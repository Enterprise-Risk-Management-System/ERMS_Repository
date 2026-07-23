


%macro saiborReportGeneration;
      put 'function resolveSaiborDate(){';
      put '    const hiddenDate = document.getElementById("saibor-date");';
      put '    const displayDate = document.getElementById("saibor-date-display");';
      put '    return (hiddenDate && hiddenDate.value) || (displayDate && displayDate.textContent) || new Date().toISOString().split("T")[0];';
      put '}';


      put 'function generateSaiborReport(reportType) {';
      put '  let selectedDate;';
      put '  try {';
	put '    selectedDate = resolveSaiborDate();';
	put '  } catch (error) {';
	put '    console.warn(error.message);';
	put '    return;';
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
	put '      "Accept": "application/json"';
	put '    },';
	put '    body: formData.toString()';
	put '  })';
	put '    .then(function (response) {';
	put '      if (!response.ok) {';
	put '        throw new Error("Network response was not ok: " + response.status);';
	put '      }';
	put '      return response.json();';
	put '    })';
	put '    .then(function (payload) {';
	put '      hideLoading();';
	put '      // Backend sends JSON with type: error|warning|info and message';
	put '      showModalMessage(payload);';
/*	put '      triggerReportDownload(reportType);';*/
	put '    })';
	put '    .catch(function (payload) {';
	put ' console.log(payload);';
	put '      hideLoading();';
/*	put '      console.error("Error executing stored procedure:", error);';*/
/*	put '      showModalMessage({ type: "error", message: "Error generating report: " + error.message });';*/
	put '      showModalMessage(payload);';
	put '    });';
	put '}';
%mend saiborReportGeneration;


