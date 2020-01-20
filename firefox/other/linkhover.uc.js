// ==UserScript==
// @name                 Statuspanel @ mousepointer
// @version              1.0
// @description          Makes the statuspanel appear at the mouse pointer.
// @compatibility        Created 2019-05-11. Tested on Firefox 66.
// ==/UserScript==
 
(function() {
    if(location != "chrome://browser/content/browser.xul")
    return;
 
    var sp = document.getElementById("statuspanel");
    sp.addEventListener ('DOMAttrModified', OnAttrModified, false);
   
    xpos=0;
    ypos=0;
   
    document.onmousemove = function(e) {
        xpos = e.pageX;
        ypos = e.pageY;
    }
   
    function OnAttrModified()
    {
        sp.style.display = 'position';
        sp.style.left = xpos+'px';
        sp.style.top = ypos+'px';
    }
})();
