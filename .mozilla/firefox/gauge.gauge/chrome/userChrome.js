// Copyright (c) 2017 Haggai Nuchi
// Available for use under the MIT License:
// https://opensource.org/licenses/MIT

// Set "useLionFullScreen" in the same way that it's done in
// chrome://browser/content/browser-fullScreenAndPointerLock.js
XPCOMUtils.defineLazyGetter(FullScreen, "useLionFullScreen", function() {
	return false;
});

var myFunction = function(e) {
	const lmb = e.button === 0;
	if (lmb) {
		document.getElementById('urlbar').focus();
	}
};

function tabClick() {

	var classname = document.getElementsByClassName("tabbrowser-tab");

	for (var i = 0; i < classname.length; i++) {
		classname[i].removeEventListener('click', myFunction);
	}

	document.querySelector(".tabbrowser-tab[selected=\"true\"]").addEventListener('click', myFunction);

};

setInterval(tabClick, 800);

