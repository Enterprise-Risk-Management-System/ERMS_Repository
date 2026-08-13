%macro generate_erms_application;
    /* Initialize configuration */
    %erms_config;

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
