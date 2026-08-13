/* ============================================================================
   RISK DOMAIN CONFIGURATION
   Drives the 4 "Risk Domains" grouping cards (route #domains). Groups the 15
   risk categories from the Excel sheet into 4 sets so no page ever shows
   more than ~7 category tiles at once.

   NOTE ON NAMING: this grouping is deliberately called "Domain", never
   "Pillar" - "Pillar" is reserved elsewhere in this app for the regulatory
   Pillar 1 / Pillar 2 classification (see the `comment` tag on each metric
   in appetiteMetricsConfig.sas, e.g. "P1"/"P2"). The domain grouping itself
   is a structural navigation aid, not sheet data - flag with the business
   owner if a different grouping is preferred.

   Each domain's `categories` array is the single source of truth for which
   category keys belong to it; riskCategoriesConfig.sas assigns each category
   the same key back via its own `domain` field. JS derives the reverse
   lookup (category -> domain) from this array at runtime - see RAFUI.
   ============================================================================ */
%macro riskDomainsConfig;
    put 'const riskDomainsConfig = Object.freeze([';
    put '  {';
    put '    key: "financial",';
    put '    title: "Financial Risks",';
    put '    description: "Capital adequacy, concentration, credit, liquidity, market and earnings - the core balance-sheet risk domains.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.7\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M2.3 10 L12 4 L21.7 10 Z\"/><line x1=\"3\" y1=\"21\" x2=\"21\" y2=\"21\"/><line x1=\"4.5\" y1=\"21\" x2=\"4.5\" y2=\"10.5\"/><line x1=\"9.5\" y1=\"21\" x2=\"9.5\" y2=\"10.5\"/><line x1=\"14.5\" y1=\"21\" x2=\"14.5\" y2=\"10.5\"/><line x1=\"19.5\" y1=\"21\" x2=\"19.5\" y2=\"10.5\"/></svg>",';
    put '    route: "#domain/financial",';
    put '    categories: ["capital","concentration","credit","liquidity","market","irrbb","earnings"],';
    put '    ragSplitPlaceholder: { good: 36, watch: 11, breach: 3, regulatoryBreach: 1 }';
    put '  },';
    put '  {';
    put '    key: "nonfinancial",';
    put '    title: "Non-Financial Risks",';
    put '    description: "Operational, fraud, cyber, legal and model risk - how well bank processes and controls hold up.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.7\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"4.3\"/><line x1=\"12\" y1=\"2.5\" x2=\"12\" y2=\"5.3\"/><line x1=\"12\" y1=\"18.7\" x2=\"12\" y2=\"21.5\"/><line x1=\"2.5\" y1=\"12\" x2=\"5.3\" y2=\"12\"/><line x1=\"18.7\" y1=\"12\" x2=\"21.5\" y2=\"12\"/><line x1=\"5.4\" y1=\"5.4\" x2=\"7.4\" y2=\"7.4\"/><line x1=\"16.6\" y1=\"16.6\" x2=\"18.6\" y2=\"18.6\"/><line x1=\"5.4\" y1=\"18.6\" x2=\"7.4\" y2=\"16.6\"/><line x1=\"16.6\" y1=\"7.4\" x2=\"18.6\" y2=\"5.4\"/></svg>",';
    put '    route: "#domain/nonfinancial",';
    put '    categories: ["operational","fraud","cyber","legal","model"],';
    put '    ragSplitPlaceholder: { good: 2, watch: 1, breach: 1, regulatoryBreach: 1 }';
    put '  },';
    put '  {';
    put '    key: "peopleconduct",';
    put '    title: "People, Conduct & Reputational Risk",';
    put '    description: "Workforce, conduct and reputational indicators - how the bank is run and how it is perceived.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.7\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"10\" cy=\"8\" r=\"4\"/><path d=\"M2.5 20.5 C2.5 16.4 6.1 13.5 10.5 13.5 C14.9 13.5 18.5 16.4 18.5 20.5\"/><path d=\"M18 2.5 L18.9 4.3 L20.9 4.6 L19.4 6 L19.8 8 L18 7 L16.2 8 L16.6 6 L15.1 4.6 L17.1 4.3 Z\"/></svg>",';
    put '    route: "#domain/peopleconduct",';
    put '    categories: ["people","reputational"],';
    put '    ragSplitPlaceholder: { good: 6, watch: 1, breach: 0, regulatoryBreach: 0 }';
    put '  },';
    put '  {';
    put '    key: "shariah",';
    put '    title: "Shariah & Compliance Risk",';
    put '    description: "Sharia non-compliance exposure across Islamic banking activities.",';
    put '    icon: "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.7\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M14.5 3 A9 9 0 1 0 14.5 21 A7.2 7.2 0 1 1 14.5 3 Z\"/></svg>",';
    put '    route: "#domain/shariah",';
    put '    categories: ["shariah"],';
    put '    ragSplitPlaceholder: { good: 1, watch: 0, breach: 0, regulatoryBreach: 0 }';
    put '  }';
    put ']);';
%mend riskDomainsConfig;
