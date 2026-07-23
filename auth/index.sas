
/* ============================================================================
   Module: auth/index.sas
   Description: Authorization domain assembler - user-group based card/nav
   visibility. Include order matters: source -> mapping -> orchestrator.
   ============================================================================ */

%include "C:\Users\62917\ERMS\auth\userGroupSource.sas";

%include "C:\Users\62917\ERMS\auth\groupCategoryMapping.sas";

%include "C:\Users\62917\ERMS\auth\resolveUserAccess.sas";
