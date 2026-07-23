
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
    put "<li><a href='#dashboard' onclick='showRoute(""#dashboard""); return false;'>Dashboard</a></li>";
    put "<li><a href='#risk-categories' onclick='showRoute(""#risk-categories""); return false;'>Risk Category</a></li>";
    put "<li><a href='#analytics' onclick='showRoute(""#analytics""); return false;'>Analytics</a></li>";
    put '</ul>';
    put '<div class="nav-user">';
    put '<div class="user-avatar"><i class="fas fa-user"></i></div>';
    put '<div class="user-info">';
    put "<div class='user-name'>&sysuserid</div>"; 
    put '</div>';
    put '</div>';
    put '</div>';
    put '</nav>';
%mend generate_navbar;

/* ============================================================================
   SIDEBAR COMPONENT
   ============================================================================ */
%macro generate_sidebar;
    put '<aside class="sidebar" id="sidebar">';
    put '<ul class="sidebar-menu">';
    put '<li><a href="#dashboard" class="active"><i class="fas fa-tachometer-alt"></i>CRO Dashboard</a></li>';
    put '<li><a href="#risk-categories"><i class="fas fa-layer-group"></i>Risk Categories</a></li>';

    /* Gated to match riskModulesConfig.sas - same ALLOWED_CATEGORIES list,
       same %categoryAllowed predicate, so the sidebar never links to a
       category the user's cards don't show. */
    %if %categoryAllowed(regulatory) %then
        put '<li><a href="#regulatory"><i class="fas fa-gavel"></i>Regulatory Risk</a></li>';
    %if %categoryAllowed(credit) %then
        put '<li><a href="#credit"><i class="fas fa-credit-card"></i>Credit Risk</a></li>';
    %if %categoryAllowed(operational) %then
        put '<li><a href="#operational"><i class="fas fa-cogs"></i>Operational Risk</a></li>';
    %if %categoryAllowed(market) %then
        put '<li><a href="#market"><i class="fas fa-chart-line"></i>Market Risk</a></li>';
    %if %categoryAllowed(liquidity) %then
        put '<li><a href="#liquidity"><i class="fas fa-water"></i>Liquidity Risk</a></li>';
    %if %categoryAllowed(icaap) %then
        put '<li><a href="#icaap"><i class="fas fa-balance-scale"></i>ICAAP</a></li>';
    %if %categoryAllowed(ilaap) %then
        put '<li><a href="#ilaap"><i class="fas fa-tint"></i>ILAAP</a></li>';

    put '<li><a href="#reports"><i class="fas fa-file-alt"></i>Data Extraction</a></li>';
    put '</ul>';
    put '</aside>';
%mend generate_sidebar;

/* ============================================================================
   PAGE HEADER COMPONENT
   ============================================================================ */
%macro generate_page_header;
    put '<div class="page-header">';
    put '<div class="breadcrumb">';
    put '<a href="#dashboard">Dashboard</a>';
    put '<i class="fas fa-chevron-right"></i>';
    put '<span>Risk Management</span>';
    put '</div>';
    put '<h1 class="page-title">Risk Management Dashboard</h1>';
    put '<p class="page-subtitle">Comprehensive overview of enterprise risk metrics and compliance status</p>';
    put '</div>';
%mend generate_page_header;

/* ============================================================================
   QUICK STATS COMPONENT
   ============================================================================ */
%macro generate_quick_stats;
    put '<div class="quick-stats">';
    put '<div class="stat-card positive">';
    put '<div class="stat-number" id="total-reports">0</div>';
    put '<div class="stat-text">Total Reports</div>';
    put '</div>';
    put '<div class="stat-card positive">';
    put '<div class="stat-number" id="compliance-rate">0%</div>';
    put '<div class="stat-text">Compliance Rate</div>';
    put '</div>';
    put '<div class="stat-card warning">';
    put '<div class="stat-number" id="risk-score">0</div>';
    put '<div class="stat-text">Risk Score</div>';
    put '</div>';
    put '<div class="stat-card positive">';
    put '<div class="stat-number" id="active-users">0</div>';
    put '<div class="stat-text">Active Users</div>';
    put '</div>';
    put '</div>';
%mend generate_quick_stats;

/* ============================================================================
   RISK MODULE COMPONENT
   ============================================================================ */
%macro generate_risk_module(module_type, title, description, icon, color_class, stat1_value, stat1_label, stat2_value, stat2_label);
    put '<div class="risk-module" data-module="&module_type">';
    put '<div class="module-header">';
    put '<div class="module-icon &color_class"><i class="&icon"></i></div>';
    put '<h3 class="module-title">&title</h3>';
    put '</div>';
    put '<p class="module-description">&description</p>';
    put '<div class="module-stats">';
    put '<div class="stat-item"><div class="stat-value">&stat1_value</div><div class="stat-label">&stat1_label</div></div>';
    put '<div class="stat-item"><div class="stat-value">&stat2_value</div><div class="stat-label">&stat2_label</div></div>';
    put '</div>';
    put '</div>';
%mend generate_risk_module;



/* ============================================================================
   RECENT ACTIVITY COMPONENT
   ============================================================================ */
%macro generate_recent_activity;
    put '<div class="side-panel">';
    put '<h3 style="margin-bottom: 20px; color: #1f2937; font-size: 1.3rem;">Recent Activity</h3>';
    put '<ul class="activity-list">';
    put '<li class="activity-item">';
    put '<div class="activity-icon" style="background: #10b981;"><i class="fas fa-check"></i></div>';
    put '<div class="activity-content">';
    put '<div class="activity-title">Regulatory Report Generated</div>';
    put '<div class="activity-time">2 minutes ago</div>';
    put '</div>';
    put '</li>';
    put '<li class="activity-item">';
    put '<div class="activity-icon" style="background: #3b82f6;"><i class="fas fa-upload"></i></div>';
    put '<div class="activity-content">';
    put '<div class="activity-title">Credit Risk Data Updated</div>';
    put '<div class="activity-time">15 minutes ago</div>';
    put '</div>';
    put '</li>';
    put '<li class="activity-item">';
    put '<div class="activity-icon" style="background: #f59e0b;"><i class="fas fa-exclamation-triangle"></i></div>';
    put '<div class="activity-content">';
    put '<div class="activity-title">Market Risk Alert</div>';
    put '<div class="activity-time">1 hour ago</div>';
    put '</div>';
    put '</li>';
    put '<li class="activity-item">';
    put '<div class="activity-icon" style="background: #8b5cf6;"><i class="fas fa-user"></i></div>';
    put '<div class="activity-content">';
    put '<div class="activity-title">New User Login</div>';
    put '<div class="activity-time">2 hours ago</div>';
    put '</div>';
    put '</li>';
    put '</ul>';
    put '</div>';
%mend generate_recent_activity;

/* ============================================================================
   MODAL COMPONENT
   ============================================================================ */
%macro generate_modal;
    put '<div class="modal" id="reportModal">';
    put '<div class="modal-content">';
    put '<div class="modal-header">';
    put '<h3 class="modal-title" id="modalTitle">Report Details</h3>';
    put '<button class="modal-close" onclick="closeModal()">&times;</button>';
    put '</div>';
    put '<div id="modalBody"></div>';
    put '</div>';
    put '</div>';
%mend generate_modal;

/* ============================================================================
   LOADING COMPONENT
   ============================================================================ */
%macro generate_loading;
    put '<div class="loading" id="loading"><div class="spinner"></div></div>';
%mend generate_loading;

/* ============================================================================
   NOTIFICATION COMPONENT
   ============================================================================ */
%macro generate_notification;
    put '<div class="notification" id="notification"><i class="fas fa-check-circle"></i><span id="notification-text">Report generated successfully!</span></div>';
%mend generate_notification;
