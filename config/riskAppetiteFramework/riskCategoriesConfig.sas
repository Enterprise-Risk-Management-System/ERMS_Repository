/* ============================================================================
   RISK CATEGORY CONFIGURATION
   Drives the 15 risk-category tiles (route #category/&lt;key&gt;), one per
   "Risk Area" in the source Excel sheet (RAF_Q2_2026.xlsx). Each entry's
   `icon` is a self-contained, hand-authored inline SVG string (no external
   icon font/library, renders via currentColor) - same technique used
   throughout this app, mirroring the pattern documented in the reference
   app's riskModulesConfig.sas.

   `owner` / `committee` / `frequency` come straight from the sheet's
   Ownership / Review Committee / Monitoring Frequency columns. Where a
   category's rows carry more than one committee (e.g. Concentration Risk
   mixes RMC and SCC), both are shown, comma-separated, exactly as the sheet
   lists them.

   `ragSplitPlaceholder` is ILLUSTRATIVE SAMPLE DATA, not computed from real
   thresholds yet (every metric's Utilization Q2-2026 value in the sheet is
   an identical 0.1 placeholder - see appetiteMetricsConfig.sas). Replace
   with a real runtime computation once genuine period data is wired in.
   ============================================================================ */
%macro riskCategoriesConfig;
    put 'const riskCategoriesConfig = Object.freeze([';

    put '  {';
    put '    key: "capital", title: "Capital", domain: "financial",';
    put '    description: "Total Capital by RWA, Stressed CAR, Leverage Ratio, CET1 adequacy.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"3\" y=\"8\" width=\"18\" height=\"12\" rx=\"2\"/><path d=\"M7 8 V6 a5 5 0 0 1 10 0 v2\"/><circle cx=\"12\" cy=\"14\" r=\"1.5\"/></svg>",';
    put '    route: "#category/capital", indicatorCount: 5, owner: "RMG", committee: "RMC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 2, watch: 2, breach: 0, regulatoryBreach: 1 }';
    put '  },';
    put '  {';
    put '    key: "concentration", title: "Concentration Risk", domain: "financial",';
    put '    description: "Counterparty, industry and top-borrower exposure concentration ratios.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"9\"/><circle cx=\"12\" cy=\"12\" r=\"4\"/></svg>",';
    put '    route: "#category/concentration", indicatorCount: 10, owner: "Credit", committee: "RMC, SCC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 5, watch: 3, breach: 2, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "credit", title: "Credit Risk", domain: "financial",';
    put '    description: "NPL ratios by segment, provision coverage stages, watchlist exposure.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M4 19 L9 11 L13 15 L20 5\"/><path d=\"M15 5 L20 5 L20 10\"/></svg>",';
    put '    route: "#category/credit", indicatorCount: 12, owner: "Credit", committee: "ECL Committee", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 8, watch: 4, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "liquidity", title: "Liquidity Risk", domain: "financial",';
    put '    description: "LCR, NSFR, funding concentration, interbank dependency ratios.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 3 C12 3 5.5 11 5.5 15.5 C5.5 19.2 8.4 21.7 12 21.7 C15.6 21.7 18.5 19.2 18.5 15.5 C18.5 11 12 3 12 3 Z\"/></svg>",';
    put '    route: "#category/liquidity", indicatorCount: 11, owner: "Market Risk", committee: "RMC/ALCO", frequency: "Daily/Monthly",';
    put '    ragSplitPlaceholder: { good: 11, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "market", title: "Market Risk", domain: "financial",';
    put '    description: "VaR, DV01, FX volume, investment portfolio exposure limits.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M3 17 L9 11 L13 14 L21 6\"/><path d=\"M3 21 L21 21\"/></svg>",';
    put '    route: "#category/market", indicatorCount: 7, owner: "Market Risk", committee: "ALCO, MRPC", frequency: "Daily",';
    put '    ragSplitPlaceholder: { good: 5, watch: 2, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "irrbb", title: "IRRBB", domain: "financial",';
    put '    description: "Economic Value of Equity, Earnings at Risk, repricing gap exposure.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M4 12 h4 l2 -7 l4 14 l2 -7 h4\"/></svg>",';
    put '    route: "#category/irrbb", indicatorCount: 3, owner: "Market Risk", committee: "RMC/ALCO", frequency: "Monthly",';
    put '    ragSplitPlaceholder: { good: 2, watch: 0, breach: 1, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "earnings", title: "Earnings and Financial Performance", domain: "financial",';
    put '    description: "Return on Equity, Cost-to-Income Ratio, Return on Assets.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><line x1=\"2\" y1=\"21\" x2=\"22\" y2=\"21\"/><rect x=\"4\" y=\"14\" width=\"3.4\" height=\"7\" rx=\"0.6\"/><rect x=\"10.3\" y=\"9\" width=\"3.4\" height=\"12\" rx=\"0.6\"/><rect x=\"16.6\" y=\"4\" width=\"3.4\" height=\"17\" rx=\"0.6\"/></svg>",';
    put '    route: "#category/earnings", indicatorCount: 3, owner: "Finance and Planning", committee: "RMC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 3, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "people", title: "People and Conduct Risk", domain: "peopleconduct",';
    put '    description: "Saudization rate, staff turnover, non-compliance ratio, SAMA training.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"9\" cy=\"9\" r=\"3.2\"/><circle cx=\"17\" cy=\"10\" r=\"2.6\"/><path d=\"M3 20.5 C3 16.5 6 14 9.5 14 C12 14 14 15.3 15 17.3\"/><path d=\"M14.5 14.5 C16.7 14.5 19 15.9 19.8 18.3\"/></svg>",';
    put '    route: "#category/people", indicatorCount: 4, owner: "Human Resources Group", committee: "RMC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 4, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "reputational", title: "Reputational Risk", domain: "peopleconduct",';
    put '    description: "Credit rating, stock price decline, negative media coverage.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"9.5\" r=\"5.5\"/><path d=\"M7.2 14.3 L5.5 21.5 L12 18 L18.5 21.5 L16.8 14.3\"/></svg>",';
    put '    route: "#category/reputational", indicatorCount: 3, owner: "Finance and Planning", committee: "RMC/ALCO", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 2, watch: 1, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "operational", title: "Operational Risk", domain: "nonfinancial",';
    put '    description: "Operational Loss Ratio.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M4 12 A8 8 0 0 1 18 6.5\"/><path d=\"M20 12 A8 8 0 0 1 6 17.5\"/><path d=\"M18 3.5 V7 H14.5\"/><path d=\"M6 20.5 V17 H9.5\"/></svg>",';
    put '    route: "#category/operational", indicatorCount: 1, owner: "ORMD", committee: "ORC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 0, watch: 1, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "fraud", title: "Fraud Risk", domain: "nonfinancial",';
    put '    description: "Fraud Risk Losses to Revenue Ratio.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"4\" y=\"3\" width=\"12\" height=\"16\" rx=\"1.5\"/><line x1=\"7\" y1=\"7\" x2=\"13\" y2=\"7\"/><line x1=\"7\" y1=\"10.5\" x2=\"13\" y2=\"10.5\"/><circle cx=\"16.5\" cy=\"16.5\" r=\"3.2\"/><line x1=\"18.8\" y1=\"18.8\" x2=\"21\" y2=\"21\"/></svg>",';
    put '    route: "#category/fraud", indicatorCount: 1, owner: "Fraud Risk Department", committee: "RMC, CFGC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 1, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "cyber", title: "Cyber Security Risk", domain: "nonfinancial",';
    put '    description: "Cyber Security Loss Ratio.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 2.5 L20 5.5 L20 11 C20 16.5 16.5 20.5 12 22 C7.5 20.5 4 16.5 4 11 L4 5.5 Z\"/><circle cx=\"12\" cy=\"11.5\" r=\"2\"/><line x1=\"12\" y1=\"13.5\" x2=\"12\" y2=\"16\"/></svg>",';
    put '    route: "#category/cyber", indicatorCount: 1, owner: "Cyber Risk Department", committee: "RMC, Cyber SC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 0, watch: 0, breach: 0, regulatoryBreach: 1 }';
    put '  },';
    put '  {';
    put '    key: "legal", title: "Legal Risk", domain: "nonfinancial",';
    put '    description: "Legal Risk Capital Percentage.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"5\" y=\"2.5\" width=\"14\" height=\"19\" rx=\"1.5\"/><line x1=\"8\" y1=\"7\" x2=\"16\" y2=\"7\"/><line x1=\"8\" y1=\"10.5\" x2=\"16\" y2=\"10.5\"/><line x1=\"8\" y1=\"14\" x2=\"13\" y2=\"14\"/><path d=\"M8.5 18 L10.5 20 L15.5 15\"/></svg>",';
    put '    route: "#category/legal", indicatorCount: 1, owner: "Legal Department", committee: "RMC", frequency: "Annually",';
    put '    ragSplitPlaceholder: { good: 1, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "model", title: "Model Risk", domain: "nonfinancial",';
    put '    description: "Total Models Past Due for Validation.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"6\" cy=\"7\" r=\"2\"/><circle cx=\"18\" cy=\"7\" r=\"2\"/><circle cx=\"12\" cy=\"17\" r=\"2\"/><line x1=\"7.7\" y1=\"8.3\" x2=\"10.5\" y2=\"15.3\"/><line x1=\"16.3\" y1=\"8.3\" x2=\"13.5\" y2=\"15.3\"/><line x1=\"8\" y1=\"7\" x2=\"16\" y2=\"7\"/></svg>",';
    put '    route: "#category/model", indicatorCount: 1, owner: "Enterprise Risk Management", committee: "RMC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 0, watch: 0, breach: 1, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "shariah", title: "Shariah Risk", domain: "shariah",';
    put '    description: "Sharia Non-Compliance Risk Index.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M14.5 3 A9 9 0 1 0 14.5 21 A7.2 7.2 0 1 1 14.5 3 Z\"/></svg>",';
    put '    route: "#category/shariah", indicatorCount: 1, owner: "Islamic Banking Division", committee: "RMC", frequency: "Quarterly",';
    put '    ragSplitPlaceholder: { good: 1, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  }';

    put ']);';
%mend riskCategoriesConfig;
