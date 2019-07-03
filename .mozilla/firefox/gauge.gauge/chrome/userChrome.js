var thing = 0;
var myFunction = function(e) {
	if (thing === 1) {
		const lmb = e.button === 0;
		if (lmb) {
			document.getElementById('urlbar').focus();
		}
	} else {
		thing = 1;
	}
};

function tabClick() {
	var classname = document.getElementsByClassName("tabbrowser-tab");

	for (var i = 0; i < classname.length; i++) {
		classname[i].removeEventListener('click', myFunction);
	}
	thing = 0;

	document.querySelector(".tabbrowser-tab[selected=\"true\"]").addEventListener('click', myFunction);
}

gBrowser.tabContainer.addEventListener("TabSelect", tabClick);


// ==UserScript==
// @name                 Custom New Tab
// @version              1.0
// @description          Load a custom link or local file, instead of the default new tab page (about:newtab).
// @author               https://www.reddit.com/user/Luke-Baker/
// @license              https://creativecommons.org/licenses/by-sa/4.0/
// @compatibility        Created 2018-01-15. Tested on Firefox 59.
// ==/UserScript==
(function() {

	// IMPORTANT: when there's no filename, be sure to include a trailing slash at the end.
	const mypage = "/home/gauge/.startpage/index.html";
	// Don't place the caret in the location bar. Useful if you want a page's search box to have focus instead.
	var removefocus = "yes";
	// Clear the page's URL from the location bar. Normally not needed, as this should already be the default behavior.
	var clearlocationbar = "no";

	aboutNewTabService.newTabURL = mypage;
	function customNewTab () {
		if (removefocus == "yes") {
			setTimeout(function() {
				gBrowser.selectedBrowser.focus();
			}, 0);
		}
		if (clearlocationbar == "yes") {
			setTimeout(function() {
				if (gBrowser.selectedBrowser.currentURI.spec == mypage) {
					window.document.getElementById("urlbar").value = "";
				}
			}, 1000);
		}
	}
	gBrowser.tabContainer.addEventListener("TabOpen", customNewTab, false);

}());
