

%macro apiEndpoints;

    put 'const regulatoryReportEndpoints = Object.freeze({';
    put '  "sama-q17": "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Basel-4/SAMA Reporting/SAMA Q17 Reporting/B4_Q17_Report",';
    put '  "sama-p3": "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Basel-4/SAMA Reporting/SAMA Pillar 3 Reporting/B4_P3_Report",';
    put '  "saibor": "https://enterprisebsl.anb.com.sa/SASStoredProcess/do?&_program=/User Folders/62917/My Folder/Market Risk/SAIBOR_SAIBID"';
    put '});';
 
%mend apiEndpoints;
