/* ============================================================================
   RISK DOMAIN CONFIGURATION
   Drives the "Risk Domains" grouping cards (route #domains).

   NOW FULLY DYNAMIC: every row here is emitted from work.raf_domains_final
   (one pre-built JS object literal per row, in its `js_line`/`js_len`
   fields), built by rafDataLoader.sas from the live RAF_Q2_2026.xlsx on
   this run - see that file for how domain membership is decided (a small
   structural lookup by Risk Area, since the sheet itself carries no "Risk
   Domain" column) and for the "Other Risks" catch-all any unrecognized
   Risk Area falls into instead of breaking the page.

   NOTE ON NAMING: this grouping is deliberately called "Domain", never
   "Pillar" - "Pillar" is reserved elsewhere in this app for the regulatory
   Pillar 1 / Pillar 2 classification (see the `comment` tag on each metric
   in appetiteMetricsConfig.sas, e.g. "P1"/"P2").

   The former `ragSplitPlaceholder` illustrative counts are gone - the RAG
   split shown on each domain card is now computed live from the domain's
   real metrics via RAFStatus.rollUpStatusCounts() in buildRAF.sas.

   Uses a DO/SET-POINT= loop (not a nested DATA step) because this macro's
   `put`s run as part of ERMS_Application.sas's one big enclosing
   `data _null_; file _webout; ... run;` step - see rafDataLoader.sas's
   file header for why the actual data prep can't happen here. work.raf_
   domains_final and &RAF_DOMAIN_NOBS. are built by %raf_load_excel_data,
   called once before that enclosing step starts. $VARYING + the trailing
   @ hold write each row's pre-trimmed js_line without its declared-length
   blank padding, then either a comma or a plain line break closes it.
   ============================================================================ */
%macro riskDomainsConfig;
    /* riskDomainsConfig / riskCategoriesConfig / appetiteMetricsConfig all
       run inside the ONE enclosing data _null_ step (ERMS_Application.sas),
       so their SET ... POINT= reads all share a single PDV. A handful of
       column names exist in more than one of work.raf_domains_final /
       raf_categories_final / raf_metrics_final with different declared
       lengths (e.g. "key" is $20 in the domains table but $80 in the
       categories table). Whichever SET statement runs first would
       otherwise silently fix that shorter length for the rest of the
       step, truncating the others. Declaring the widest length needed by
       any of the three, here, before the first SET below runs, avoids
       that - this must stay the first of the three macros raf_config_new
       calls. */
    length key title description $400 js_line $6000 committee frequency $2000;

    put 'const riskDomainsConfig = Object.freeze([';
    do _raf_i = 1 to &RAF_DOMAIN_NOBS.;
        set work.raf_domains_final point=_raf_i;
        put js_line $varying6000. js_len @;
        if _raf_i < &RAF_DOMAIN_NOBS. then put ',';
        else put;
    end;
    put ']);';
%mend riskDomainsConfig;
