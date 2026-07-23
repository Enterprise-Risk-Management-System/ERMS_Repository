

%macro regulatoryReportsConfig;

    put 'const regulatoryReportsConfig = Object.freeze([';
    put '  {';
    put '    key: "sama-q17",';
    put '    title: "SAMA Q17 Report",';
    put '    description: "Quarterly regulatory report for SAMA compliance monitoring and risk assessment.",';
    put '    frequency: "Quarterly",';
    put '    latestDate: "2025-09-30",';
    put '    iconClass: "fas fa-chart-bar"';
    put '  },';
    put '  {';
    put '    key: "sama-p3",';
    put '    title: "SAMA P3 Report",';
    put '    description: "Periodic regulatory report for SAMA portfolio analysis and risk exposure assessment.",';
    put '    frequency: "Quarterly / Semi Annual / Annual",';
    put '    latestDate: "2025-09-30",';
    put '    iconClass: "fas fa-file-alt"';
    put '  }';
    put ']);';

%mend regulatoryReportsConfig;


