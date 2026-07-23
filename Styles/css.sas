
/* ============================================================================
   CSS STYLES GENERATOR
   ============================================================================ */
%macro generate_css_styles;
    put '<style>';
    
    /* Base Styles */
    %generate_base_styles;
    
    /* Layout Components */
    %generate_navbar_styles;
    %generate_sidebar_styles;
    %generate_main_content_styles;
    
    /* UI Components */
    %generate_card_styles;
    %generate_button_styles;
    %generate_modal_styles;
    %generate_notification_styles;
    
    /* Risk Module Styles */
    %generate_risk_module_styles;
    
    /* Responsive Design */
    %generate_responsive_styles;
    
    /* Animations */
    %generate_animation_styles;
    
    /* Dashboard Table Styles */
    %generate_dashboard_table_styles;
    
    put '</style>';
%mend generate_css_styles;

/* ============================================================================
   BASE STYLES
   ============================================================================ */
%macro generate_base_styles;
    put '* { margin: 0; padding: 0; box-sizing: border-box; }';
    put 'body { font-family: "Inter", "Arial", sans-serif; background: #f8fafc; overflow-x: hidden; }';
    put 'a { text-decoration: none; color: inherit; }';
    put 'ul { list-style: none; }';
%mend generate_base_styles;

/* ============================================================================
   NAVBAR STYLES
   ============================================================================ */
%macro generate_navbar_styles;
    put '.navbar { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); padding: 0;';
    put '  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); position: fixed; top: 0; left: 0; right: 0; z-index: 1000; }';
    put '.nav-container { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }';
    put '.nav-brand { display: flex; align-items: center; gap: 15px; color: white; }';
    put '.nav-brand h1 { font-size: 1.5rem; font-weight: 600; }';
    put '.nav-brand .logo { background: rgba(255, 255, 255, 0.2); padding: 8px 12px; border-radius: 8px; }';
    put '.nav-menu { display: flex; gap: 30px; }';
    put '.nav-menu a { color: white; padding: 20px 0; display: block; font-weight: 500; transition: all 0.3s ease; position: relative; }';
    put '.nav-menu a:hover { color: #93c5fd; }';
    put '.nav-menu a::after { content: ""; position: absolute; bottom: 0; left: 0; width: 0; height: 3px; background: #93c5fd; transition: width 0.3s ease; }';
    put '.nav-menu a:hover::after { width: 100%; }';
    put '.nav-user { display: flex; align-items: center; gap: 15px; color: white; }';
    put '.user-avatar { width: 35px; height: 35px; border-radius: 50%; background: rgba(255, 255, 255, 0.2); display: flex; align-items: center; justify-content: center; }';
    put '.user-info { display: flex; flex-direction: column; }';
    put '.user-name { font-weight: 600; font-size: 0.9rem; }';
    put '.user-role { font-size: 0.8rem; opacity: 0.8; }';
%mend generate_navbar_styles;

/* ============================================================================
   SIDEBAR STYLES
   ============================================================================ */
%macro generate_sidebar_styles;
    put '.sidebar { position: fixed; left: 0; top: 70px; width: 250px; height: calc(100vh - 70px); background: white;';
    put '  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1); overflow-y: auto; z-index: 999; }';
    put '.sidebar-menu { padding: 20px 0; }';
    put '.sidebar-menu li { margin-bottom: 5px; }';
    put '.sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 12px 25px; color: #374151; transition: all 0.3s ease; border-left: 3px solid transparent; }';
    put '.sidebar-menu a:hover { background: #f3f4f6; color: #1f2937; border-left-color: #3b82f6; }';
    put '.sidebar-menu a.active { background: #eff6ff; color: #1d4ed8; border-left-color: #3b82f6; font-weight: 600; }';
    put '.sidebar-menu i { width: 20px; text-align: center; }';
%mend generate_sidebar_styles;

/* ============================================================================
   MAIN CONTENT STYLES
   ============================================================================ */
%macro generate_main_content_styles;
    put '.main-content { margin-left: 250px; margin-top: 70px; padding: 30px; }';
    put '.page-header { background: white; border-radius: 12px; padding: 30px; margin-bottom: 30px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); }';
    put '.page-title { font-size: 2rem; color: #1f2937; margin-bottom: 10px; font-weight: 600; }';
    put '.page-subtitle { color: #6b7280; font-size: 1.1rem; }';
    put '.breadcrumb { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; font-size: 0.9rem; color: #6b7280; }';
    put '.breadcrumb a { color: #3b82f6; }';
    put '.breadcrumb a:hover { text-decoration: underline; }';
    put '.dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; margin-bottom: 30px; }';
    put '.main-panel, .side-panel { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); }';
%mend generate_main_content_styles;

/* ============================================================================
   CARD STYLES
   ============================================================================ */
%macro generate_card_styles;
    put '.quick-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-bottom: 30px; }';
    put '.stat-card { background: white; border-radius: 10px; padding: 20px; text-align: center; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); border-left: 4px solid #3b82f6; }';
    put '.stat-card.positive { border-left-color: #10b981; }';
    put '.stat-card.warning { border-left-color: #f59e0b; }';
    put '.stat-card.danger { border-left-color: #ef4444; }';
    put '.stat-number { font-size: 2rem; font-weight: 700; color: #1f2937; margin-bottom: 5px; }';
    put '.stat-text { color: #6b7280; font-size: 0.9rem; }';
%mend generate_card_styles;

/* ============================================================================
   RISK MODULE STYLES
   ============================================================================ */
%macro generate_risk_module_styles;
    put '.risk-modules { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }';
    put '.risk-module { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);';
    put '  border: 2px solid transparent; transition: all 0.3s ease; cursor: pointer; position: relative; overflow: hidden; }';
    put '.risk-module:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); border-color: #3b82f6; }';
    put '.module-header { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }';
    put '.module-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }';
    put '.module-title { font-size: 1.2rem; font-weight: 600; color: #1f2937; }';
    put '.module-description { color: #6b7280; font-size: 0.9rem; line-height: 1.5; margin-bottom: 20px; }';
    put '.module-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }';
    put '.stat-item { text-align: center; padding: 15px; background: #f9fafb; border-radius: 8px; }';
    put '.stat-value { font-size: 1.3rem; font-weight: 700; color: #1f2937; margin-bottom: 5px; }';
    put '.stat-label { font-size: 0.8rem; color: #6b7280; text-transform: uppercase; letter-spacing: 0.5px; }';
    
    /* Module Color Themes */
    put '.regulatory { background: linear-gradient(135deg, #dc2626, #ef4444); }';
    put '.credit { background: linear-gradient(135deg, #059669, #10b981); }';
    put '.operational { background: linear-gradient(135deg, #0891b2, #06b6d4); }';
    put '.market { background: linear-gradient(135deg, #7c3aed, #8b5cf6); }';
    put '.liquidity { background: linear-gradient(135deg, #3b82f6, #60a5fa); }';
    put '.icaap { background: linear-gradient(135deg, #059669, #34d399); }';
    put '.ilaap { background: linear-gradient(135deg, #ec4899, #f472b6); }';
    put '.saibor { background: linear-gradient(135deg, #3b82f6, #60a5fa); }';
%mend generate_risk_module_styles;

/* ============================================================================
   MODAL STYLES
   ============================================================================ */
%macro generate_modal_styles;
    put '.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); z-index: 2000; justify-content: center; align-items: center; }';
    put '.modal.show { display: flex; }';
    put '.modal-content { background: white; border-radius: 20px; padding: 30px; max-width: 800px; width: 90%; max-height: 80vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); }';
    put '.modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #e5e7eb; }';
    put '.modal-title { font-size: 1.5rem; font-weight: 600; color: #1f2937; }';
    put '.modal-close { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #6b7280; transition: color 0.3s ease; }';
    put '.modal-close:hover { color: #1f2937; }';
%mend generate_modal_styles;

/* ============================================================================
   NOTIFICATION STYLES
   ============================================================================ */
%macro generate_notification_styles;
    put '.notification { position: fixed; top: 20px; right: 20px; color: white; padding: 15px 20px; border-radius: 10px;';
    put '  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); transform: translateX(400px); transition: transform 0.3s ease; z-index: 2001; display: flex; align-items: center; gap: 10px; }';
    put '.notification.success { background: linear-gradient(135deg, #059669, #10b981); }';
    put '.notification.error { background: linear-gradient(135deg, #dc2626, #ef4444); }';
    put '.notification.warning { background: linear-gradient(135deg, #d97706, #f59e0b); }';
    put '.notification.show { transform: translateX(0); }';
%mend generate_notification_styles;

/* ============================================================================
   BUTTON STYLES
   ============================================================================ */
%macro generate_button_styles;
    put '.btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 500; transition: all 0.3s ease; }';
    put '.btn-primary { background: #3b82f6; color: white; }';
    put '.btn-primary:hover { background: #2563eb; }';
    put '.btn-secondary { background: #6b7280; color: white; }';
    put '.btn-secondary:hover { background: #4b5563; }';
%mend generate_button_styles;

/* ============================================================================
   RESPONSIVE STYLES
   ============================================================================ */
%macro generate_responsive_styles;
    put '@media (max-width: 1024px) {';
    put '  .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; }';
    put '  .sidebar.show { transform: translateX(0); }';
    put '  .main-content { margin-left: 0; }';
    put '  .dashboard-grid { grid-template-columns: 1fr; }';
    put '}';
    put '@media (max-width: 768px) {';
    put '  .nav-menu { display: none; }';
    put '  .risk-modules { grid-template-columns: 1fr; }';
    put '  .quick-stats { grid-template-columns: repeat(2, 1fr); }';
    put '}';
%mend generate_responsive_styles;

/* ============================================================================
   ANIMATION STYLES
   ============================================================================ */
%macro generate_animation_styles;
    put '.loading { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); z-index: 2000; justify-content: center; align-items: center; }';
    put '.spinner { width: 50px; height: 50px; border: 4px solid rgba(255, 255, 255, 0.3); border-top: 4px solid #3b82f6; border-radius: 50%; animation: spin 1s linear infinite; }';
    put '@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }';
%mend generate_animation_styles;

/* ============================================================================
   NAVBAR COMPONENT
   ============================================================================ */
%macro generate_navbar;
    put '<nav class="navbar">';
    put '<div class="nav-container">';
    put '<a href="#" class="nav-brand">';
    put '<div class="logo"><i class="fas fa-shield-alt"></i></div>';
    put '<h1>ERMS</h1>';
    put '</a>';
    put '<ul class="nav-menu">';
    put '<li><a href="#dashboard" >Dashboard</a></li>';
    put '<li><a href="#risk-categories" >Risk Category</a></li>';
    put '<li><a href="#analytics">Analytics</a></li>';
    put '<li><a href="#settings">Settings</a></li>';
    put '</ul>';
    put '<div class="nav-user">';
    put '<div class="user-avatar"><i class="fas fa-user"></i></div>';
    put '<div class="user-info">';
    put '<div class="user-name">John Doe</div>';
    put '<div class="user-role">Risk Manager</div>';
    put '</div>';
    put '</div>';
    put '</div>';
    put '</nav>';
%mend generate_navbar;


/* ============================================================================
   DASHBOARD TABLE STYLES
   ============================================================================ */
%macro generate_dashboard_table_styles;
    put '.dashboard-table-container { overflow-x: auto; border-radius: 12px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); }';
    put '.dashboard-table { width: 100%; border-collapse: collapse; background: white; font-size: 0.9rem; }';
    put '.dashboard-table th { background: #f8fafc; padding: 15px 12px; text-align: left; font-weight: 600; color: #374151; border-bottom: 2px solid #e5e7eb; }';
    put '.dashboard-table td { padding: 12px; border-bottom: 1px solid #f3f4f6; color: #374151; }';
    put '.dashboard-table tr:hover { background: #f9fafb; }';
    put '.status-badge { padding: 4px 8px; border-radius: 6px; font-size: 0.8rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }';
    put '.status-badge.compliant { background: #dcfce7; color: #166534; }';
    put '.status-badge.warning { background: #fef3c7; color: #92400e; }';
    put '.status-badge.danger { background: #fee2e2; color: #991b1b; }';
    put '.btn-sm { padding: 6px 12px; font-size: 0.8rem; }';
%mend generate_dashboard_table_styles;


