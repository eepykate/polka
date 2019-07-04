// ==UserScript==
// @name                 Tab Click
// @version              1.0
// @description          Click the active tab to focus the urlbar
// @author               https://reddit.com/user/otto251
// @license              https://creativecommons.org/share-your-work/public-domain/cc0/
// @compatibility        Created 2019-07-04. Tested on Firefox 69.0b1
// ==/UserScript==
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
