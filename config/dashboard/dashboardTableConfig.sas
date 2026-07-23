

%macro dashboardTableConfig;

    put 'const dashboardTableConfig = Object.freeze({';
    put '  limitCompliance: {';
    put '    title: "Limit Compliance Overview - 30JUN2025",';
    put '    tableId: "limit-compliance-table",';
    put '    bodyId: "limit-compliance-tbody",';
    put '    headers: ["Limit compliance", "Limit - SAMA", "Limit - Board", "MAT ALCO", "MAT CRO", "Value", "Compliance status"]';
    put '  },';
    put '  loanPortfolio: {';
    put '    title: "Loan Portfolio Analysis - 19AUG2025 - SAR in (MM)",';
    put '    tableId: "loan-portfolio-table",';
    put '    bodyId: "loan-portfolio-tbody",';
    put '    headers: ["Loan Category", "Nb of customers", "Fair Value SAR", "Weighted average rate", "Weighted average remaining tenor", "<= 1 Year", "1 - 3 years", "3 - 5 years", "5 - 7 years", "7 - 10 years", "10 - 12 years", "12 - 15 years", "15 - 20 years", "20+ years"]';
    put '  }';
    put '});';


%mend dashboardTableConfig;
