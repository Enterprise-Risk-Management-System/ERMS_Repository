

%macro reportDownloadMetadata;

    put 'const reportDownloadMetadata = Object.freeze({';
    put '  "sama-q17": {';
    put '    url: "https://enterprisebsl.anb.com.sa:443/B4_Q17_Report/" + encodeURIComponent("SAMA B4 Q17 Reports.xlsm"),';
    put '    fileName: "SAMA B4 Q17 Reports.xlsm"';
    put '  },';
    put '  "sama-p3": {';
    put '    url: "https://enterprisebsl.anb.com.sa:443/B4_P3_Report/" + encodeURIComponent("SAMA B4 P3 Reports.xlsm"),';
    put '    fileName: "SAMA B4 P3 Reports.xlsm"';
    put '  },';
    put '  "saibor": {';
    put '    url: "https://enterprisebsl.anb.com.sa:443/SAIBOR_Report/" + encodeURIComponent("SAIBOR Report.xlsm"),';
    put '    fileName: "SAIBOR Report.xlsm"';
    put '  }';
    put '});';

%mend reportDownloadMetadata;
