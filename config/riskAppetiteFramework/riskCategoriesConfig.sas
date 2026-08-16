/* ============================================================================
   RISK CATEGORY CONFIGURATION
   Drives the Risk Category tiles (route #category/&lt;key&gt;), one per
   distinct "Risk Area" actually present in the source Excel sheet
   (RAF_Q2_2026.xlsx) on this run.

   NOW FULLY DYNAMIC: every row here is emitted from
   work.raf_categories_final (one pre-built JS object literal per row),
   built by rafDataLoader.sas. `owner` / `committee` / `frequency` are the
   distinct values across that category's actual sheet rows, comma-joined
   (mirrors how the old hand-typed config already combined e.g. "RMC, SCC"
   for a category whose rows carry more than one committee) - no longer
   hand-typed. `icon` is a small structural lookup by Risk Area (icons are
   presentation-only, not sheet data - same as the domain grouping); any
   Risk Area not yet in that lookup still gets a working tile with a
   generic icon and a generic description instead of breaking the page.

   The former `ragSplitPlaceholder` illustrative counts are gone - the RAG
   split shown on each tile is now computed live from that category's real
   metrics via RAFStatus.rollUpStatusCounts() in buildRAF.sas.

   Uses a DO/SET-POINT= loop, not a nested DATA step - see
   riskDomainsConfig.sas's header for why.
   ============================================================================ */
%macro riskCategoriesConfig;
    put 'const riskCategoriesConfig = Object.freeze([';
    do _raf_i = 1 to &RAF_CATEGORY_NOBS.;
        set work.raf_categories_final point=_raf_i;
        put js_line $varying6000. js_len @;
        if _raf_i < &RAF_CATEGORY_NOBS. then put ',';
        else put;
    end;
    put ']);';
%mend riskCategoriesConfig;
