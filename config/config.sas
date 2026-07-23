
/* ============================================================================
   GLOBAL CONFIGURATION
   ============================================================================ */
%macro erms_config;
    /* Global variables for configuration */
    %global ERMS_TITLE ERMS_VERSION ERMS_COMPANY;
    %let ERMS_TITLE = Enterprise Risk Management System;
    %let ERMS_VERSION = 1.0.0;
    %let ERMS_COMPANY = ANB;
    
    /* External resource URLs - Replace with your company web server URLs */
    %global FONT_AWESOME_URL GOOGLE_FONTS_URL;
/*    %let FONT_AWESOME_URL = https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css;*/
/*    %let GOOGLE_FONTS_URL = https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap;*/
%mend erms_config;

/* ============================================================================
   HTML HEADER GENERATOR
   ============================================================================ */
%macro generate_html_header;
    put '<!DOCTYPE html>';
    put '<html lang="en">';
    put '<head>';
    put '<meta charset="UTF-8" />';
    put '<meta name="viewport" content="width=device-width, initial-scale=1.0" />';
    put '<title>Enterprise Risk Management System</title>';
    
    /* External CSS Resources */
/*    put '<link href="&FONT_AWESOME_URL" rel="stylesheet" />';*/
/*    put '<link href="&GOOGLE_FONTS_URL" rel="stylesheet" />';*/
    put '  <script type="text/javascript" src="https://tableau.anb.net/javascripts/api/viz_v1.js"></script>';
    
    /* Generate CSS */
    %generate_css_styles;
    
    put '</head>';
    put '<body>';
%mend generate_html_header;




