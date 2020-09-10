#!/bin/sh

loc="/usr/lib/firefox-developer-edition"
[ -d "$loc" ] || loc="/usr/lib/firefox"

cat << EOF | sudo tee "$loc/autoconfig.cfg"
//
// first line has to be a comment

var {classes:Cc,interfaces:Ci,utils:Cu} = Components;

/* set new tab page */
try {
  Cu.import("resource:///modules/AboutNewTab.jsm");
  var newTabURL = "file://$HOME/usr/startpage/index.html";
  AboutNewTab.newTabURL = newTabURL;
} catch(e){Cu.reportError(e);} // report errors in the Browser Console
EOF

cat << EOF | sudo tee "$loc/defaults/pref/autoconfig.js"
//
// first line has to be a comment
pref("general.config.filename", "autoconfig.cfg");
pref("general.config.obscure_value", 0);
pref("general.config.sandbox_enabled", false);
EOF
