// ==UserScript==
// @name        select all/no gmails on the classic view
// @namespace   Violentmonkey Scripts
// @match       https://mail.google.com/*
// @grant       none
// @version     1.0
// @author      -
// @description 19/09/2020, 00:18:56
// ==/UserScript==

(function() {
	window.addEventListener("load", () => {
		addButton("select");
	});

	function addButton(text, onclick, cssObj) {
		cssObj = cssObj || {
			position: "fixed",
			"top": "4px",
			left: "4px",
		};
		let button = document.createElement("button"),
		btnStyle = button.style;
		button.setAttribute("id", "butt");
		document.body.appendChild(button);
		button.innerHTML = text;
		// Settin function for button when it is clicked.
		button.onclick = selectReadFn;
		Object.keys(cssObj).forEach(key => (btnStyle[key] = cssObj[key]));
		return button;
	}

	function selectReadFn() {
		// Just to show button is pressed
		if (document.getElementById("butt").hasAttribute("clicked")) {
			document.querySelectorAll('input[name=t]').forEach(t=>t.checked = false);
			document.getElementById("butt").removeAttribute("clicked");
		} else {
			document.querySelectorAll('input[name=t]').forEach(t=>t.checked = true);
			document.getElementById("butt").setAttribute("clicked", "true");
		}
	}
})();
