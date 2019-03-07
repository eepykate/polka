// @license magnet:?xt=urn:btih:1f739d935676111cfff4b4693e3816e664797050&dn=gpl-3.0.txt GPL-v3-or-Later

function startTime() {
    var today = new Date();
    var h = today.getHours();
    var ampm = h >= 12 ? 'PM' : 'AM';
    var m = today.getMinutes();
    var s = today.getSeconds();
    m = checkTime(m);
    s = checkTime(s);
    var h = h % 12;
    var h = h ? h : 12; // the hour '0' should be '12'

    document.getElementById('time').innerHTML =
    h + ":" + m + ":" + s + ' ' + ampm;
    var t = setTimeout(startTime, 500);
}

function checkTime(i) {
   if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
   return i;
}

var n = document.getElementById("notes");
// retrieve (only on page load) 
if(window.localStorage){ n.value = localStorage.getItem("notes");}
// save 
var s = function(){localStorage.setItem("notes", n.value);}
// autosave onchange and every 500ms and when you close the window 
n.onchange = s();
setInterval( s, 500);
window.onunload = s();


// @license-end
