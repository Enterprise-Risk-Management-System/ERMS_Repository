/* ============================================================================
   ERMS Dashboard API - Loan Portfolio Data Population
   Enterprise Risk Management System
   ============================================================================ */

/* ============================================================================
   DATA STRUCTURE DEFINITIONS
   ============================================================================ */

%macro erms_api_config;
    %global ERMS_API_VERSION ERMS_DATA_LIB ERMS_OUTPUT_LIB ERMS_TEMP_LIB FILE_PATH;
    %let ERMS_API_VERSION = 1.0.0;
    %let ERMS_DATA_LIB = WORK;
    %let ERMS_OUTPUT_LIB = WORK;
    %let ERMS_TEMP_LIB = WORK;
    %let FILE_PATH = \\fsho\RiskManagt\31_RDM\Input\ERMS Dashboard;

    %global ERMS_CONTENT_TYPE ERMS_CHARSET;
    %let ERMS_CONTENT_TYPE = application/json;
    %let ERMS_CHARSET = UTF-8;

    %global ERMS_ERROR_LEVEL ERMS_LOG_LEVEL;
    %let ERMS_ERROR_LEVEL = 1;
    %let ERMS_LOG_LEVEL = 2;
%mend erms_api_config;

/* ============================================================================
   LOAN PORTFOLIO DATA INGESTION
   ============================================================================ */

%macro create_loan_portfolio_data;

    proc import datafile="\\fsho\RiskManagt\31_RDM\Input\ERMS Dashboard\Loan Portfolio.xlsx"
        dbms=xlsx out=loan_portfolio_raw replace;
    run;

    data work.loan_portfolio;
        set loan_portfolio_raw;

        length api_timestamp 8 api_version $10;
        api_timestamp = datetime();
        api_version = "&ERMS_API_VERSION";

        format api_timestamp datetime20.;
    run;

%mend create_loan_portfolio_data;

%create_loan_portfolio_data;

proc sql noprint;
    select count(*) into: count from WORK.loan_portfolio;
quit;

/* ============================================================================
   JSON RESPONSE GENERATOR
   ============================================================================ */

%macro generate_loan_portfolio_json(input_ds=, output_file=);
    %if &input_ds = %then %let input_ds = work.loan_portfolio;
    %if &output_file = %then %let output_file = &_webout;

    data _null_;
        file _webout;
        set &input_ds;

        length timestamp_str $25 api_version_str $10 records_count_str $8
               loan_category_str $50 nb_customers_str $10 nb_trade_str $10
               tenor_str $10 rate_str $10 fair_value_str $20
               y1_str $10 y1_3_str $10 y3_5_str $10 y5_7_str $10
               y7_10_str $10 y10_12_str $10 y12_15_str $10
               y15_20_str $10 y20p_str $10;

        timestamp_str = put(datetime(), is8601dt.);
        api_version_str = "&ERMS_API_VERSION";
        records_count_str = &count.;

        loan_category_str = strip(loan_category);
        nb_customers_str = strip(put(nb_of_customers, 8.));
        nb_trade_str = strip(put(nb_of_trade, 8.));
        tenor_str = strip(put(weighted_average_remaining_tenor, 8.2));
        rate_str = strip(put(weighted_average_rate, 8.2));
        fair_value_str = strip(put(fair_value_sar, comma20.2));
     
        y1_str = strip(put(_1Y, comma10.2));
        y1_3_str = strip(put(_1_3_years, comma10.2));
        y3_5_str = strip(put(_3_5_years, comma10.2));
        y5_7_str = strip(put(_5_7_years, comma10.2));
        y7_10_str = strip(put(_7_10_years, comma10.2));
        y10_12_str = strip(put(_10_12_years, comma10.2));
        y12_15_str = strip(put(_12_15_years, comma10.2));
        y15_20_str = strip(put(_15_20_years, comma10.2));
        y20p_str = strip(put(_20_plus_years, comma10.2));

        if _n_ = 1 then do;
            put '{"status": "success",';
            put '"api_version": "' api_version_str '",';
            put '"data_type": "loan_portfolio",';
            put '"records_count": ' records_count_str ',';
            put '"data": [';
        end;

        put '{';
        put '"loan_category": "' loan_category_str '",';
        put '"nb_of_customers": "' nb_customers_str '",';
        put '"nb_of_trade": "' nb_trade_str '",';
        put '"weighted_average_remaining_tenor": "' tenor_str '",';
        put '"weighted_average_rate": "' rate_str '",';
        put '"fair_value_sar": "' fair_value_str '",';
        put '"<1Y": "' y1_str '",';
        put '"1-3 Years": "' y1_3_str '",';
        put '"3-5 Years": "' y3_5_str '",';
        put '"5-7 Years": "' y5_7_str '",';
        put '"7-10 Years": "' y7_10_str '",';
        put '"10-12 Years": "' y10_12_str '",';
        put '"12-15 Years": "' y12_15_str '",';
        put '"15-20 Years": "' y15_20_str '",';
        put '"20+ Years": "' y20p_str '"';

        if _n_ = &count. then put '}]}';
        else put '},';
    run;
%mend generate_loan_portfolio_json;

/* ============================================================================
   API ENDPOINT FUNCTION
   ============================================================================ */

%macro execute_loan_portfolio_api(response_format=json);
    %erms_api_config;
    %generate_loan_portfolio_json(input_ds=work.loan_portfolio);
%mend execute_loan_portfolio_api;

/* Execute the Loan Portfolio API */
%execute_loan_portfolio_api;
