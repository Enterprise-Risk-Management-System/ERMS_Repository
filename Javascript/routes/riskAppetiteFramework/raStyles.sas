/* ============================================================================
   RAF SCOPED STYLES + ICON SPRITE (ERMS-embedded)
   Every single selector below is written as ".raf-app ..." so these rules
   can never affect ERMS's own navbar/buttons/modal, and ERMS's own global
   CSS can never restyle RAF's content either - see the integration rules in
   buildRAF.sas's file header. Written as one JS template literal (backtick
   string) so the CSS can be emitted as plain lines with no per-line quote-
   escaping - a backtick has no special meaning to SAS, unlike a single or
   double quote.

   PALETTE: every token below is taken directly from ERMS's own design
   language (Styles/css.sas's navbar gradient, module color chips and
   status-badge colors; the Tailwind gray scale ERMS already uses for text/
   borders/surfaces) rather than a separate RAF palette, so the CRO Dashboard
   reads as part of ERMS instead of a visually distinct tool bolted on. The
   .raf-app wrapper itself no longer paints its own background/border/shadow
   either - it renders flush inside ERMS's existing #main-panel card, the
   same way every other route (Dashboard, Risk Categories, Analytics, ...)
   already does.

   Injected inline as part of getRAFHTML()'s returned HTML (re-injected,
   harmlessly, on every visit to the route - the old copy is discarded along
   with the rest of #main-panel's previous content on each navigation) -
   nothing is added to ERMS's own <head> or Styles/css.sas.
   ============================================================================ */
%macro generate_raf_styles;
    put 'const RAF_STYLE_BLOCK = `<style>';
    put '.raf-app {';
    put '  --page:        #f8fafc;';
    put '  --surface-1:   #ffffff;';
    put '  --surface-2:   #f9fafb;';
    put '  --border:      #e5e7eb;';
    put '  --text-1:      #1f2937;';
    put '  --text-2:      #6b7280;';
    put '  --text-3:      #9ca3af;';
    put '  --brand:       #1e3a8a;';
    put '  --brand-2:     #3b82f6;';
    put '  --brand-tint:  #eff6ff;';
    put '  --steel:       #0891b2;';
    put '  --steel-tint:  #ecfeff;';
    put '  --navy:        #1e3a8a;';
    put '  --sky:         #93c5fd;';
    put '  --series-2:    #7c3aed;';
    put '  --good:          #166534;';
    put '  --good-tint:     #dcfce7;';
    put '  --warning:       #92400e;';
    put '  --warning-tint:  #fef3c7;';
    put '  --serious:       #c2410c;';
    put '  --serious-tint:  #ffedd5;';
    put '  --critical:      #991b1b;';
    put '  --critical-tint: #fee2e2;';
    put '  display: block; color: var(--text-1);';
    put '  font-family: "Inter", "Arial", sans-serif;';
    put '}';
    put '.raf-app * { box-sizing: border-box; }';
    put '.raf-app a { text-decoration: none; color: inherit; }';

    put '.raf-app .raf-topbar { background: linear-gradient(135deg, var(--navy) 0%, var(--brand-2) 100%);';
    put '  padding: 14px 22px; display: flex; align-items: center; justify-content: space-between;';
    put '  border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,.05); margin-bottom: 20px; }';
    put '.raf-app .raf-topbar-brand { display: flex; align-items: center; gap: 10px; color: #fff; font-weight: 800; font-size: 1.05rem; letter-spacing: -.01em; }';
    put '.raf-app .raf-cro-badge { background: rgba(255,255,255,.18); color: #fff; font-size: .68rem; font-weight: 700;';
    put '  letter-spacing: .06em; text-transform: uppercase; padding: 4px 11px; border-radius: 20px; border: 1px solid rgba(255,255,255,.35); }';
    /* No horizontal/bottom padding - RAF content sits flush inside ERMS's own
       #main-panel (which already provides 30px padding), same as every other
       route's content, instead of ERMS's card wrapping a second inset card. */
    put '.raf-app .raf-body { padding: 0; }';

    put '.raf-app .crumb { font-size: .8rem; color: var(--text-3); margin-bottom: 10px; }';
    put '.raf-app .crumb b { color: var(--navy); font-weight: 700; cursor: pointer; }';
    put '.raf-app .crumb b:hover { color: var(--brand-2); text-decoration: underline; }';
    put '.raf-app .crumb-current { color: var(--text-1); font-weight: 700; }';
    put '.raf-app h2.raf-pagetitle { font-size: 1.6rem; font-weight: 800; margin-bottom: 4px; letter-spacing: -.01em; }';
    put '.raf-app p.raf-pagesub { color: var(--text-2); font-size: .88rem; margin-bottom: 20px; }';

    put '.raf-app .btn { background: var(--brand-2); color: #fff; border: none; padding: 9px 18px;';
    put '  border-radius: 8px; font-size: .82rem; font-weight: 700; cursor: pointer; font-family: inherit;';
    put '  display: inline-flex; align-items: center; gap: 8px; transition: background .2s; }';
    put '.raf-app .btn:hover { background: var(--brand); }';
    put '.raf-app .btn.ghost { background: transparent; color: var(--brand-2); border: 1.5px solid var(--brand-2); margin-left: 8px; }';
    put '.raf-app .btn.ghost:hover { background: var(--brand-tint); }';

    put '.raf-app select { font-family: inherit; font-size: .82rem; font-weight: 700; color: var(--text-1);';
    put '  background: var(--surface-2); border: 1px solid var(--border); border-radius: 7px; padding: 7px 10px; cursor: pointer; }';

    put '.raf-app .filter-panel { background: var(--surface-1); border: 1px solid var(--border); border-radius: 14px;';
    put '  padding: 16px 20px; margin-bottom: 18px; display: grid; grid-template-columns: 1.1fr 1.4fr; gap: 16px; align-items: start; }';
    put '.raf-app .filter-fields { display: flex; gap: 18px; flex-wrap: wrap; }';
    put '.raf-app .filter-field label { display: block; font-size: .66rem; font-weight: 700; letter-spacing: .05em;';
    put '  text-transform: uppercase; color: var(--text-3); margin-bottom: 5px; }';
    put '.raf-app .filter-note { grid-column: 1 / -1; font-size: .78rem; color: var(--text-2); background: var(--surface-2);';
    put '  border: 1px solid var(--border); border-radius: 8px; padding: 8px 12px; }';
    put '.raf-app .filter-note b { color: var(--text-1); }';
    put '.raf-app .note-box { border-left: 3px solid var(--brand-2); background: var(--brand-tint); border-radius: 0 8px 8px 0; padding: 10px 14px; }';
    put '.raf-app .note-box-title { font-size: .72rem; font-weight: 800; color: var(--brand); margin-bottom: 6px; text-transform: uppercase; letter-spacing: .04em; }';
    put '.raf-app .note-line { font-size: .76rem; color: var(--text-2); margin-bottom: 4px; line-height: 1.4; }';
    put '.raf-app .note-line:last-child { margin-bottom: 0; }';
    put '.raf-app .note-line b { color: var(--text-1); }';

    /* Tab bar - replaces the 4 stacked zone panels. Same underline-on-active
       idiom as ERMS's own .nav-menu a::after hover underline (css.sas), so
       switching sections here looks like the same interaction pattern as the
       rest of the app, not a new one. Only the active tab's panel is shown,
       so each zone gets the full main-panel width to itself instead of the
       4 zones competing for vertical scroll space. */
    put '.raf-app .raf-tabs { display: flex; gap: 4px; flex-wrap: wrap; border-bottom: 2px solid var(--border); margin-bottom: 18px; }';
    put '.raf-app .raf-tab { background: none; border: none; font-family: inherit; font-size: .84rem; font-weight: 700;';
    put '  color: var(--text-2); padding: 12px 18px; cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: color .2s, border-color .2s; }';
    put '.raf-app .raf-tab:hover { color: var(--brand-2); }';
    put '.raf-app .raf-tab.active { color: var(--brand); border-bottom-color: var(--brand-2); }';
    put '.raf-app .raf-tabpanel { display: none; }';
    put '.raf-app .raf-tabpanel.active { display: block; }';

    put '.raf-app .zone-panel { background: var(--surface-1); border: 1px solid var(--border); border-radius: 12px;';
    put '  margin-bottom: 18px; box-shadow: 0 2px 10px rgba(0,0,0,.05); overflow: hidden; }';
    put '.raf-app .zone-toolbar { background: var(--surface-2); border-bottom: 1px solid var(--border); padding: 10px 18px;';
    put '  display: flex; justify-content: flex-end; align-items: center; gap: 10px; }';
    put '.raf-app .zone-body { padding: 16px 18px 18px; }';
    put '.raf-app .zone-desc { font-size: .8rem; color: var(--text-2); margin-bottom: 14px; }';
    put '.raf-app .zone-select { display: flex; align-items: center; gap: 8px; }';
    put '.raf-app .zone-select label { font-size: .72rem; color: var(--text-2); font-weight: 700; }';

    put '.raf-app .ind-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; }';
    put '.raf-app .ind-card { background: var(--surface-1); border: 2px solid var(--border); border-radius: 12px;';
    put '  padding: 13px; cursor: pointer; transition: border-color .2s; }';
    put '.raf-app .ind-card:hover { border-color: var(--brand-2); }';
    put '.raf-app .ind-label { display: block; font-size: .62rem; font-weight: 700; letter-spacing: .04em; text-transform: uppercase; color: var(--text-3); }';
    put '.raf-app .ind-value { display: block; font-size: .8rem; font-weight: 700; color: var(--text-1); margin: 1px 0 7px; line-height: 1.3; }';
    put '.raf-app .ind-table { width: 100%; border-collapse: collapse; font-size: .76rem; }';
    put '.raf-app .ind-table th { text-align: left; font-size: .6rem; font-weight: 700; text-transform: uppercase;';
    put '  color: var(--text-3); padding-bottom: 5px; border-bottom: 1.5px solid var(--border); }';
    put '.raf-app .ind-table th:last-child, .raf-app .ind-table td:last-child { text-align: right; }';
    put '.raf-app .ind-table td { padding: 6px 0; border-bottom: 1px solid var(--border); color: var(--text-2); }';
    put '.raf-app .ind-table tr:last-child td { border-bottom: none; }';
    put '.raf-app .rag-pill { display: inline-block; padding: 2px 9px; border-radius: 5px; font-weight: 800; color: var(--text-1); }';
    put '.raf-app .rag-pill.good { background: var(--good-tint); }';
    put '.raf-app .rag-pill.warning { background: var(--warning-tint); }';
    put '.raf-app .rag-pill.critical { background: var(--critical-tint); }';

    put '.raf-app .heatmap-table { width: 100%; border-collapse: collapse; font-size: .8rem; }';
    put '.raf-app .heatmap-table th { background: var(--surface-2); text-transform: uppercase; font-size: .62rem;';
    put '  color: var(--text-3); font-weight: 800; padding: 8px 10px; text-align: left; border-bottom: 2px solid var(--border); }';
    put '.raf-app .heatmap-table th.num, .raf-app .heatmap-table td.num { text-align: center; }';
    put '.raf-app .heatmap-table td { padding: 7px 10px; border-bottom: 1px solid var(--border); }';
    put '.raf-app .heatmap-table td.crit-cell { font-weight: 800; color: var(--brand); background: var(--brand-tint); vertical-align: middle; }';
    put '.raf-app .heatmap-table td.num { font-weight: 800; }';
    put '.raf-app .heatmap-table td.num.good { background: var(--good-tint); color: var(--text-1); }';
    put '.raf-app .heatmap-table td.num.warning { background: var(--warning-tint); color: var(--text-1); }';
    put '.raf-app .heatmap-table td.num.critical { background: var(--critical-tint); color: var(--text-1); }';
    put '.raf-app .trend-icon { width: 16px; height: 16px; }';
    put '.raf-app .trend-icon.up { color: var(--good); }';
    put '.raf-app .trend-icon.down { color: var(--critical); }';

    put '.raf-app .table-toolbar { display: flex; gap: 8px; align-items: center; margin-bottom: 10px; flex-wrap: wrap; }';
    put '.raf-app .table-filter-input { flex: 1; min-width: 220px; font-family: inherit; font-size: .8rem; padding: 7px 10px;';
    put '  border: 1px solid var(--border); border-radius: 7px; background: var(--surface-2); color: var(--text-1); }';
    put '.raf-app .table-filter-count { font-size: .74rem; color: var(--text-3); }';

    /* auto-fit rather than a fixed 2 columns - now that this tab has the full
       main-panel width to itself, all 4 periods can sit in one row on wide
       screens instead of always wrapping to a 2x2 grid. */
    put '.raf-app .treemap-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px 14px; }';
    put '.raf-app .treemap-date { display: inline-block; background: var(--brand); color: #fff; font-size: .66rem; font-weight: 700;';
    put '  padding: 3px 9px; border-radius: 6px 6px 0 0; }';
    put '.raf-app .treemap-rect { display: flex; gap: 2px; height: 120px; background: var(--surface-2); border-radius: 0 8px 8px 8px; overflow: hidden; }';
    put '.raf-app .tm-green, .raf-app .tm-amber, .raf-app .tm-red { display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 800; }';
    put '.raf-app .tm-green { background: var(--good); }';
    put '.raf-app .tm-amber { background: var(--warning); }';
    put '.raf-app .tm-red { background: var(--critical); }';
    put '.raf-app .tm-right { display: flex; flex-direction: column; gap: 2px; flex: 1; }';

    put '.raf-app .trend-legend { display: flex; gap: 16px; margin-bottom: 8px; font-size: .76rem; color: var(--text-2); font-weight: 600; }';
    put '.raf-app .trend-legend span { display: flex; align-items: center; gap: 6px; }';
    put '.raf-app .trend-legend i { width: 9px; height: 9px; border-radius: 50%; display: inline-block; }';
    /* Fluid SVG - the chart keeps its logical 560x210 coordinate system via
       viewBox but stretches to fill the tab's full width instead of sitting
       at a fixed 560px inside a much wider panel. */
    put '.raf-app .trend-chart-wrap { overflow-x: auto; }';
    put '.raf-app .trend-chart-wrap svg { width: 100%; height: auto; display: block; }';

    put '.raf-app .domain-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px,1fr)); gap: 14px; }';
    put '.raf-app .domain-card { background: var(--surface-1); border: 2px solid var(--border); border-radius: 14px;';
    put '  padding: 18px; cursor: pointer; transition: border-color .2s, transform .2s; }';
    put '.raf-app .domain-card:hover { border-color: var(--brand-2); transform: translateY(-2px); }';
    put '.raf-app .domain-head { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }';
    put '.raf-app .domain-icon { width: 44px; height: 44px; border-radius: 11px; background: var(--brand-tint);';
    put '  color: var(--brand); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }';
    put '.raf-app .domain-title { font-size: 1rem; font-weight: 800; }';
    put '.raf-app .domain-meta { font-size: .7rem; color: var(--text-3); font-weight: 600; margin-top: 2px; }';
    put '.raf-app .domain-desc { font-size: .8rem; color: var(--text-2); line-height: 1.5; margin-bottom: 14px; min-height: 40px; }';
    put '.raf-app .domain-split { display: flex; gap: 2px; height: 7px; border-radius: 4px; overflow: hidden; margin-bottom: 8px; }';
    put '.raf-app .domain-split span { height: 100%; }';
    put '.raf-app .domain-split-caption { font-size: .68rem; color: var(--text-3); margin-bottom: 12px; }';
    put '.raf-app .domain-foot { display: flex; justify-content: flex-end; border-top: 1px solid var(--border); padding-top: 10px; }';
    put '.raf-app .domain-link { font-size: .76rem; font-weight: 700; color: var(--brand-2); }';

    put '.raf-app .tiles { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 320px)); gap: 14px; }';
    put '.raf-app .tile { background: var(--surface-1); border: 2px solid var(--border); border-radius: 12px;';
    put '  padding: 16px; cursor: pointer; transition: border-color .2s, transform .2s; }';
    put '.raf-app .tile:hover { border-color: var(--brand-2); transform: translateY(-2px); }';
    put '.raf-app .tile-head { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }';
    put '.raf-app .tile-icon { width: 38px; height: 38px; border-radius: 9px; background: var(--brand-tint);';
    put '  color: var(--brand); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }';
    put '.raf-app .tile-title { font-size: .92rem; font-weight: 700; }';
    put '.raf-app .tile-count { font-size: .68rem; color: var(--text-3); font-weight: 600; }';
    put '.raf-app .tile-desc { font-size: .78rem; color: var(--text-2); line-height: 1.45; margin-bottom: 12px; min-height: 36px; }';
    put '.raf-app .tile-split { display: flex; gap: 2px; height: 6px; border-radius: 4px; overflow: hidden; margin-bottom: 7px; }';
    put '.raf-app .tile-split span { height: 100%; }';
    put '.raf-app .tile-split-caption { font-size: .66rem; color: var(--text-3); margin-bottom: 10px; }';
    put '.raf-app .tile-foot { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border); padding-top: 9px; }';
    put '.raf-app .tile-owner { font-size: .66rem; font-weight: 700; letter-spacing: .03em; padding: 3px 8px; border-radius: 20px; background: var(--steel-tint); color: var(--steel); }';
    put '.raf-app .tile-freq { font-size: .7rem; color: var(--text-3); }';

    put '.raf-app .detail-panel { background: var(--surface-1); border: 1px solid var(--border); border-radius: 14px; padding: 20px 22px; }';
    put '.raf-app .detail-head { display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 10px; margin-bottom: 6px; }';
    put '.raf-app .detail-head h3 { font-size: 1.1rem; font-weight: 800; }';
    put '.raf-app .detail-meta { font-size: .76rem; color: var(--text-2); display: flex; gap: 16px; margin: 8px 0 6px; flex-wrap: wrap; }';
    put '.raf-app .detail-meta span b { color: var(--text-1); }';
    put '.raf-app .direction-note { display: inline-block; font-size: .72rem; font-weight: 600; color: var(--text-2);';
    put '  background: var(--surface-2); border: 1px solid var(--border); border-radius: 6px; padding: 6px 11px; margin: 10px 0 16px; }';

    put '.raf-app .metric-card { border: 1px solid var(--border); border-radius: 12px; padding: 14px 16px; margin-bottom: 10px; }';
    put '.raf-app .metric-card:last-child { margin-bottom: 0; }';
    put '.raf-app .metric-top { display: grid; grid-template-columns: 1.6fr 1fr auto; gap: 14px; align-items: start; margin-bottom: 10px; }';
    put '.raf-app .metric-name { font-size: .88rem; font-weight: 700; margin-bottom: 3px; }';
    put '.raf-app .metric-name small { font-weight: 400; color: var(--text-3); }';
    put '.raf-app .metric-def { font-size: .74rem; color: var(--text-2); line-height: 1.45; }';
    put '.raf-app .metric-tags { display: flex; gap: 6px; margin-top: 7px; flex-wrap: wrap; }';
    put '.raf-app .chip { font-size: .62rem; font-weight: 700; letter-spacing: .03em; padding: 2px 7px; border-radius: 5px; }';
    put '.raf-app .chip.level { background: var(--brand-tint); color: var(--brand); }';
    put '.raf-app .chip.comment { background: var(--steel-tint); color: var(--steel); }';
    put '.raf-app .metric-current .num { font-size: 1.2rem; font-weight: 800; letter-spacing: -.01em; }';
    put '.raf-app .metric-current .ph { display: block; font-size: .58rem; font-weight: 700; letter-spacing: .05em;';
    put '  text-transform: uppercase; color: var(--text-3); margin-top: 2px; }';

    put '.raf-app .status-chip { display: inline-flex; align-items: center; gap: 6px; padding: 5px 11px; border-radius: 20px; font-size: .72rem; font-weight: 700; white-space: nowrap; }';
    put '.raf-app .status-chip svg { width: 13px; height: 13px; flex-shrink: 0; }';
    put '.raf-app .status-chip.good { background: var(--good-tint); color: var(--text-1); }';
    put '.raf-app .status-chip.good svg { color: var(--good); }';
    put '.raf-app .status-chip.warning { background: var(--warning-tint); color: var(--text-1); }';
    put '.raf-app .status-chip.warning svg { color: var(--warning); }';
    put '.raf-app .status-chip.serious { background: var(--serious-tint); color: var(--text-1); }';
    put '.raf-app .status-chip.serious svg { color: var(--serious); }';
    put '.raf-app .status-chip.critical { background: var(--critical-tint); color: var(--text-1); }';
    put '.raf-app .status-chip.critical svg { color: var(--critical); }';

    put '.raf-app .meter { margin: 4px 0 2px; }';
    put '.raf-app .meter-track { position: relative; height: 13px; display: flex; gap: 2px; }';
    put '.raf-app .meter-track .band { height: 100%; border-radius: 3px; }';
    put '.raf-app .meter-track .band.good { background: var(--good-tint); }';
    put '.raf-app .meter-track .band.warning { background: var(--warning-tint); }';
    put '.raf-app .meter-track .band.serious { background: var(--serious-tint); }';
    put '.raf-app .meter-track .band.critical { background: var(--critical-tint); }';
    put '.raf-app .meter-marker { position: absolute; top: -12px; transform: translateX(-50%); display: flex; flex-direction: column; align-items: center; z-index: 2; }';
    put '.raf-app .meter-marker .mval { font-size: .64rem; font-weight: 800; background: var(--text-1); color: #fff;';
    put '  padding: 1px 6px; border-radius: 4px; white-space: nowrap; margin-bottom: 1px; }';
    put '.raf-app .meter-marker .mline { width: 2px; height: 24px; background: var(--text-1); opacity: .5; }';
    put '.raf-app .meter-marker .mdot { width: 10px; height: 10px; border-radius: 50%; border: 2px solid #fff; box-shadow: 0 0 0 1px var(--text-1); margin-top: -1px; }';
    put '.raf-app .meter-marker.good .mdot, .raf-app .meter-marker.good .mline, .raf-app .meter-marker.good .mval { background: var(--good); }';
    put '.raf-app .meter-marker.warning .mdot, .raf-app .meter-marker.warning .mline, .raf-app .meter-marker.warning .mval { background: var(--warning); }';
    put '.raf-app .meter-marker.serious .mdot, .raf-app .meter-marker.serious .mline, .raf-app .meter-marker.serious .mval { background: var(--serious); }';
    put '.raf-app .meter-marker.critical .mdot, .raf-app .meter-marker.critical .mline, .raf-app .meter-marker.critical .mval { background: var(--critical); }';
    put '.raf-app .reg-line { position: absolute; top: -4px; bottom: -4px; width: 0; border-left: 2px dashed var(--text-3); }';
    put '.raf-app .reg-line .reg-label { position: absolute; top: -15px; left: 4px; font-size: .58rem; font-weight: 700; color: var(--text-3); white-space: nowrap; }';
    put '.raf-app .meter-scale { display: flex; justify-content: space-between; font-size: .62rem; color: var(--text-3); margin-top: 20px; }';

    put '.raf-app .metric-bottom { display: flex; margin-top: 6px; }';
    put '.raf-app .trend-block { display: flex; align-items: center; gap: 8px; }';
    put '.raf-app .trend-block .trend-caption { font-size: .68rem; color: var(--text-3); font-style: italic; }';

    put '@media (max-width: 860px) {';
    put '  .raf-app .filter-panel { grid-template-columns: 1fr; }';
    put '  .raf-app .metric-top { grid-template-columns: 1fr; }';
    put '}';
    put '</style>`;';

    /* ---- Hand-authored inline SVG icon sprite - RAG status icons only
       (the 4 icons appetiteResultsView.sas references via <use href="#ic-...">).
       Re-injected per visit along with RAF_STYLE_BLOCK - harmless, see the
       note at the top of this file. ---- */
    put 'const RAF_ICON_DEFS = `<svg style="position:absolute;width:0;height:0;overflow:hidden" aria-hidden="true"><defs>';
    put '<symbol id="ic-good" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="2"/><path d="M8 12.5 L11 15.5 L16 9" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></symbol>';
    put '<symbol id="ic-warning" viewBox="0 0 24 24"><path d="M12 3.5 L21.5 20.5 L2.5 20.5 Z" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><line x1="12" y1="9.5" x2="12" y2="14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="12" cy="17.3" r="1.1" fill="currentColor"/></symbol>';
    put '<symbol id="ic-serious" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="4" fill="none" stroke="currentColor" stroke-width="2"/><line x1="12" y1="7.5" x2="12" y2="13.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="12" cy="16.5" r="1.1" fill="currentColor"/></symbol>';
    put '<symbol id="ic-critical" viewBox="0 0 24 24"><path d="M8 2.5 H16 L21.5 8 V16 L16 21.5 H8 L2.5 16 V8 Z" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><line x1="9" y1="9" x2="15" y2="15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><line x1="15" y1="9" x2="9" y2="15" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></symbol>';
    put '</defs></svg>`;';
%mend generate_raf_styles;
