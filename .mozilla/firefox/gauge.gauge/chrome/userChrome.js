// Copyright (c) 2017 Haggai Nuchi
// Available for use under the MIT License:
// https://opensource.org/licenses/MIT

// Set "useLionFullScreen" in the same way that it's done in
// chrome://browser/content/browser-fullScreenAndPointerLock.js
XPCOMUtils.defineLazyGetter(FullScreen, "useLionFullScreen", function() {
	return false;
});

/*
function tabClick() {
	var classname = document.getElementsByClassName("tabbrowser-tab");
	var addressBar= document.getElementById('urlbar');

	var myFunction = function() {
		document.getElementById('urlbar').focus();
	};
	
	for (var i = 0; i < classname.length; i++) {
		classname[i].addEventListener('click', myFunction);
	}
};

setInterval(tabClick, 2000);
*/

var myFunction = function() {
	document.getElementById('urlbar').focus();
};

function tabClick() {

	var classname = document.getElementsByClassName("tabbrowser-tab");

	for (var i = 0; i < classname.length; i++) {
		classname[i].removeEventListener('click', myFunction);
	}

	document.querySelector(".tabbrowser-tab[selected=\"true\"]").addEventListener('click', myFunction);

};

setInterval(tabClick, 800);

