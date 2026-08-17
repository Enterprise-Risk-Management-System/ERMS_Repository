/* ============================================================================
   RAF EXCEL DATA LOADER  (NEW module)
   Single source of truth for the Risk Domain section: reads RAF_Q2_2026.xlsx
   fresh on every run and turns it into the SAS datasets that
   riskDomainsConfig.sas / riskCategoriesConfig.sas / appetiteMetricsConfig.sas
   loop over to emit the JS config objects. No metric-specific value, range,
   classification, domain, pointer position or colour is written literally
   anywhere in this file - everything below is either read from the sheet or
   is generic structural/navigation config (domain grouping, icons), exactly
   the same role riskDomainsConfig.sas's file header already documents that
   grouping as playing today.

   ENTRY POINT: %raf_load_excel_data - must be called once, OUTSIDE (before)
   the page's big `data _null_; file _webout;` step, because PROC IMPORT and
   plain DATA steps cannot be nested inside a running DATA step. See
   ERMS_Application.sas for the single call site.

   PIPELINE:
     1. %raf_import_raw            -> work.raf_source   (1 row per sheet row,
                                       positionally renamed, Risk Area still
                                       raw/un-carried-forward)
     2. %raf_carry_forward_classify -> work.raf_metrics_final (1 row per
                                       metric: parsed thresholds, inferred
                                       direction, RAG status, meter geometry,
                                       fully-built JS object text)
     3. %raf_build_category_domain  -> work.raf_categories_final,
                                       work.raf_domains_final
     4. row counts into macro vars for the emitting macros' POINT= loops

   SOURCE COLUMNS (RAF_Q2_2026 sheet, header rows 2-3, data from row 4,
   columns B-O): S.No | Risk Area | Risk Indicator | Definition |
   Risk Tolerance Limit (Green | Amber | Red | Regulatory) |
   Monitoring Frequency | Criticality Level | Ownership | Review Committee |
   Utilization Q2-2026 | Comments. "Risk Area" is a merged cell spanning all
   rows of one risk category - blank on every row but the first of each
   block, so it must be carried forward.

   GREEN/AMBER/RED/REGULATORY PARSING (confirmed with business owner):
   each cell may carry its own leading comparison sign (>=, <=, >, <, =)
   because direction genuinely differs by Risk Area. Utilization is tested
   against Green's own condition first, then Amber's, then Red's - first
   match wins - so direction never needs to be known up front. A cell with
   no sign (today's plain-number sheet) falls back to inferring the sign
   from that row's own Green/Amber/Red numeric ordering. Regulatory is
   never a 4th colour - it is always drawn as a grey reference marker.
   ============================================================================ */

/* ----------------------------------------------------------------------
   STEP 1: Import the raw sheet
   ---------------------------------------------------------------------- */
%macro raf_import_raw;

    /* The one editable setting this whole module depends on. Point this at
       wherever RAF_Q2_2026.xlsx lives in the real deployment (same
       convention as the hardcoded ERMS include paths already used
       throughout this project, e.g. config/riskAppetiteFramework/index.sas). */
    %global RAF_EXCEL_PATH RAF_EXCEL_SHEET;
    %let RAF_EXCEL_PATH = C:\Users\62917\ERMS\data\RAF_Q2_2026.xlsx;
    %let RAF_EXCEL_SHEET = RAF_Q2_2026;

    /* RANGE deliberately runs far past the ~64 rows the sheet has today -
       adding or removing metric rows in Excel needs no code change here.
       Trailing blank rows are dropped in step 2. GUESSINGROWS=32767 makes
       PROC IMPORT scan every real row before deciding a column's type, so
       a threshold column that is all plain numbers today (no sign anywhere
       in it) still imports cleanly, and one that later mixes in signed
       text (">=0.12") imports as character instead of silently losing the
       sign. */
    proc import datafile="&RAF_EXCEL_PATH."
        out=work.raf_import_raw
        dbms=xlsx
        replace;
        range="&RAF_EXCEL_SHEET.$B4:O5000";
        getnames=no;
        guessingrows=32767;
    run;

    /* Positional rename - never assume PROC IMPORT's default variable
       names (they vary by SAS version). Read the 14 columns off
       dictionary.columns in their actual left-to-right order instead. */
    proc sql noprint;
        select name into :raf_col1-:raf_col14
            from dictionary.columns
            where libname='WORK' and memname='RAF_IMPORT_RAW'
            order by varnum;
    quit;

    data work.raf_source;
        set work.raf_import_raw(rename=(
            &raf_col1.=sno         &raf_col2.=riskarea     &raf_col3.=indicator
            &raf_col4.=definition  &raf_col5.=green_raw    &raf_col6.=amber_raw
            &raf_col7.=red_raw     &raf_col8.=reg_raw       &raf_col9.=frequency
            &raf_col10.=criticality &raf_col11.=ownership   &raf_col12.=committee
            &raf_col13.=util_raw   &raf_col14.=comments
        ));
    run;

    /* Record the actual imported type ('num' or 'char') of every column
       whose content can legitimately be either, so step 2 can branch to
       the right conversion instead of guessing. */
    %global RAF_T_GREEN RAF_T_AMBER RAF_T_RED RAF_T_REG RAF_T_UTIL;
    proc sql noprint;
        select upcase(type) into :RAF_T_GREEN trimmed from dictionary.columns
            where libname='WORK' and memname='RAF_SOURCE' and upcase(name)='GREEN_RAW';
        select upcase(type) into :RAF_T_AMBER trimmed from dictionary.columns
            where libname='WORK' and memname='RAF_SOURCE' and upcase(name)='AMBER_RAW';
        select upcase(type) into :RAF_T_RED trimmed from dictionary.columns
            where libname='WORK' and memname='RAF_SOURCE' and upcase(name)='RED_RAW';
        select upcase(type) into :RAF_T_REG trimmed from dictionary.columns
            where libname='WORK' and memname='RAF_SOURCE' and upcase(name)='REG_RAW';
        select upcase(type) into :RAF_T_UTIL trimmed from dictionary.columns
            where libname='WORK' and memname='RAF_SOURCE' and upcase(name)='UTIL_RAW';
    quit;

%mend raf_import_raw;


/* ----------------------------------------------------------------------
   Small text-safety helper, expanded inline wherever a sheet text field is
   about to be embedded into a JS double-quoted string: escapes backslash
   and double-quote, and flattens any embedded line breaks. Text-substitution
   macro (compiles to repeated statements), not a callable function - keeps
   this logic in one place instead of retyping it per field.
   ---------------------------------------------------------------------- */
%macro raf_jsesc(var);
    &var. = tranwrd(&var., '\', '\\');
    &var. = tranwrd(&var., '"', '\"');
    &var. = tranwrd(&var., '0D0A'x, ' ');
    &var. = tranwrd(&var., '0A'x, ' ');
    &var. = tranwrd(&var., '0D'x, ' ');
    &var. = strip(&var.);
%mend raf_jsesc;

/* Normalizes one Green/Amber/Red/Regulatory/Utilization cell (numeric or
   character, per the recorded type) into a plain text representation so
   the single parsing block below never has to care which it started as. */
%macro raf_to_text(rawvar, txtvar, srctype);
    length &txtvar. $50;
    %if &srctype. = NUM %then %do;
        if missing(&rawvar.) then &txtvar. = '';
        else &txtvar. = strip(put(&rawvar., best20.));
    %end;
    %else %do;
        &txtvar. = strip(&rawvar.);
    %end;
%mend raf_to_text;

/* Parses "&txtvar." into an operator + numeric value, via two compiled
   regexes:
     &re_range. first  - an interval like "[3.5%, 7.0%)" / "(3.5, 7]" -
                          "[": lower bound inclusive (>=), "(": exclusive (>);
                          "]": upper bound inclusive (<=), ")": exclusive (<).
                          Both bounds are returned (&op2var./&val2var.).
     &re_id.    else    - a single condition like ">=0.12", "7.0%", "< 5 %".
   Whichever matches, a captured trailing "%" divides that side's number by
   100 - the sheet mixes plain fractions (e.g. "0.02", already 0-1) with
   explicit percentages (e.g. "7.0%"), and both must land in the same 0-1
   convention Utilization itself uses (see the Utilization parsing below)
   or every comparison silently compares mismatched units.
   Never aborts the step - unparseable text just leaves the *_valid flag
   at 0, which downstream logic treats as "this tier is not usable",
   consistent with the app's existing error-handling default. */
%macro raf_parse_cell(txtvar, opvar, valvar, op2var, val2var, validvar);
    length &opvar. $2 &op2var. $2;
    &opvar. = ''; &valvar. = .; &op2var. = ''; &val2var. = .; &validvar. = 0;
    if not missing(&txtvar.) then do;
        if prxmatch(re_range, strip(&txtvar.)) > 0 then do;
            _b1 = strip(prxposn(re_range, 1, strip(&txtvar.)));
            _numtxt  = strip(prxposn(re_range, 2, strip(&txtvar.)));
            _pct1    = prxposn(re_range, 3, strip(&txtvar.));
            _numtxt2 = strip(prxposn(re_range, 4, strip(&txtvar.)));
            _pct2    = prxposn(re_range, 5, strip(&txtvar.));
            _b2 = strip(prxposn(re_range, 6, strip(&txtvar.)));
            _numtxt  = tranwrd(_numtxt, ',', '.');
            _numtxt2 = tranwrd(_numtxt2, ',', '.');
            &valvar.  = input(_numtxt, ?? best20.);
            &val2var. = input(_numtxt2, ?? best20.);
            if not missing(&valvar.)  and not missing(_pct1) then &valvar.  = &valvar. / 100;
            if not missing(&val2var.) and not missing(_pct2) then &val2var. = &val2var. / 100;
            &opvar.  = ifc(_b1 = '[', '>=', '>');
            &op2var. = ifc(_b2 = ']', '<=', '<');
            if not missing(&valvar.) and not missing(&val2var.) then &validvar. = 1;
        end;
        else if prxmatch(re_id, strip(&txtvar.)) > 0 then do;
            &opvar. = strip(prxposn(re_id, 1, strip(&txtvar.)));
            _numtxt = strip(prxposn(re_id, 2, strip(&txtvar.)));
            _pct1   = prxposn(re_id, 3, strip(&txtvar.));
            _numtxt = tranwrd(_numtxt, ',', '.');
            &valvar. = input(_numtxt, ?? best20.);
            if not missing(&valvar.) and not missing(_pct1) then &valvar. = &valvar. / 100;
            if not missing(&valvar.) then &validvar. = 1;
        end;
    end;
%mend raf_parse_cell;

/* Tests utilization against one already-parsed tolerance condition, which
   may be one-sided (op/val only) or a range (op/val AND op2/val2 - both
   must pass). Inclusive/exclusive at each boundary is exactly whatever the
   sheet's own sign/bracket says - this is where the "value exactly equal
   to a boundary" requirement is handled, driven entirely by the sheet, not
   a hardcoded assumption. */
%macro raf_test_cond(opvar, valvar, op2var, val2var, validvar, hitvar);
    &hitvar. = 0;
    if &validvar. and util_valid then do;
        _pass1 = 0;
        if &opvar. = '>=' and util_num >= &valvar. then _pass1 = 1;
        else if &opvar. = '<=' and util_num <= &valvar. then _pass1 = 1;
        else if &opvar. = '>'  and util_num >  &valvar. then _pass1 = 1;
        else if &opvar. = '<'  and util_num <  &valvar. then _pass1 = 1;
        else if &opvar. = '='  and util_num =  &valvar. then _pass1 = 1;
        _pass2 = 1;
        if not missing(&val2var.) then do;
            _pass2 = 0;
            if &op2var. = '<=' and util_num <= &val2var. then _pass2 = 1;
            else if &op2var. = '<'  and util_num <  &val2var. then _pass2 = 1;
            else if &op2var. = '>=' and util_num >= &val2var. then _pass2 = 1;
            else if &op2var. = '>'  and util_num >  &val2var. then _pass2 = 1;
        end;
        if _pass1 and _pass2 then &hitvar. = 1;
    end;
%mend raf_test_cond;

/* Builds a human-readable label for one tier ("&gt;=7%" or the full
   "&gt;=3.5%,&lt;7%" for a range) used for the meter-scale text - see
   appetiteResultsView.sas, which prefers this over reconstructing a label
   from the raw op/value alone. */
%macro raf_tier_label(labelvar, validvar, opvar, valvar, op2var, val2var);
    if not &validvar. then &labelvar. = '-';
    else if not missing(&val2var.) then
        &labelvar. = strip(&opvar.) || strip(put(&valvar.*100, 8.1)) || '%,'
                     || strip(&op2var.) || strip(put(&val2var.*100, 8.1)) || '%';
    else &labelvar. = strip(&opvar.) || strip(put(&valvar.*100, 8.1)) || '%';
%mend raf_tier_label;


/* ----------------------------------------------------------------------
   STEP 2: carry Risk Area forward, parse tolerances, classify, compute
   meter geometry, build the finished per-metric JS object text.
   ---------------------------------------------------------------------- */
%macro raf_carry_forward_classify;

    data work.raf_metrics_final;
        length riskarea_cf $150 riskarea_disp $150 category_key $80 id_base $120 id $130
               slug_key $210
               indicator definition ownership committee comments $2000
               frequency criticality $100
               green_txt amber_txt red_txt reg_txt util_txt $50
               green_op amber_op red_op reg_op $2
               green_op2 amber_op2 red_op2 reg_op2 $2
               green_label amber_label red_label reg_label $40
               dir_hint $4
               _numtxt _numtxt2 _clean $30
               _b1 _b2 _pct1 _pct2 $2
               status $6
               thresh_green_js thresh_amber_js thresh_red_js thresh_reg_js $12
               util_js $16
               bands_js $600 tmp $150 _tl $6
               js_line $6000;
        retain re_id re_range riskarea_cf;
        array bnd_val[3] _temporary_;
        array bnd_lbl[3] $6 _temporary_;
        if _n_ = 1 then do;
            /* optional leading sign, then a signed decimal number, then an
               optional trailing "%" - e.g. ">=12", "< 0.04", "5%", "-2.5" */
            re_id = prxparse('/^\s*(>=|<=|>|<|=)?\s*([+-]?[0-9]+(?:[.,][0-9]+)?)\s*(%)?\s*$/');
            /* an interval like "[3.5%, 7.0%)" or "(3.5, 7]" - see
               %raf_parse_cell above for what each bracket means */
            re_range = prxparse('/^\s*([\[\(])\s*([+-]?[0-9]+(?:[.,][0-9]+)?)\s*(%)?\s*,\s*([+-]?[0-9]+(?:[.,][0-9]+)?)\s*(%)?\s*([\]\)])\s*$/');
            declare hash _idh();
            _idh.defineKey('slug_key');
            _idh.defineData('slug_key','_cnt');
            _idh.defineDone();
        end;
        set work.raf_source;

        /* ---- carry the merged "Risk Area" cell forward ---- */
        if not missing(riskarea) then riskarea_cf = strip(riskarea);
        if missing(riskarea_cf) then delete;      /* nothing to carry yet - stray leading blank row */
        if missing(indicator) then delete;         /* past the last real data row */

        /* ---- normalize every tolerance/utilization cell to text ---- */
        %raf_to_text(green_raw, green_txt, &RAF_T_GREEN.)
        %raf_to_text(amber_raw, amber_txt, &RAF_T_AMBER.)
        %raf_to_text(red_raw,   red_txt,   &RAF_T_RED.)
        %raf_to_text(reg_raw,   reg_txt,   &RAF_T_REG.)
        %raf_to_text(util_raw,  util_txt,  &RAF_T_UTIL.)

        /* ---- parse each into (operator, numeric value[, operator2, value2], valid?) ---- */
        %raf_parse_cell(green_txt, green_op, green_val, green_op2, green_val2, green_valid)
        %raf_parse_cell(amber_txt, amber_op, amber_val, amber_op2, amber_val2, amber_valid)
        %raf_parse_cell(red_txt,   red_op,   red_val,   red_op2,   red_val2,   red_valid)
        %raf_parse_cell(reg_txt,   reg_op,   reg_val,   reg_op2,   reg_val2,   reg_valid)

        /* Utilization is a plain measured value, never signed - parse just
           the number, ignoring any accidental leading sign. Same 0-1
           convention as the tolerance cells above: a trailing "%" divides
           by 100, a bare number (e.g. "0.156") is taken as already 0-1. */
        util_num = .; util_valid = 0;
        if not missing(util_txt) then do;
            _has_pct = (index(util_txt, '%') > 0);
            _clean = compress(util_txt, '%');   /* drop a trailing "%" if present */
            _clean = compress(_clean, ' ');
            _clean = tranwrd(_clean, ',', '.');
            util_num = input(_clean, ?? best20.);
            if not missing(util_num) then do;
                util_valid = 1;
                if _has_pct then util_num = util_num / 100;
            end;
        end;

        /* ---- where a tolerance cell had no explicit sign, infer one from
           this row's own Green/Amber/Red numeric ordering (ascending ->
           "safer when lower" -> <=, descending -> "safer when higher" ->
           >=). Only used when the cell parsed to a number but carried no
           operator; a cell that failed to parse at all stays invalid and
           is simply excluded from evaluation. ---- */
        dir_hint = '';
        if green_valid and amber_valid and red_valid then do;
            if green_val <= amber_val and amber_val <= red_val then dir_hint = 'ASC';
            else if green_val >= amber_val and amber_val >= red_val then dir_hint = 'DESC';
        end;
        if green_valid and missing(green_op) then green_op = ifc(dir_hint='DESC','>=','<=');
        if amber_valid and missing(amber_op) then amber_op = ifc(dir_hint='DESC','>=','<=');
        if red_valid   and missing(red_op)   then red_op   = ifc(dir_hint='DESC','>=','<=');
        if reg_valid   and missing(reg_op)   then reg_op   = ifc(dir_hint='DESC','>=','<=');

        /* ---- classify: Green's own condition first, then Amber's, then
           Red's - first match wins. If none match but at least one tier
           is usable, Utilization is beyond every defined tier -> Red. If
           no tier at all is usable, leave status blank; the JS layer
           already defaults an unusable metric to a safe neutral status,
           same as it does today. ---- */
        %raf_test_cond(green_op, green_val, green_op2, green_val2, green_valid, hit_green)
        %raf_test_cond(amber_op, amber_val, amber_op2, amber_val2, amber_valid, hit_amber)
        %raf_test_cond(red_op,   red_val,   red_op2,   red_val2,   red_valid,   hit_red)
        if hit_green then status = 'green';
        else if hit_amber then status = 'amber';
        else if hit_red then status = 'red';
        else if util_valid and (green_valid or amber_valid or red_valid) then status = 'red';
        else status = '';

        /* ---- meter geometry: scale spans the valid threshold values only
           (never stretched by Utilization itself), with headroom past the
           furthest one - mirrors the app's existing "scaleMax = furthest
           threshold * 1.2" idea, generalized to also cover negative/
           descending scales. Every position is clamped to [0,100] so the
           pointer can never land outside the visible track. ---- */
        /* Each tier's upper bound (val2, only present for a range like
           "[3.5%, 7.0%)") is folded in too, so the scale properly stretches
           to cover it - the band SEGMENTS drawn below still split on each
           tier's lower/primary value only (a range's own upper edge isn't
           separately drawn as a band boundary); that's a deliberate visual
           simplification, not a classification one - the RAG classification
           above already tests both bounds correctly regardless. */
        _max = .; _min = .;
        if green_valid then do;
            if missing(_max) or green_val>_max then _max=green_val; if missing(_min) or green_val<_min then _min=green_val;
            if not missing(green_val2) then do; if green_val2>_max then _max=green_val2; if green_val2<_min then _min=green_val2; end;
        end;
        if amber_valid then do;
            if missing(_max) or amber_val>_max then _max=amber_val; if missing(_min) or amber_val<_min then _min=amber_val;
            if not missing(amber_val2) then do; if amber_val2>_max then _max=amber_val2; if amber_val2<_min then _min=amber_val2; end;
        end;
        if red_valid   then do;
            if missing(_max) or red_val>_max   then _max=red_val;   if missing(_min) or red_val<_min   then _min=red_val;
            if not missing(red_val2) then do; if red_val2>_max then _max=red_val2; if red_val2<_min then _min=red_val2; end;
        end;
        if reg_valid   then do;
            if missing(_max) or reg_val>_max   then _max=reg_val;   if missing(_min) or reg_val<_min   then _min=reg_val;
            if not missing(reg_val2) then do; if reg_val2>_max then _max=reg_val2; if reg_val2<_min then _min=reg_val2; end;
        end;
        if missing(_max) then do; _max = 1; _min = 0; end;
        scale_min = min(0, _min);
        scale_max = _max + (_max - scale_min) * 0.2;
        if scale_max <= scale_min then scale_max = scale_min + 1;
        _range = scale_max - scale_min;

        if util_valid then marker_left_pct = max(0, min(100, (util_num - scale_min) / _range * 100));
        else marker_left_pct = .;
        if reg_valid then reg_left_pct = max(0, min(100, (reg_val - scale_min) / _range * 100));
        else reg_left_pct = .;

        /* Bands: sort whichever of Green/Amber/Red are valid by their own
           numeric value ascending - that sorted left-to-right order IS the
           correct band order regardless of direction (a metric where
           green>amber>red sorts to red,amber,green left-to-right; one
           where green<amber<red sorts to green,amber,red), so no separate
           direction flag is needed here. Each band's segment runs from the
           previous boundary to its own value, except the last, which
           extends to the scale's edge (mirrors "beyond the last defined
           tier" the same way the app already draws it today). */
        n_bnd = 0;
        if green_valid then do; n_bnd+1; bnd_val[n_bnd]=green_val; bnd_lbl[n_bnd]='green'; end;
        if amber_valid then do; n_bnd+1; bnd_val[n_bnd]=amber_val; bnd_lbl[n_bnd]='amber'; end;
        if red_valid   then do; n_bnd+1; bnd_val[n_bnd]=red_val;   bnd_lbl[n_bnd]='red';   end;
        /* NOTE: the bounds check (_j > 1) and the array comparison are
           deliberately two SEPARATE statements, not one "_j > 1 and
           bnd_val[_j] < bnd_val[_j-1]" condition - SAS does not guarantee
           AND short-circuits before evaluating the array reference, so
           combining them let bnd_val[_j-1] get evaluated as bnd_val[0]
           once _j reached 1, which is out of range for a 3-element array
           and stopped the step ("Array subscript out of range"). The
           IF/LEAVE below only ever touches bnd_val[_j-1] after the WHILE
           has already confirmed _j > 1 on its own. */
        do _i = 2 to n_bnd;
            _j = _i;
            do while (_j > 1);
                if bnd_val[_j] >= bnd_val[_j-1] then leave;
                _tv = bnd_val[_j]; bnd_val[_j] = bnd_val[_j-1]; bnd_val[_j-1] = _tv;
                _tl = bnd_lbl[_j]; bnd_lbl[_j] = bnd_lbl[_j-1]; bnd_lbl[_j-1] = _tl;
                _j = _j - 1;
            end;
        end;
        bands_js = '[';
        _prev = scale_min;
        do _i = 1 to n_bnd;
            if _i < n_bnd then _thisv = bnd_val[_i]; else _thisv = scale_max;
            _lp = max(0, min(100, (_prev  - scale_min) / _range * 100));
            _rp = max(0, min(100, (_thisv - scale_min) / _range * 100));
            _wp = max(0, _rp - _lp);
            tmp = '{color:"' || strip(bnd_lbl[_i]) || '",leftPct:' || strip(put(_lp,8.2))
                  || ',widthPct:' || strip(put(_wp,8.2)) || '}';
            if _i > 1 then bands_js = strip(bands_js) || ',';
            bands_js = strip(bands_js) || strip(tmp);
            _prev = _thisv;
        end;
        bands_js = strip(bands_js) || ']';

        /* ---- stable, unique-within-category id + category_key slugs ---- */
        category_key = lowcase(strip(riskarea_cf));
        category_key = prxchange('s/[^a-z0-9]+/-/', -1, category_key);
        category_key = prxchange('s/(^-+)|(-+$)//', -1, category_key);
        if missing(category_key) then category_key = 'other';

        id_base = lowcase(strip(indicator));
        id_base = prxchange('s/[^a-z0-9]+/-/', -1, id_base);
        id_base = prxchange('s/(^-+)|(-+$)//', -1, id_base);
        if missing(id_base) then id_base = cats('metric-', put(sno, best.-L));
        slug_key = catx('|', category_key, id_base);
        if _idh.find() ne 0 then _cnt = 0;
        _cnt + 1;
        if _cnt > 1 then id = catx('-', id_base, put(_cnt, best.-L));
        else id = id_base;
        _idh.replace();

        /* ---- escape every free-text field before it lands inside a JS
           double-quoted string ---- */
        %raf_jsesc(indicator)
        %raf_jsesc(definition)
        %raf_jsesc(ownership)
        %raf_jsesc(committee)
        %raf_jsesc(comments)
        %raf_jsesc(frequency)
        %raf_jsesc(criticality)
        riskarea_disp = strip(riskarea_cf);
        %raf_jsesc(riskarea_disp)

        /* ---- assemble the finished metric object text ---- */
        thresh_green_js = ifc(green_valid, strip(put(green_val,best12.)), 'null');
        thresh_amber_js = ifc(amber_valid, strip(put(amber_val,best12.)), 'null');
        thresh_red_js   = ifc(red_valid,   strip(put(red_val,best12.)),   'null');
        thresh_reg_js   = ifc(reg_valid,   strip(put(reg_val,best12.)),   'null');
        util_js         = ifc(util_valid,  strip(put(util_num,best12.)),  'null');

        /* Full sign-aware label per tier (">=7%" or, for a range,
           ">=3.5%,<7%") - appetiteResultsView.sas shows this on the meter
           scale instead of reconstructing one from thresholds/thresholdOps
           alone, which can't represent a range's second bound. */
        %raf_tier_label(green_label, green_valid, green_op, green_val, green_op2, green_val2)
        %raf_tier_label(amber_label, amber_valid, amber_op, amber_val, amber_op2, amber_val2)
        %raf_tier_label(red_label,   red_valid,   red_op,   red_val,   red_op2,   red_val2)
        %raf_tier_label(reg_label,   reg_valid,   reg_op,   reg_val,   reg_op2,   reg_val2)

        js_line = '{ sNo: ' || strip(put(sno,best.-L)) || ', id: "' || strip(id)
          || '", indicator: "' || strip(indicator) || '",' ;
        js_line = strip(js_line) || ' definition: "' || strip(definition) || '",';
        js_line = strip(js_line) || ' thresholds: { green: ' || strip(thresh_green_js)
          || ', amber: ' || strip(thresh_amber_js) || ', red: ' || strip(thresh_red_js)
          || ', regulatory: ' || strip(thresh_reg_js) || ' },';
        js_line = strip(js_line) || ' thresholdOps: { green: "' || strip(green_op) || '", amber: "'
          || strip(amber_op) || '", red: "' || strip(red_op) || '", regulatory: "' || strip(reg_op) || '" },';
        js_line = strip(js_line) || ' thresholdLabels: { green: "' || strip(green_label) || '", amber: "'
          || strip(amber_label) || '", red: "' || strip(red_label) || '", regulatory: "' || strip(reg_label) || '" },';
        js_line = strip(js_line) || ' frequency: "' || strip(frequency) || '", criticality: "'
          || strip(criticality) || '", owner: "' || strip(ownership) || '", committee: "'
          || strip(committee) || '", comment: "' || strip(comments) || '",';
        js_line = strip(js_line) || ' currentValue: ' || strip(util_js) || ',';
        js_line = strip(js_line) || ' status: "' || strip(status) || '",';
        js_line = strip(js_line) || ' meter: { scaleMin: ' || strip(put(scale_min,best12.))
          || ', scaleMax: ' || strip(put(scale_max,best12.))
          || ', markerLeftPct: ' || ifc(util_valid, strip(put(marker_left_pct,8.2)), 'null')
          || ', regulatoryLeftPct: ' || ifc(reg_valid, strip(put(reg_left_pct,8.2)), 'null')
          || ', bands: ' || strip(bands_js) || ' } }';
        js_line = strip(js_line);
        js_len = length(js_line);

        /* criticality/status/comments/util_num/util_valid are kept (not just
           baked into js_line) so rafDashboardAggregates.sas can group/filter
           on them directly without re-parsing js_line's text. */
        keep category_key riskarea_disp sno id indicator js_line js_len
             ownership committee frequency criticality status comments
             util_num util_valid;
        format sno best.;
    run;

    proc sort data=work.raf_metrics_final;
        by category_key sno;
    run;

%mend raf_carry_forward_classify;


/* ----------------------------------------------------------------------
   STEP 3: structural domain/category metadata (navigation only - not
   sheet data, same role riskDomainsConfig.sas already documents this
   grouping as playing). Any Risk Area not recognized below still gets a
   working tile via the "Other Risks" catch-all instead of being dropped,
   so the drill-down never breaks on a brand-new/renamed Risk Area.
   ---------------------------------------------------------------------- */
%macro raf_build_category_domain;

    /* one row per Risk Area this app currently knows how to place -
       matched case-insensitively against the sheet's own text, reusing
       the same 15 hand-authored inline SVG icons the app already had (one
       per category - presentation-only, not sheet data). Includes both
       spellings of IRRBB seen in the current workbook (row 13's correct
       spelling and the "Interetst" typo on row 38) so today's file lands
       in the Financial domain and gets the right icon either way - see
       the note in the final summary about fixing that typo in the sheet.
       Built via plain assignment (not DATALINES) so each SVG's own
       double-quotes need no delimiter-escaping. */
    %macro raf_area(key, dom, svg);
        area_key = "&key."; domain_key = "&dom."; icon = "&svg.";
        %raf_jsesc(icon)
        output;
    %mend raf_area;

    data work.raf_area_lookup;
        length area_key $150 domain_key $20 icon $700;
        %raf_area(CAPITAL, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='8' width='18' height='12' rx='2'/><path d='M7 8 V6 a5 5 0 0 1 10 0 v2'/><circle cx='12' cy='14' r='1.5'/></svg>))
        %raf_area(CONCENTRATION RISK, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='9'/><circle cx='12' cy='12' r='4'/></svg>))
        %raf_area(CREDIT RISK, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M4 19 L9 11 L13 15 L20 5'/><path d='M15 5 L20 5 L20 10'/></svg>))
        %raf_area(LIQUIDITY RISK, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M12 3 C12 3 5.5 11 5.5 15.5 C5.5 19.2 8.4 21.7 12 21.7 C15.6 21.7 18.5 19.2 18.5 15.5 C18.5 11 12 3 12 3 Z'/></svg>))
        %raf_area(MARKET RISK, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M3 17 L9 11 L13 14 L21 6'/><path d='M3 21 L21 21'/></svg>))
        %raf_area(INTEREST RATE IN THE BANKING BOOK (IRRBB), financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M4 12 h4 l2 -7 l4 14 l2 -7 h4'/></svg>))
        %raf_area(INTERETST RATE IN THE BANKING BOOK (IRRBB), financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M4 12 h4 l2 -7 l4 14 l2 -7 h4'/></svg>))
        %raf_area(IRRBB, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M4 12 h4 l2 -7 l4 14 l2 -7 h4'/></svg>))
        %raf_area(EARNINGS AND FINANCIAL PERFORMANCE, financial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><line x1='2' y1='21' x2='22' y2='21'/><rect x='4' y='14' width='3.4' height='7' rx='0.6'/><rect x='10.3' y='9' width='3.4' height='12' rx='0.6'/><rect x='16.6' y='4' width='3.4' height='17' rx='0.6'/></svg>))
        %raf_area(OPERATIONAL RISK, nonfinancial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M4 12 A8 8 0 0 1 18 6.5'/><path d='M20 12 A8 8 0 0 1 6 17.5'/><path d='M18 3.5 V7 H14.5'/><path d='M6 20.5 V17 H9.5'/></svg>))
        %raf_area(FRAUD RISK, nonfinancial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><rect x='4' y='3' width='12' height='16' rx='1.5'/><line x1='7' y1='7' x2='13' y2='7'/><line x1='7' y1='10.5' x2='13' y2='10.5'/><circle cx='16.5' cy='16.5' r='3.2'/><line x1='18.8' y1='18.8' x2='21' y2='21'/></svg>))
        %raf_area(CYBER SECURITY RISK, nonfinancial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M12 2.5 L20 5.5 L20 11 C20 16.5 16.5 20.5 12 22 C7.5 20.5 4 16.5 4 11 L4 5.5 Z'/><circle cx='12' cy='11.5' r='2'/><line x1='12' y1='13.5' x2='12' y2='16'/></svg>))
        %raf_area(LEGAL RISK, nonfinancial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><rect x='5' y='2.5' width='14' height='19' rx='1.5'/><line x1='8' y1='7' x2='16' y2='7'/><line x1='8' y1='10.5' x2='16' y2='10.5'/><line x1='8' y1='14' x2='13' y2='14'/><path d='M8.5 18 L10.5 20 L15.5 15'/></svg>))
        %raf_area(MODEL RISK, nonfinancial, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><circle cx='6' cy='7' r='2'/><circle cx='18' cy='7' r='2'/><circle cx='12' cy='17' r='2'/><line x1='7.7' y1='8.3' x2='10.5' y2='15.3'/><line x1='16.3' y1='8.3' x2='13.5' y2='15.3'/><line x1='8' y1='7' x2='16' y2='7'/></svg>))
        %raf_area(PEOPLE AND CONDUCT RISK, peopleconduct, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><circle cx='9' cy='9' r='3.2'/><circle cx='17' cy='10' r='2.6'/><path d='M3 20.5 C3 16.5 6 14 9.5 14 C12 14 14 15.3 15 17.3'/><path d='M14.5 14.5 C16.7 14.5 19 15.9 19.8 18.3'/></svg>))
        %raf_area(REPUTATIONAL RISK, peopleconduct, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='9.5' r='5.5'/><path d='M7.2 14.3 L5.5 21.5 L12 18 L18.5 21.5 L16.8 14.3'/></svg>))
        %raf_area(SHARIAH RISK, shariah, %nrbquote(<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='22' height='22' fill='none' stroke='currentColor' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'><path d='M14.5 3 A9 9 0 1 0 14.5 21 A7.2 7.2 0 1 1 14.5 3 Z'/></svg>))
    run;

    /* Domain-level metadata, including the same 4 hand-authored inline SVG
       icons the app already used (unchanged - presentation-only navigation
       chrome, not sheet data). Built via plain assignment (not DATALINES)
       so the SVG markup's own double-quotes need no delimiter-escaping;
       %raf_jsesc below then makes each icon safe to embed in the JS output
       the same way every other text field is. */
    data work.raf_domain_meta;
        length domain_key $20 domain_title $60 domain_desc $300 route $40 icon $700;

        domain_key='financial'; domain_title='Financial Risks';
        domain_desc='Capital adequacy, concentration, credit, liquidity, market and earnings - the core balance-sheet risk domains.';
        icon='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M2.3 10 L12 4 L21.7 10 Z"/><line x1="3" y1="21" x2="21" y2="21"/><line x1="4.5" y1="21" x2="4.5" y2="10.5"/><line x1="9.5" y1="21" x2="9.5" y2="10.5"/><line x1="14.5" y1="21" x2="14.5" y2="10.5"/><line x1="19.5" y1="21" x2="19.5" y2="10.5"/></svg>';
        route = '#domain/' || strip(domain_key); %raf_jsesc(icon) output;

        domain_key='nonfinancial'; domain_title='Non-Financial Risks';
        domain_desc='Operational, fraud, cyber, legal and model risk - how well bank processes and controls hold up.';
        icon='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4.3"/><line x1="12" y1="2.5" x2="12" y2="5.3"/><line x1="12" y1="18.7" x2="12" y2="21.5"/><line x1="2.5" y1="12" x2="5.3" y2="12"/><line x1="18.7" y1="12" x2="21.5" y2="12"/><line x1="5.4" y1="5.4" x2="7.4" y2="7.4"/><line x1="16.6" y1="16.6" x2="18.6" y2="18.6"/><line x1="5.4" y1="18.6" x2="7.4" y2="16.6"/><line x1="16.6" y1="7.4" x2="18.6" y2="5.4"/></svg>';
        route = '#domain/' || strip(domain_key); %raf_jsesc(icon) output;

        domain_key='peopleconduct'; domain_title='People, Conduct & Reputational Risk';
        domain_desc='Workforce, conduct and reputational indicators - how the bank is run and how it is perceived.';
        icon='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><circle cx="10" cy="8" r="4"/><path d="M2.5 20.5 C2.5 16.4 6.1 13.5 10.5 13.5 C14.9 13.5 18.5 16.4 18.5 20.5"/><path d="M18 2.5 L18.9 4.3 L20.9 4.6 L19.4 6 L19.8 8 L18 7 L16.2 8 L16.6 6 L15.1 4.6 L17.1 4.3 Z"/></svg>';
        route = '#domain/' || strip(domain_key); %raf_jsesc(icon) output;

        domain_key='shariah'; domain_title='Shariah & Compliance Risk';
        domain_desc='Sharia non-compliance exposure across Islamic banking activities.';
        icon='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 3 A9 9 0 1 0 14.5 21 A7.2 7.2 0 1 1 14.5 3 Z"/></svg>';
        route = '#domain/' || strip(domain_key); %raf_jsesc(icon) output;

        domain_key='other'; domain_title='Other Risks';
        domain_desc='Risk areas found in the sheet that are not yet mapped to one of the domains above - flag with the business owner to place them properly.';
        icon='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/></svg>';
        route = '#domain/' || strip(domain_key); %raf_jsesc(icon) output;
    run;

    /* Category-level roll-up: sort by category_key first so every row of
       the same category lands in one BY-group even when its S.No blocks
       are not contiguous in the sheet (e.g. "Capital" appears twice, at
       S.No 1-3 and again at 24-25). indicatorCount and the distinct,
       pipe-then-comma-joined owner/committee/frequency lists (mirrors how
       the old hand-typed config already combined e.g. "RMC, SCC" for
       categories whose rows carry more than one committee) all come
       straight from the real rows instead of being hand-typed. Pipe is
       used as the internal join delimiter (not comma) so multi-word
       values like "Finance and Planning" are never mistaken for several
       words by FINDW. */
    proc sort data=work.raf_metrics_final out=work._raf_metrics_sorted;
        by category_key;
    run;

    data work.raf_category_meta;
        length category_key $80 title $150
               owner_list committee_list frequency_list $600
               owner committee_disp frequency_disp $600
               indicatorCount 8;
        retain category_key title owner_list committee_list frequency_list indicatorCount;
        set work._raf_metrics_sorted(keep=category_key riskarea_disp ownership committee frequency);
        by category_key;
        if first.category_key then do;
            title = riskarea_disp;
            owner_list = ''; committee_list = ''; frequency_list = ''; indicatorCount = 0;
        end;
        indicatorCount + 1;
        if not missing(ownership) and not findw(owner_list, strip(ownership), '|', 'e') then
            owner_list = catx('|', owner_list, strip(ownership));
        if not missing(committee) and not findw(committee_list, strip(committee), '|', 'e') then
            committee_list = catx('|', committee_list, strip(committee));
        if not missing(frequency) and not findw(frequency_list, strip(frequency), '|', 'e') then
            frequency_list = catx('|', frequency_list, strip(frequency));
        if last.category_key then do;
            owner = ifc(missing(owner_list), 'ERM', tranwrd(owner_list, '|', ', '));
            committee_disp = ifc(missing(committee_list), 'RMC', tranwrd(committee_list, '|', ', '));
            frequency_disp = ifc(missing(frequency_list), 'Quarterly', tranwrd(frequency_list, '|', ', '));
            output;
        end;
        keep category_key title owner committee_disp frequency_disp indicatorCount;
    run;

    /* joined against the lookup (falling back to "other" / a generic icon
       and description when a Risk Area isn't recognized). */
    proc sql;
        create table work._raf_categories_joined as
        select
            m.category_key as key length=80,
            m.title length=150,
            coalesce(l.domain_key, 'other') as domain_key length=20,
            coalesce(l.icon,
                '<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"22\" height=\"22\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><circle cx=\"12\" cy=\"12\" r=\"9\"/></svg>'
            ) as icon length=700,
            m.indicatorCount,
            m.owner length=600,
            m.committee_disp as committee length=600,
            m.frequency_disp as frequency length=600,
            '#category/' || strip(m.category_key) as route length=40,
            cats('Risk indicators from the ', m.title, ' risk area.') as description length=350
        from work.raf_category_meta m
        left join work.raf_area_lookup l
            on upcase(m.title) = l.area_key;
    quit;

    /* pre-build the finished one-line JS object text per category, exactly
       the same "assemble once here, emitting macro just PUTs it" approach
       used for metrics, so riskCategoriesConfig.sas stays a plain loop
       with no character-padding surprises from PUTting a fixed-length
       column directly. */
    data work.raf_categories_final;
        length js_line $5000;
        set work._raf_categories_joined;
        js_line = '{ key: "' || strip(key) || '", title: "' || strip(title)
          || '", domain: "' || strip(domain_key) || '",';
        js_line = strip(js_line) || ' description: "' || strip(description) || '",';
        js_line = strip(js_line) || ' icon: "' || strip(icon) || '",';
        js_line = strip(js_line) || ' route: "' || strip(route) || '", indicatorCount: '
          || strip(put(indicatorCount, best.-L)) || ',';
        js_line = strip(js_line) || ' owner: "' || strip(owner) || '", committee: "' || strip(committee)
          || '", frequency: "' || strip(frequency) || '" }';
        js_line = strip(js_line);
        js_len = length(js_line);
    run;

    /* domains actually in play this run + their comma-joined category-key
       lists. */
    proc sort data=work.raf_categories_final out=work._raf_cats_sorted;
        by domain_key key;
    run;

    data work._raf_domains_agg;
        length domain_key $20 categories_js $2000;
        retain domain_key categories_js;
        set work._raf_cats_sorted(keep=domain_key key) end=eof;
        by domain_key;
        if first.domain_key then categories_js = '';
        categories_js = catx(',', categories_js, cats('"', key, '"'));
        if last.domain_key then output;
    run;

    proc sort data=work._raf_domains_agg; by domain_key; run;
    proc sort data=work.raf_domain_meta out=work._raf_domain_meta_sorted; by domain_key; run;

    data work.raf_domains_final;
        length js_line $5000;
        merge work._raf_domains_agg(in=inagg) work._raf_domain_meta_sorted(in=inmeta);
        by domain_key;
        if inagg and inmeta;
        js_line = '{ key: "' || strip(domain_key) || '", title: "' || strip(domain_title)
          || '", description: "' || strip(domain_desc) || '",';
        js_line = strip(js_line) || ' icon: "' || strip(icon) || '",';
        js_line = strip(js_line) || ' route: "' || strip(route) || '",';
        js_line = strip(js_line) || ' categories: [' || strip(categories_js) || ']';
        js_line = strip(js_line) || ' }';
        js_line = strip(js_line);
        js_len = length(js_line);
    run;

    proc sort data=work.raf_domains_final;
        by domain_key;
    run;

%mend raf_build_category_domain;


/* ----------------------------------------------------------------------
   Entry point
   ---------------------------------------------------------------------- */
%macro raf_load_excel_data;
    %raf_import_raw;
    %raf_carry_forward_classify;
    %raf_build_category_domain;
    %raf_build_dashboard_aggregates;

    %global RAF_METRIC_NOBS RAF_CATEGORY_NOBS RAF_DOMAIN_NOBS;
    proc sql noprint;
        select count(*) into :RAF_METRIC_NOBS trimmed from work.raf_metrics_final;
        select count(*) into :RAF_CATEGORY_NOBS trimmed from work.raf_categories_final;
        select count(*) into :RAF_DOMAIN_NOBS trimmed from work.raf_domains_final;
    quit;
%mend raf_load_excel_data;
