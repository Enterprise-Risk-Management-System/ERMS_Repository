
/* ============================================================================
   Module: Javascript/routes/riskAppetiteFramework/index.sas
   Description: Includes the Risk Appetite Framework's route builders and
   bundles them into %RAF_Routes. NEW module - does not modify any existing
   ERMS routes file.
   ============================================================================ */

%include "C:\Users\62917\ERMS\Javascript\routes\riskAppetiteFramework\raStyles.sas";
%include "C:\Users\62917\ERMS\Javascript\routes\riskAppetiteFramework\buildRAF.sas";
%include "C:\Users\62917\ERMS\Javascript\routes\riskAppetiteFramework\buildUnderProcessPlaceholders.sas";

%macro RAF_Routes;

    %generate_raf_styles;

    %buildRAF;

    %buildUnderProcessPlaceholders;

%mend RAF_Routes;
