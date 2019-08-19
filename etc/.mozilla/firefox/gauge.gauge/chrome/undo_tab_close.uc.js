// ==UserScript==
// @name           middle-click "Undo Close Tab"
// @description    ??????????????????????????
// @version        1.1
// @include        main
// @compatibility  Firefox ESR31.3, 34.0.5
// @author         oflow
// @namespace      https://oflow.me/archives/265
// @note           Firefox 31.3, 34.0.5 ?????
// @note           remove arguments.callee
// @note           mTabContainer -> tabContainer
// ==/UserScript==

(function() {
    var ucjsUndoCloseTab = function(e) {
        // ?????????
        if (e.button != 1) {
            return;
        }
        // ???????????????????
        if (e.target.localName != 'tabs' && e.target.localName != 'toolbarbutton') {
            return;
        }
        undoCloseTab(0);
        e.preventDefault();
        e.stopPropagation();
    }
    // ?????????
    document.getElementById('new-tab-button').onclick = ucjsUndoCloseTab;
    // ????
    gBrowser.tabContainer.addEventListener('click', ucjsUndoCloseTab, true);
    window.addEventListener('unload', function uninit() {
        gBrowser.tabContainer.removeEventListener('click', ucjsUndoCloseTab, true);
        window.removeEventListener('unload', uninit, false);
    }, false);
})();
