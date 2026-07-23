
/* ============================================================================
   RESOLVE USER ACCESS
   Orchestrates the authorization flow for a single request
   ============================================================================ */

%macro resolve_user_access;

    %global ALLOWED_CATEGORIES ALLOWED_CATEGORIES_STATUS;
    %let ALLOWED_CATEGORIES=;
    %let ALLOWED_CATEGORIES_STATUS=DEFAULT;

    %global ERMS_TEST_USER;
    %let _resolve_user = &sysuserid;
    %if %length(&ERMS_TEST_USER) > 0 %then %let _resolve_user = &ERMS_TEST_USER;

    %groupCategoryMapping;
    %fetch_user_groups(user=&_resolve_user);

    %let _categories=;
    %if %length(&USER_GROUPS_RAW) > 0 %then %do;
        data _null_;
            length grp $64 cat $20 catlist $200;
            retain catlist ' ';
            do i = 1 to countw("&USER_GROUPS_RAW", ' ');
                grp = scan("&USER_GROUPS_RAW", i, ' ');
                cat = strip(put(grp, $groupcat.));
                if cat ne ' ' and indexw(catlist, cat) = 0 then
                    catlist = strip(catlist) || ' ' || cat;
            end;
            call symputx('_categories', strip(catlist), 'L');
        run;
    %end;

    /* Union in the always-visible categories no matter what was resolved above */
    %let ALLOWED_CATEGORIES = %sysfunc(strip(&_categories %alwaysVisibleCategories));

    %if %length(%sysfunc(compress(&_categories))) > 0 %then %let ALLOWED_CATEGORIES_STATUS=OK;

    %put NOTE: [resolve_user_access] user=&_resolve_user status=&ALLOWED_CATEGORIES_STATUS allowed=&ALLOWED_CATEGORIES;

%mend resolve_user_access;

/* Shared predicate used by every gated put-block:
   %if %categoryAllowed(market) %then put '...'; */
%macro categoryAllowed(key);
%eval(%sysfunc(indexw("&ALLOWED_CATEGORIES","&key")) > 0)
%mend categoryAllowed;
