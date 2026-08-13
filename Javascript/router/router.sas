
/* ============================================================================
   JAVASCRIPT ROUTING SYSTEM
   ============================================================================ */
%macro generate_javascript_routing;

    put '// Global routing variables';
    put 'var currentRoute = "#dashboard";';
    put 'var routes = {';
    put '  "#dashboard": getDashboardTableHTML,';
    put '  "#risk-categories": getRiskCategoriesHTML,';
    put '  "#analytics": getAnalyticsHTML,';
    put '  "#regulatory-reports": getRegulatoryReportsHTML,';
    put '  "#saibor-saibid": getSaiborHTML,';
    /* Risk Appetite Framework (CRO-only section) - added without touching any key above */
    put '  "#risk-appetite-framework": getRAFHTML,';
    /* Reached from the navbar's Dashboard dropdown (components.sas) - see
       buildUnderProcessPlaceholders.sas for why these are simple placeholders. */
    put '  "#market": getMarketRiskPlaceholderHTML,';
    put '  "#credit": getCreditRiskPlaceholderHTML,';
    put '  "#operational": getOperationalRiskPlaceholderHTML';
    put '};';
    put '// Main routing function';
    put 'function showRoute(route) {';
    put '  console.log("Navigating to:", route);';
    put '  currentRoute = route;';
    put '  updateContent();';
    put '  // Update URL without page reload';
    put '  if (window.history && window.history.pushState) {';
    put '    window.history.pushState(null, null, route);';
    put '  }';
    put '}';
    put '// Update content based on current route';
    put 'function updateContent() {';
    put '  var mainPanel = document.getElementById("main-panel");';
    put '  if (!mainPanel) return;';
    put '  var routeFunction = routes[currentRoute];';
    put '  console.log(routeFunction);';
    put '  if (routeFunction && typeof routeFunction === "function") {';
    put '    mainPanel.innerHTML = routeFunction();';
    put '    // Initialize route-specific functionality';
    put '    initializeRouteFunctionality();';
    put '  console.log("HHHH");';
    put '  } else {';
    put '    mainPanel.innerHTML = "<div style=\"text-align: center; padding: 50px;\"><h2>Page Not Found</h2><p>The requested page could not be found.</p></div>";';
    put '  }';
    put '}';
    put '// Initialize route-specific functionality';
    put 'function initializeRouteFunctionality() {';
    put '  if (currentRoute === "#dashboard") {';
    put '    // Load API data for dashboard';
    put '    setTimeout(function() {';
    put '      refreshDashboardData();';
    put '    }, 100);';
    put '  }';
    put '}';
    put '// Handle browser back/forward buttons';
    put 'window.addEventListener("popstate", function() {';
    put '  currentRoute = window.location.hash || "#dashboard";';
    put '  updateContent();';
    put '});';
    put '// Initialize on page load';
    put 'document.addEventListener("DOMContentLoaded", function() {';
    put '  currentRoute = window.location.hash || "#dashboard";';
    put '  updateContent();';
    put '});';
    put '</script>';
%mend generate_javascript_routing;




%macro generate_route_container;
    put '<div class="dashboard-grid">';
    put '<div id="main-panel" class="main-panel">';
    put '<!-- Content will be loaded dynamically by JavaScript -->';
    put '</div>';
    put '</div>';
%mend generate_route_container;
