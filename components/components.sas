
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
    /* Dashboard dropdown - added in place of the old plain Dashboard link.
       CRO Dashboard opens the Risk Appetite Framework section (CRO-only, see
       Javascript/routes/riskAppetiteFramework/buildRAF.sas); Market/Credit/
       Operational Risk point at the #market/#credit/#operational routes
       registered in router.sas. Inline styles used here (not a new css.sas
       class) so this dropdown needs no edit to the existing stylesheet -
       matches ERMS's own existing habit of mixing inline styles with
       classes elsewhere in this file. */
    put '<li style="position:relative;" id="rafDashboardDropdown">';
    put '<a onclick="raf_toggleDashboardDropdown(event); return false;" style="display:flex; align-items:center; gap:6px; cursor:pointer;">Dashboard <i class="fas fa-caret-down" style="font-size:.75em;"></i></a>';
    put '<ul id="rafDashboardDropdownMenu" style="display:none; position:absolute; top:100%; left:0; background:#ffffff; min-width:190px; border-radius:8px; box-shadow:0 12px 28px rgba(0,0,0,.18); padding:6px; margin-top:10px; z-index:1100;">';
    put '<li><a onclick="raf_closeDashboardDropdown(); showRoute(''#risk-appetite-framework''); return false;" style="display:block; padding:9px 12px; border-radius:6px; color:#1f2937; font-weight:500; font-size:.9rem;">CRO Dashboard</a></li>';
    put '<li><a onclick="raf_closeDashboardDropdown(); showRoute(''#market''); return false;" style="display:block; padding:9px 12px; border-radius:6px; color:#1f2937; font-weight:500; font-size:.9rem;">Market Risk</a></li>';
    put '<li><a onclick="raf_closeDashboardDropdown(); showRoute(''#credit''); return false;" style="display:block; padding:9px 12px; border-radius:6px; color:#1f2937; font-weight:500; font-size:.9rem;">Credit Risk</a></li>';
    put '<li><a onclick="raf_closeDashboardDropdown(); showRoute(''#operational''); return false;" style="display:block; padding:9px 12px; border-radius:6px; color:#1f2937; font-weight:500; font-size:.9rem;">Operational Risk</a></li>';
    put '</ul>';
    put '</li>';
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
