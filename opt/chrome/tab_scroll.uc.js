// Switch tabs by scrolling on the tab bar. Also works on the specified extension's sidebar.
(function() {
    const EXT_ID = "{0ad88674-2b41-4cfb-99e3-e206c74a0076}";
    const wrap = true;
    const scrollRight = true;
    const sidebarActionId = `${makeWidgetId(EXT_ID)}-sidebar-action`;

    gBrowser.tabContainer.addEventListener("wheel", e => scroll(e), true);
    document.getElementById("sidebar").onwheel = e => scroll(e, true);

    function scroll(e, sidebar) {
        let broadcaster = document.getElementById(sidebarActionId);
        if(sidebar && !broadcaster.hasAttribute("checked")) return;
        e.preventDefault();
        let dir = (scrollRight ? 1 : -1) * Math.sign(e.deltaY);
        gBrowser.tabContainer.advanceSelectedTab(dir, wrap);
    }

    function makeWidgetId(id) {
        id = id.toLowerCase();
        return id.replace(/[^a-z0-9_-]/g, "_");
    }
})();
