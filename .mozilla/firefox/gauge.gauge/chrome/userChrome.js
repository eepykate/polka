// Copyright (c) 2017 Haggai Nuchi
// Available for use under the MIT License:
// https://opensource.org/licenses/MIT

// Set "useLionFullScreen" in the same way that it's done in
// chrome://browser/content/browser-fullScreenAndPointerLock.js
XPCOMUtils.defineLazyGetter(FullScreen, "useLionFullScreen", function() {
	return false;
});
