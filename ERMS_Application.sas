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
    data _null_;
        file _webout;

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
