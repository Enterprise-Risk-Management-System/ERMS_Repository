

%macro generate_erms_application;
    /* Initialize configuration */
    %erms_config;

    /* Resolve which risk-category cards/nav links this user may see, based
       on SMC group membership  mocked in GroupSource.sas until the
       real groups exist. Must run before data _null_/file _webout starts -
       riskModulesConfig and generate_sidebar branch on ALLOWED_CATEGORIES
       while that step is being compiled. */
    %resolve_user_access;

    /* Start HTML output */
    data _null_;
        file _webout;
        
        /* Generate HTML Structure */
        %generate_html_header;

	  
        
        /* Generate UI Components */
        %generate_loading;
        %generate_notification;
        %generate_navbar;
        %generate_sidebar;
        
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
