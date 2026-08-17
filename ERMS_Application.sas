%macro generate_erms_application;
    /* Initialize configuration */
    %erms_config;

    /* Risk Appetite Framework: read RAF_Q2_2026.xlsx and build the work.raf_*
       datasets riskDomainsConfig.sas / riskCategoriesConfig.sas /
       appetiteMetricsConfig.sas loop over below - added without touching any
       line above. Must run here, as its own top-level step, BEFORE the
       data _null_ step starts: PROC IMPORT and plain DATA steps can't be
       nested inside a running DATA step - see rafDataLoader.sas. */
    %raf_load_excel_data;

    /* Start HTML output */
    /* LRECL=32767 is explicit here because _webout's default record length
       on this server is small enough (empirically ~1024 bytes) that any
       single generated line longer than that gets HARD-WRAPPED with a real
       newline character - wherever that lands, not at any token boundary,
       since SAS just splits at the byte count. That is what was corrupting
       the RAF page''s inline <script>: long single-put lines like
       croDashboardConfig''s treemapByOwnership object ($8100) or an
       individual metric''s js_line ($6000) would get a raw line break
       shoved into the middle of a JS string or identifier - e.g.
       "Fraud Risk Department" landing exactly on a 1024-byte boundary came
       out as "Frau" + a real newline + "d Risk Department", which is
       exactly the browser''s "Invalid or unexpected token" - not a data/
       escaping problem at all, a record-length one. 32767 is SAS's own
       traditional line-length ceiling, comfortably above every generated
       line in this app (longest is treemap_line/opts_line at $8100). */
    data _null_;
        file _webout lrecl=32767;

        /* Generate HTML Structure */
        %generate_html_header;

        /* Generate UI Components */
        %generate_loading;
        %generate_notification;
        %generate_navbar;

        /* Generate Main Content */
        put '<main class="main-content">';
        %generate_page_header;
        %generate_modal;

        /* Generate Route Content Container */
        %generate_route_container;

        put '<script>';
        /* Generate Modal */
        %generate_javascript_modal;

        %erms_config_new;
        /* Generate JavaScript */
        %Api_Integrations;

        %generate_javascript_utils;

        /*	  %generate_javascript_content_gen;*/
        %Routes;

        %Report_Generation;

        %generate_javascript_routing;
        put '</body>';
        put '</html>';
    run;
%mend generate_erms_application;

%generate_erms_application;
