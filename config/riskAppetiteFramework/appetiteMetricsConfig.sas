/* ============================================================================
   APPETITE METRICS CONFIGURATION
   The full 64-indicator dataset from RAF_Q2_2026.xlsx, one entry per Risk
   Indicator row, grouped by Risk Area (category key - matches
   riskCategoriesConfig.sas). This is the single source of truth for every
   metric shown anywhere in the app (category detail meters, CRO Dashboard
   Zone 1 cards, the heatmap and treemap zones).

   SCHEMA per metric object:
     sNo               - original sheet row number (S.No column), for traceability
     id                - short stable slug, unique within its category
     indicator         - Risk Indicator (sheet column, verbatim)
     definition        - Definition (sheet column; lightly copy-edited only to
                         remove characters that do not survive non-UTF-8 SAS
                         session encodings - never to change meaning)
     thresholds        - { green, amber, red, regulatory } - Risk Tolerance
                         Limit columns, verbatim from the sheet as decimals
                         (e.g. 0.02 = 2%)
     thresholdsPlaceholder - true for every row: the sheet supplies the IDENTICAL
                         0.02/0.03/0.04/0.05 for all 64 metrics, confirmed with
                         the business owner to be provisional, not final limits
     direction         - "lower-is-better" for every row: the agreed placeholder
                         default (see directionPlaceholder) - real per-metric
                         direction (e.g. LCR/CAR are actually higher-is-better)
                         still needs business confirmation
     directionPlaceholder - true for every row, for the same reason
     frequency         - Monitoring Frequency (sheet column, verbatim)
     criticality        - Criticality Level (sheet column, verbatim: "Level 1",
                         "Level 2A", "Level 2B")
     owner             - Ownership (sheet column, verbatim)
     committee         - Review Committee (sheet column, verbatim)
     comment           - Comments (sheet column, verbatim short code: P1, P2,
                         ICAAP, F&P, MRD, ORD - rendered as a small tag badge,
                         not further interpreted business-side)
     currentValue      - Utilization Q2-2026 (sheet column). Every row is an
                         identical 0.1 in the source sheet.
     currentValuePlaceholder - true for every row: static from config until a
                         real backend call replaces it (agreed convention -
                         mirrors the reference app's SACCR_SAMPLE_DATA pattern)
   ============================================================================ */
%macro appetiteMetricsConfig;
    put 'const appetiteMetricsConfig = Object.freeze({';

    /* ---- Capital (5) ------------------------------------------------- */
    put '  capital: [';
    put '    { sNo: 1, id: "total-capital-rwa", indicator: "Total Capital by RWA (Pillar 1 + Pillar 2)",';
    put '      definition: "The Total Capital by RWA (or Capital Adequacy Ratio, CAR) measures the capital of the Bank in relation to its total risk-weighted assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "RMG", committee: "RMC", comment: "P1",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 2, id: "stressed-car-rwa", indicator: "Stressed CAR by RWA (Pillar 1 and Pillar 2)",';
    put '      definition: "Stressed CAR by RWA is a capital adequacy measure under stress scenarios. It reflects the resilience of the Bank under moderate stress conditions.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "RMG", committee: "RMC", comment: "P1",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 3, id: "leverage-ratio", indicator: "Leverage Ratio",';
    put '      definition: "Leverage ratio acts as a supplementary measure to the risk-based capital requirements.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "RMG", committee: "RMC", comment: "P1",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 24, id: "total-capital-rwa-pillar1", indicator: "Total Capital by RWA (Pillar 1)",';
    put '      definition: "The Total Capital by RWA (Pillar 1) measures the total capital of the Bank in relation to its pillar 1 RWA.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "RMG", committee: "RMC", comment: "P1",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 25, id: "cet1-capital-rwa", indicator: "CET1 Capital by RWA (Pillar 1)",';
    put '      definition: "The Common Equity Tier 1 (CET1) ratio is a critical component of a bank capital structure. The CET1 ratio compares the capital of the Bank against its pillar 1 RWA.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "RMG", committee: "RMC", comment: "P1",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Concentration Risk (10) --------------------------------------- */
    put '  concentration: [';
    put '    { sNo: 4, id: "single-group-counterparty-concentration", indicator: "Single / (Group) Counterparty Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the single counterparty (other than individual, or sole proprietorship).",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 5, id: "single-related-counterparty-concentration", indicator: "Single Related Counterparty Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the individual, or sole proprietorship or partnerships.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 6, id: "financial-subsidiary-counterparty-concentration", indicator: "Financial Subsidiary Counterparty Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the banking counterparty.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 7, id: "cumulative-related-counterparty-concentration", indicator: "Cumulative Related Counterparty Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the aggregated interconnected counterparty.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 8, id: "large-exposure-concentration", indicator: "Large Exposure Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the large exposures.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 26, id: "unsecured-exposure-concentration", indicator: "Unsecured Exposure Concentration Ratio",';
    put '      definition: "This ratio helps monitor concentration risk arising from the unsecured exposures.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "RMC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 27, id: "industry-concentration-wholesale", indicator: "Industry Concentration Ratio - Wholesale (Overall)",';
    put '      definition: "This metric helps identify and manage risk arising from overexposure to specific industries that may be vulnerable to cyclical, regulatory, or macroeconomic shocks.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "SCC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 28, id: "top20-borrower-concentration", indicator: "Top 20 Borrower Exposure Concentration Ratio",';
    put '      definition: "This metric helps identify and manage concentration risk arising from top 20 major borrower exposures.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "SCC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 53, id: "top5-borrower-concentration", indicator: "Top 5 Borrower Exposure Concentration Ratio",';
    put '      definition: "This metric helps identify and manage concentration risk arising from top 5 major group exposures.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Credit", committee: "SCC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 54, id: "top10-borrower-concentration", indicator: "Top 10 Borrower Exposure Concentration Ratio",';
    put '      definition: "This metric helps identify and manage concentration risk arising from top 10 major group exposures.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Credit", committee: "SCC", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Credit Risk (12) ---------------------------------------------- */
    put '  credit: [';
    put '    { sNo: 9, id: "npl-ratio-total", indicator: "Non-Performing Loans (NPL) Ratio - Total",';
    put '      definition: "The NPL Ratio - Total indicates the overall asset quality and credit risk exposure across the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit Risk", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 10, id: "npl-coverage-ratio", indicator: "NPL Coverage Ratio",';
    put '      definition: "NPL Coverage Ratio indicates the extent of funds ANB has kept aside from its profits to cover loan losses.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 29, id: "npl-ratio-wholesale", indicator: "Non-Performing Loans (NPL) Ratio - Wholesale",';
    put '      definition: "The NPL Ratio - Wholesale indicates the asset quality and credit risk specific to the wholesale lending activities across the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 30, id: "npl-ratio-retail", indicator: "Non-Performing Loans (NPL) Ratio - Retail",';
    put '      definition: "The NPL Ratio - Retail indicates the asset quality and credit risk specific to the retail lending activities across the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 31, id: "npl-ratio-sme", indicator: "Non-Performing Loans (NPL) Ratio - SME",';
    put '      definition: "The NPL Ratio - SME indicates the asset quality and credit risk specific to the SME lending activities across the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 32, id: "watchlist-exposure-ratio", indicator: "Watchlist Exposure Ratio",';
    put '      definition: "The Watchlist Exposure Ratio measures the proportion of total credit exposures of ANB that are classified under the internal watchlist category.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 33, id: "min-general-provision-coverage", indicator: "Minimum General Provision Coverage Ratio (Stage 1 and 2)",';
    put '      definition: "Minimum General Provision Coverage Ratio ensures that the Bank maintains a minimum buffer to absorb potential losses from exposures that have not yet defaulted.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 34, id: "stage2-exposures-ratio", indicator: "Stage 2 Exposures Ratio - Total",';
    put '      definition: "It indicates the percentage of exposures that have experienced a significant increase in credit risk but are not yet credit impaired.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 35, id: "retail-exposures-ratio", indicator: "Retail Exposures Ratio - Total",';
    put '      definition: "Retail exposure ratio measures the total credit exposures of the Bank classified as retail against the total gross exposure of the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 55, id: "provision-coverage-stage1", indicator: "Provision Coverage Ratio (Stage 1)",';
    put '      definition: "Provision Coverage Ratio (Stage 1) reflects the prudence of the Bank in provisioning for potential future losses on low-risk assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 56, id: "provision-coverage-stage2", indicator: "Provision Coverage Ratio (Stage 2)",';
    put '      definition: "Provision Coverage Ratio (Stage 2) reflects the preparedness of the Bank to absorb potential losses from higher risk performing assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 57, id: "provision-coverage-stage3", indicator: "Provision Coverage Ratio (Stage 3)",';
    put '      definition: "Provision Coverage Ratio (Stage 3) reflects the ability of the Bank to absorb losses from defaulted or severely deteriorated assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Credit", committee: "ECL Committee", comment: "ICAAP",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Liquidity Risk (11) -------------------------------------------- */
    put '  liquidity: [';
    put '    { sNo: 15, id: "lcr", indicator: "Liquidity Coverage Ratio (LCR)",';
    put '      definition: "LCR measures the ability of ANB to meet its short-term financial obligations. The LCR is calculated by comparing the high quality liquid assets of ANB to its total net cash flows, over a 30-day period.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 16, id: "nsfr", indicator: "Net Stability Funding Ratio (NSFR)",';
    put '      definition: "NSFR measures the proportion of long-term assets funded by stable funding and is calculated as the amount of available stable funding compared to amount of required stable funding over a one-year horizon.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 17, id: "liquidity-reserve-ratio", indicator: "Liquidity Reserve Ratio",';
    put '      definition: "The Liquidity Reserve Ratio (LRR) metric measures the proportion of the total liquid assets of the bank relative to its qualified customer deposits, ensuring compliance with liquidity requirements set by SAMA.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 18, id: "customer-loans-deposit-ratio", indicator: "Customer Loans - Deposit Ratio",';
    put '      definition: "The Customer Loans-Deposit Ratio reflects the ability of the bank to fund its lending activities through stable sources and ensures compliance with liquidity and funding requirements set by SAMA, as well as internal governance bodies.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 40, id: "max-interbank-dependency-overnight", indicator: "Maximum Interbank Dependency Ratio (Overnight)",';
    put '      definition: "The maximum interbank dependency ratio reflects the reliance of the Bank on highly volatile and short-term market funding, which can pose liquidity risk during stressed conditions.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 41, id: "max-interbank-dependency-total", indicator: "Maximum Interbank Dependency Ratio (Total)",';
    put '      definition: "The maximum interbank dependency ratio (total) reflects the reliance of the bank on interbank funding, which can pose liquidity risk during stressed market conditions.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 42, id: "liquidity-mismatch-0-7", indicator: "Liquidity Mismatch Ratio (0-7 days)",';
    put '      definition: "The liquidity mismatch ratio metric reflects the short-term liquidity position of the bank and ability to meet obligations without resorting to emergency funding.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 43, id: "liquidity-mismatch-8-30", indicator: "Liquidity Mismatch Ratio (8-30 days)",';
    put '      definition: "The liquidity mismatch ratio metric reflects the short-term liquidity position of the bank and ability to meet obligations without resorting to emergency funding.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 59, id: "funding-concentration-top10", indicator: "Funding Concentration Ratio - Top-10",';
    put '      definition: "The funding concentration ratio (Top 10) reflects the ability of the bank to withstand liquidity stress arising from the withdrawal of its largest depositors by maintaining sufficient liquid assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 2B", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 60, id: "funding-concentration-top20", indicator: "Funding Concentration Ratio - Top-20",';
    put '      definition: "The funding concentration ratio (Top 20) reflects the ability of the bank to withstand liquidity stress arising from the withdrawal of its largest depositors by maintaining sufficient liquid assets.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 2B", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 61, id: "funding-concentration-lfps", indicator: "Funding Concentration Ratio - LFPs",';
    put '      definition: "The funding concentration ratio (LFPs) metric reflects the ability of the bank to withstand liquidity stress arising from the withdrawal of large funding sources by maintaining sufficient liquid assets dedicated to those providers.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 2B", owner: "Market Risk", committee: "RMC/ALCO", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Market Risk (7) ------------------------------------------------ */
    put '  market: [';
    put '    { sNo: 19, id: "var", indicator: "Value-at-Risk (VaR)",';
    put '      definition: "The exposures measured in terms of VaR, by individual market risk factor and by aggregate across all market risk factors, should comply with the MATs approved by the Board/ExCom.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 1", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 20, id: "total-investments-total-assets", indicator: "Total Investments / Total Assets",';
    put '      definition: "This ratio reflects the asset allocation strategy of the bank and helps monitor exposure to market and credit risk through investment holdings.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 1", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 44, id: "interest-rate-dv01", indicator: "Interest Rate DV01",';
    put '      definition: "Limits on the change in portfolio value for a one basis point movement in interest rates, used to manage interest rate sensitivity.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 45, id: "fx-volume", indicator: "Foreign Exchange Volume",';
    put '      definition: "Predefined thresholds reflecting the dollar equivalent net positions in SAR and other currencies not to exceed the approved volume limits.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 46, id: "all-asset-classes", indicator: "All Asset Classes",';
    put '      definition: "Investment exposures, measured by notional principals and mark-to-market (MTM) and by various dimensions such as asset class, external credit rating, geographical locations, maturity and payment rank, should comply with the Board/ExCom limits and MATs set by MRPC. The exposures should at all times comply with the relevant regulatory ceilings on investments.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 47, id: "intl-investments-to-total-investment", indicator: "International Investments (Local/Foreign Currency) to Total Investment",';
    put '      definition: "This ratio reflects the exposure of the bank to cross-border investment risk, including foreign exchange, sovereign, and geopolitical risks.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 48, id: "intl-investments-to-regulatory-capital", indicator: "International Investments (Local/Foreign Currency) to Total Regulatory Capital (Tier 1 + Tier 2)",';
    put '      definition: "This ratio reflects the capacity of the bank to absorb potential losses from cross-border investments and manage country, currency, and geopolitical risks.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Daily", criticality: "Level 2A", owner: "Market Risk", committee: "ALCO, MRPC", comment: "MRD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- IRRBB (3) ------------------------------------------------------ */
    put '  irrbb: [';
    put '    { sNo: 13, id: "eve", indicator: "Economic Value of Equity (EVE)",';
    put '      definition: "The IRRBB exposure measured by EVE under the defined ANB and regulatory interest rate stress scenarios should comply with SAMA requirements and ALCO MATs.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 14, id: "earnings-at-risk", indicator: "Earnings at Risk",';
    put '      definition: "The IRRBB exposure net of non-term liabilities measured by EaR under +/- 100 bps shifts in yield curves should comply with ALCO MATs.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 1", owner: "Market Risk", committee: "RMC/ALCO", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 38, id: "reverse-cumulative-repricing-gaps", indicator: "Reverse Cumulative Repricing Gaps",';
    put '      definition: "The re-pricing gap exposures, both consolidated and those denominated in non-SAR currencies, should comply with the limits defined by the Board and ALCO. NOTE: the source sheet text for this definition was cut off after this point - verify the complete wording with the business owner.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Monthly", criticality: "Level 2A", owner: "Market Risk", committee: "RMC/ALCO", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Earnings and Financial Performance (3) -------------------------- */
    put '  earnings: [';
    put '    { sNo: 11, id: "roe", indicator: "Return on Equity (ROE) (Annualised)",';
    put '      definition: "ROE is a financial ratio that measures the performance of the Bank based on its average shareholders equity outstanding.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Finance and Planning", committee: "RMC", comment: "F&P",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 37, id: "cost-to-income-ratio", indicator: "Cost-to-Income Ratio (CIR)",';
    put '      definition: "Cost-to-Income Ratio is a financial metric that measures the operational efficiency of the Bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Finance and Planning", committee: "RMC", comment: "F&P",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 58, id: "roa", indicator: "Return on Assets (Annualized) (ROA)",';
    put '      definition: "ROA indicates how efficiently the Bank is using its assets to generate net income.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Finance and Planning", committee: "RMC", comment: "F&P",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- People and Conduct Risk (4) -------------------------------------- */
    put '  people: [';
    put '    { sNo: 22, id: "overall-saudization-rate", indicator: "Overall Saudization Rate (OSR)",';
    put '      definition: "The overall Saudization rate reflects compliance with local labor regulations and the commitment of the bank to nationalization objectives.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Human Resources Group", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 49, id: "staff-turnover", indicator: "Staff Turnover (Annualized)",';
    put '      definition: "The staff turnover ratio metric measures the annualized rate at which employees leave the organization during a given period. It reflects workforce stability and the effectiveness of employee retention strategies.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Human Resources Group", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 50, id: "people-non-compliance-ratio", indicator: "People Non-Compliance Ratio",';
    put '      definition: "The people non-compliance ratio reflects the effectiveness of compliance culture and governance within the organization.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Human Resources Group", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 63, id: "sama-mandatory-training-ratio", indicator: "SAMA Mandatory Training Ratio",';
    put '      definition: "The SAMA mandatory training ratio ensures that all relevant staff receive periodic training as required by SAMA.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Human Resources Group", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Reputational Risk (3) --------------------------------------------- */
    put '  reputational: [';
    put '    { sNo: 23, id: "credit-rating", indicator: "Credit Rating",';
    put '      definition: "Credit rating serves as a key quantitative indicator within the RAF, reflecting the perceived creditworthiness of the organization by external rating agencies. It encapsulates market confidence, financial resilience, and reputational standing.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Finance and Planning", committee: "RMC/ALCO", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 51, id: "stock-price-decline", indicator: "Stock Price Decline",';
    put '      definition: "The stock price decline metric measures the percentage decrease in the stock price of the bank over a quarter.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Finance and Planning", committee: "RMC/ALCO", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true },';
    put '    { sNo: 52, id: "negative-media-coverage-count", indicator: "Negative Media Coverage Count",';
    put '      definition: "The negative media coverage count reflects the public sentiment due to controversies, service failures and brand vulnerability to reputational shocks.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "PR and CSR and Marketing and Customer Experience", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Operational Risk (1) ---------------------------------------------- */
    put '  operational: [';
    put '    { sNo: 21, id: "operational-loss-ratio", indicator: "Operational Loss Ratio",';
    put '      definition: "Operational risk appetite is an integral part of the overall Risk Appetite of the Bank, expressed in terms of capital adequacy ratio.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "ORMD", committee: "ORC", comment: "ORD",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Fraud Risk (1) ------------------------------------------------------ */
    put '  fraud: [';
    put '    { sNo: 12, id: "fraud-losses-to-revenue", indicator: "Fraud Risk Losses to Revenue Ratio",';
    put '      definition: "The fraud risk losses to revenue reflects the financial impact of fraud risk on the earnings of the bank and helps monitor the effectiveness of fraud prevention and detection controls.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 1", owner: "Fraud Risk Department", committee: "RMC, CFGC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Cyber Security Risk (1) ---------------------------------------------- */
    put '  cyber: [';
    put '    { sNo: 36, id: "cyber-security-loss-ratio", indicator: "Cyber Security Loss Ratio",';
    put '      definition: "The cyber security loss ratio metric reflects the financial impact of cybersecurity incidents within the broader operational risk framework.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2A", owner: "Cyber Risk Department", committee: "RMC, Cyber SC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Legal Risk (1) --------------------------------------------------------- */
    put '  legal: [';
    put '    { sNo: 39, id: "legal-risk-capital-percentage", indicator: "Legal Risk Capital Percentage",';
    put '      definition: "The legal risk capital percentage metric measures the proportion of capital charge maintained for legal risk relative to the CET1 capital of the bank.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Annually", criticality: "Level 2A", owner: "Legal Department", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Model Risk (1) ----------------------------------------------------------- */
    put '  model: [';
    put '    { sNo: 62, id: "models-past-due-validation", indicator: "Total Models Past Due for Validation",';
    put '      definition: "The total models past due for validation reflects governance effectiveness and compliance with regulatory and internal standards for model validation.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Enterprise Risk Management", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ],';

    /* ---- Shariah Risk (1) ------------------------------------------------------------ */
    put '  shariah: [';
    put '    { sNo: 64, id: "sharia-non-compliance-risk-index", indicator: "Sharia Non-Compliance Risk Index",';
    put '      definition: "The SNCR reflects the overall exposure of the Bank to Sharia non-compliance risk across key Islamic banking activities.",';
    put '      thresholds: { green: 0.02, amber: 0.03, red: 0.04, regulatory: 0.05 }, thresholdsPlaceholder: true,';
    put '      direction: "lower-is-better", directionPlaceholder: true,';
    put '      frequency: "Quarterly", criticality: "Level 2B", owner: "Islamic Banking Division", committee: "RMC", comment: "P2",';
    put '      currentValue: 0.1, currentValuePlaceholder: true }';
    put '  ]';

    put '});';
%mend appetiteMetricsConfig;
