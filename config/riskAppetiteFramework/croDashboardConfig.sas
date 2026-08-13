/* ============================================================================
   CRO DASHBOARD CONFIGURATION
   Drives the 4 zones on the landing page (route #dashboard): Critical Risk
   Indicators, Heatmap by Criticality, Treemap by Ownership, Trend Analysis
   by Pillar.

   EVERYTHING IN THIS FILE IS ILLUSTRATIVE SAMPLE DATA, matching the signed-
   off mockup (raf_dashboard_mockup.html) exactly, so the built app renders
   identically to what was approved. The real sheet has only one reporting
   period (Q2-2026); multi-period figures here (3-period tables, 4-period
   heatmap/treemap/trend) are fabricated to demonstrate the layout and must
   be replaced once real historical data is available from the backend -
   see RAF_Metrics_Backend.sas.
   ============================================================================ */
%macro croDashboardConfig;
    put 'const croDashboardConfig = Object.freeze({';
    put '  isPlaceholderData: true,';

    /* ---- KPI summary strip -------------------------------------------- */
    put '  kpi: {';
    put '    withinAppetitePct: 70, withinAppetiteCount: 45, watchCount: 13,';
    put '    breachCount: 4, regulatoryBreachCount: 2, totalCount: 64';
    put '  },';

    /* ---- Zone 1: Critical Risk Indicators ------------------------------ */
    put '  criticalIndicators: [';
    put '    { category: "liquidity", metricId: "lcr", riskArea: "Liquidity Risk", indicator: "Liquidity Coverage Ratio (LCR)",';
    put '      history: [';
    put '        { date: "2026-06-30", value: "128.4%", status: "good" },';
    put '        { date: "2026-03-31", value: "131.2%", status: "good" },';
    put '        { date: "2025-12-31", value: "119.8%", status: "watch" }';
    put '      ] },';
    put '    { category: "capital", metricId: "total-capital-rwa", riskArea: "Capital", indicator: "Total Capital by RWA (Pillar 1+2)",';
    put '      history: [';
    put '        { date: "2026-06-30", value: "17.2%", status: "good" },';
    put '        { date: "2026-03-31", value: "16.8%", status: "good" },';
    put '        { date: "2025-12-31", value: "15.9%", status: "watch" }';
    put '      ] },';
    put '    { category: "market", metricId: "var", riskArea: "Market Risk", indicator: "Value-at-Risk (VaR)",';
    put '      history: [';
    put '        { date: "2026-06-30", value: "SAR 42M", status: "watch" },';
    put '        { date: "2026-03-31", value: "SAR 38M", status: "good" },';
    put '        { date: "2025-12-31", value: "SAR 51M", status: "regulatoryBreach" }';
    put '      ] },';
    put '    { category: "irrbb", metricId: "eve", riskArea: "Interest Rate in the Banking Book", indicator: "Economic Value of Equity (EVE)",';
    put '      history: [';
    put '        { date: "2026-06-30", value: "4.1%", status: "good" },';
    put '        { date: "2026-03-31", value: "4.6%", status: "watch" },';
    put '        { date: "2025-12-31", value: "3.9%", status: "good" }';
    put '      ] },';
    put '    { category: "credit", metricId: "npl-ratio-total", riskArea: "Credit Risk", indicator: "Non-Performing Loans (NPL) Ratio - Total",';
    put '      history: [';
    put '        { date: "2026-06-30", value: "2.8%", status: "watch" },';
    put '        { date: "2026-03-31", value: "2.6%", status: "watch" },';
    put '        { date: "2025-12-31", value: "3.4%", status: "regulatoryBreach" }';
    put '      ] }';
    put '  ],';

    /* ---- Zone 2: Heatmap by Criticality --------------------------------- */
    put '  heatmapByCriticality: [';
    put '    { criticality: "Level 1", totalIndicators: 23, periods: [';
    put '      { date: "2026-06-30", good: 14, watch: 6, breach: 3, trend: "up" },';
    put '      { date: "2026-03-31", good: 13, watch: 7, breach: 3, trend: "down" },';
    put '      { date: "2025-12-31", good: 15, watch: 5, breach: 3, trend: "up" },';
    put '      { date: "2025-09-30", good: 12, watch: 8, breach: 3, trend: "up" }';
    put '    ] },';
    put '    { criticality: "Level 2A", totalIndicators: 29, periods: [';
    put '      { date: "2026-06-30", good: 19, watch: 7, breach: 3, trend: "up" },';
    put '      { date: "2026-03-31", good: 18, watch: 8, breach: 3, trend: "down" },';
    put '      { date: "2025-12-31", good: 20, watch: 6, breach: 3, trend: "up" },';
    put '      { date: "2025-09-30", good: 17, watch: 9, breach: 3, trend: "up" }';
    put '    ] },';
    put '    { criticality: "Level 2B", totalIndicators: 12, periods: [';
    put '      { date: "2026-06-30", good: 7, watch: 3, breach: 2, trend: "up" },';
    put '      { date: "2026-03-31", good: 6, watch: 4, breach: 2, trend: "down" },';
    put '      { date: "2025-12-31", good: 8, watch: 3, breach: 1, trend: "up" },';
    put '      { date: "2025-09-30", good: 6, watch: 4, breach: 2, trend: "up" }';
    put '    ] }';
    put '  ],';

    /* ---- Zone 3: Treemap by Ownership ------------------------------------ */
    put '  ownershipOptions: ["Enterprise Risk Management", "Credit", "Market Risk", "Finance and Planning"],';
    put '  treemapByOwnership: {';
    put '    "Enterprise Risk Management": [';
    put '      { date: "2026-06-30", good: 10, watch: 8, breach: 5 },';
    put '      { date: "2026-03-31", good: 7, watch: 10, breach: 6 },';
    put '      { date: "2025-12-31", good: 15, watch: 5, breach: 3 },';
    put '      { date: "2025-09-30", good: 8, watch: 7, breach: 8 }';
    put '    ]';
    put '  },';

    /* ---- Zone 4: Trend Analysis by Pillar --------------------------------- */
    put '  trendByPillar: {';
    put '    note: "No reference layout was supplied for this zone in the source spec - proposed treatment, confirm with business owner.",';
    put '    periods: ["2025-09-30", "2025-12-31", "2026-03-31", "2026-06-30"],';
    put '    pillar1WatchBreachCount: [9, 8, 10, 7],';
    put '    pillar2WatchBreachCount: [5, 6, 6, 8]';
    put '  }';

    put '});';
%mend croDashboardConfig;
