/* ============================================================================
   ERMS Dashboard API - Data Population System
   Enterprise Risk Management System
   ============================================================================ */
/* ============================================================================
   DATA STRUCTURE DEFINITIONS
   ============================================================================ */

%macro erms_api_config;
    /* Global variables for API configuration */
    %global ERMS_API_VERSION ERMS_DATA_LIB ERMS_OUTPUT_LIB ERMS_TEMP_LIB FILE_PATH;
    %let ERMS_API_VERSION = 1.0.0;
    %let ERMS_DATA_LIB = WORK;
    %let ERMS_OUTPUT_LIB = WORK;
    %let ERMS_TEMP_LIB = WORK;
    %let FILE_PATH = \\fsho\RiskManagt\31_RDM\Input\ERMS Dashboard;
    
    /* API Response Headers */
    %global ERMS_CONTENT_TYPE ERMS_CHARSET;
    %let ERMS_CONTENT_TYPE = application/json;
    %let ERMS_CHARSET = UTF-8;
    
    /* Error Handling */
    %global ERMS_ERROR_LEVEL ERMS_LOG_LEVEL;
    %let ERMS_ERROR_LEVEL = 1;
    %let ERMS_LOG_LEVEL = 2;
%mend erms_api_config;

/* Limit Compliance Data Structure */
%macro create_limit_compliance_data;

    proc import datafile="\\fsho\RiskManagt\31_RDM\Input\ERMS Dashboard\SAMA Compliance ratio.xlsx"
	 dbms=xlsx out = limit_compliance_1  replace;
    run;

    /* Retrieve and process limit compliance data */
    data work.limit_compliance;
        set work.limit_compliance_1(keep= limit_type -- Compliance_status);
        
        /* Add API metadata */
        length api_timestamp 8 api_version $10;
        api_timestamp = datetime();
        api_version = "&ERMS_API_VERSION";
        
        format api_timestamp datetime20.;
    run;

%mend create_limit_compliance_data;

%create_limit_compliance_data;

proc sql noprint;
	select count(*) into: count 
		from WORK.limit_compliance;
quit;

/* ============================================================================
   JSON RESPONSE GENERATORS
   ============================================================================ */

/* Generate JSON Response for Limit Compliance */
%macro generate_limit_compliance_json(input_ds=, output_file=);
    %if &input_ds = %then %let input_ds = work.limit_compliance_api;
    %if &output_file = %then %let output_file = &_webout;
    
    /* Generate JSON response manually for proper structure */
    /* LRECL=32767 - this server's _webout default record length is small
       enough (~1024 bytes, confirmed on the RAF page - see the matching
       note in ERMS_Application.sas) that a long single generated line gets
       hard-wrapped with a real mid-line newline wherever the byte count
       lands, corrupting JSON output the same way it corrupted RAF's JS. */
    data _null_;
        file _webout lrecl=32767;
        set &input_ds;
        
        /* Create formatted strings for JSON output */
        length timestamp_str $25 api_version_str $10 records_count_str $8 
               limit_type_str $50 limit_sama_str $20 limit_board_str $20 
               mat_alco_str $50 mat_cro_str $50 current_value_str $20 
               compliance_status_str $10 last_updated_str $25;
        
        /* Format variables for JSON output */
        timestamp_str = put(datetime(), is8601dt.);
        api_version_str = "&ERMS_API_VERSION";
        records_count_str = &count.;
        limit_type_str = strip(limit_type);
        limit_sama_str = strip(put(limit_sama, percent7.2));
        limit_board_str = strip(put(limit_board, percent7.2));
        mat_alco_str = strip(put(mat_alco, percent7.2));
        mat_cro_str = strip(put(mat_cro, percent7.2));
        current_value_str = strip(put(Value, percent7.2));
        compliance_status_str = strip(compliance_status);
        last_updated_str = strip(put(last_updated, is8601dt.));
        
        /* Generate JSON structure */
        if _n_ = 1 then do;
            put '{"status": "success",';
            put '"api_version": "' api_version_str '",';
            put '"data_type": "limit_compliance",';
            put '"records_count": ' records_count_str ',';
            put '"data": [';
        end;
        
        /* Generate JSON record */
        put '{';
        put '"limit_type": "' limit_type_str '",';
        put '"limit_sama": "' limit_sama_str '",';
        put '"limit_board": "' limit_board_str '",';
        put '"mat_alco": "' mat_alco_str '",';
        put '"mat_cro": "' mat_cro_str '",';
        put '"current_value": "' current_value_str '",';
        put '"compliance_status": "' compliance_status_str '",';
        put '"last_updated": "' last_updated_str '"';

        if _n_ = &count. then put '}]}';
        else put '},';
    run;
%mend generate_limit_compliance_json;

/* ============================================================================
   API ENDPOINT FUNCTIONS
   ============================================================================ */

/* API Endpoint: Get Limit Compliance Data */
%macro execute_api_endpoint(response_format=json);
    %erms_api_config;
    
    /* Generate JSON response */
    %generate_limit_compliance_json(input_ds=work.limit_compliance);

%mend execute_api_endpoint;


/* Execute the API endpoint */
%execute_api_endpoint;
