

%macro riskModulesConfig;
    put 'const riskModulesConfig = Object.freeze([';

    /* Each block below is gated by %categoryAllowed(key), which reads
       ALLOWED_CATEGORIES set by auth/resolveUserAccess.sas. Trailing commas
       are kept on every entry (including the last emitted one) - trailing
       commas are legal in JS array literals, so whichever block ends up
       last after filtering never produces broken JSON-ish JS. */

    %if %categoryAllowed(regulatory) %then %do;
    put '  {';
    put '    key: "regulatory",';
    put '    title: "Regulatory Risk",';
    put '    description: "Comprehensive regulatory compliance reports and monitoring dashboards for regulatory authorities.",';
    put '    iconClass: "fas fa-gavel",';
    put '    route: "#regulatory-reports",';
    put '    stats: [';
    put '      { label: "Reports", value: "24" },';
    put '      { label: "Compliance", value: "98%" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(credit) %then %do;
    put '  {';
    put '    key: "credit",';
    put '    title: "Credit Risk",';
    put '    description: "Advanced credit risk assessment, portfolio analysis, and default probability modeling.",';
    put '    iconClass: "fas fa-credit-card",';
    put '    stats: [';
    put '      { label: "Exposure", value: "1.2M" },';
    put '      { label: "PD Rate", value: "2.3%" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(operational) %then %do;
    put '  {';
    put '    key: "operational",';
    put '    title: "Operational Risk",';
    put '    description: "Operational risk identification, assessment, and mitigation strategies across business units.",';
    put '    iconClass: "fas fa-cogs",';
    put '    stats: [';
    put '      { label: "Incidents", value: "156" },';
    put '      { label: "Loss", value: "$2.1M" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(market) %then %do;
    put '  {';
    put '    key: "market",';
    put '    title: "Market Risk",';
    put '    description: "Real-time market risk monitoring, VaR calculations, and stress-testing scenarios.",';
    put '    iconClass: "fas fa-chart-line",';
    put '    stats: [';
    put '      { label: "VaR (95%)", value: "$45M" },';
    put '      { label: "Volatility", value: "12.5%" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(liquidity) %then %do;
    put '  {';
    put '    key: "liquidity",';
    put '    title: "Liquidity Risk",';
    put '    description: "Liquidity risk assessment, cash flow projections, and funding stability analysis.",';
    put '    iconClass: "fas fa-water",';
    put '    stats: [';
    put '      { label: "LCR Ratio", value: "145%" },';
    put '      { label: "HQLA", value: "$850M" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(icaap) %then %do;
    put '  {';
    put '    key: "icaap",';
    put '    title: "ICAAP",';
    put '    description: "Internal Capital Adequacy Assessment Process and capital planning strategies.",';
    put '    iconClass: "fas fa-balance-scale",';
    put '    stats: [';
    put '      { label: "CAR", value: "18.5%" },';
    put '      { label: "Capital", value: "$2.8B" }';
    put '    ]';
    put '  },';
    %end;

    %if %categoryAllowed(ilaap) %then %do;
    put '  {';
    put '    key: "ilaap",';
    put '    title: "ILAAP",';
    put '    description: "Internal Liquidity Adequacy Assessment Process and liquidity risk management.",';
    put '    iconClass: "fas fa-tint",';
    put '    stats: [';
    put '      { label: "NSFR", value: "125%" },';
    put '      { label: "Stable Funding", value: "$1.2B" }';
    put '    ]';
    put '  },';
    %end;

    /* Always visible - unioned into ALLOWED_CATEGORIES regardless of group,
       see auth/groupCategoryMapping.sas %alwaysVisibleCategories */
    %if %categoryAllowed(saibor) %then %do;
    put '  {';
    put '    key: "saibor",';
    put '    title: "SAIBOR",';
    put '    description: "Daily SAIBOR and SAIBID submissions as part of regulatory and market obligations.",';
    put '    iconClass: "fas fa-tint",';
    put '    route: "#saibor-saibid",';
    put '    stats: [';
    put '      { label: "SAIBOR", value: "125%" },';
    put '      { label: "SAIBID", value: "$1.2B" }';
    put '    ]';
    put '  },';
    %end;

    put ']);';
%mend riskModulesConfig;
