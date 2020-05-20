// ==UserScript==
// @name        Discord Quick Delete Messages
// @description Adds functionality to delete messages faster by ctrl+right-clicking them.
// @namespace   Violentmonkey Scripts
// @grant       GM_addStyle
// @require     http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js
// @match       *://discord.com/*
// ==/UserScript==

$('body').on('contextmenu', 'div[class*="cozyMessage-"]', function(e) {
	if (e.ctrlKey) {
		$(this).find("div[aria-label^='More']").trigger("click");
		$('#message-actions-delete').trigger("click");
		function fun() {
			$("div[class^='backdrop-']").css("display", "none");
			$("form[class^='modal-']").css("display", "none").find("button[class*='colorRed']").trigger("click");
		}
		setTimeout(fun, 65);
	}
});
