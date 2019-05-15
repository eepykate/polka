// @license magnet:?xt=urn:btih:1f739d935676111cfff4b4693e3816e664797050&dn=gpl-3.0.txt GPL-v3-or-Later

var DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

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

	//---------------------

	var dow = DAYS[today.getDay()]
	var dd = ('0' + today.getDate()).slice(-2)
	var mm = ('0' + (today.getMonth() + 1 )).slice(-2)
	var yy = today.getFullYear()

	document.getElementById('date').innerHTML = dow + ' ' + yy + '-' + mm + '-' + dd

	//---------------------

	document.getElementById('time').innerHTML =
	h + ":" + m + ":" + s + ' ' + ampm;
	var t = setTimeout(startTime, 500);
}

function checkTime(i) {
  if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
  return i;
}

var dateElem = document.getElementById('date')

var vpwidth = document.documentElement.clientWidth
var sections = document.querySelectorAll('.box')
function fixSectionHeight() {
	var step = 1
	if (vpwidth >= 480) step = 2;
	if (vpwidth >= 768) step = 4;

	sections.forEach(function (s) {
		s.style.height = 'auto'
	})

	for (var i = 0; i < sections.length; i += step) {
		var ss = Array.prototype.slice.call(sections, i, i + step)
		var hss = ss.map(function (e) { return e.clientHeight })
		var h = Math.max.apply(null, hss)
		ss.forEach(function (s) {
			s.style.height = h + 'px'
		})
	}
}

//fixSectionHeight()
//window.addEventListener('resize', fixSectionHeight)

/* First page of notes */
var n1 = document.getElementById("notes1");
// retrieve (only on page load) 
if(window.localStorage){ n1.value = localStorage.getItem("notes1");}
// save 
var s1 = function(){localStorage.setItem("notes1", n1.value);}
// autosave onchange and every 500ms and when you close the window 
n1.onchange = s1();
setInterval( s1, 500);
window.onunload = s1();

/* Second page of notes */
var n2 = document.getElementById("notes2");
// retrieve (only on page load) 
if(window.localStorage){ n2.value = localStorage.getItem("notes2");}
// save 
var s2 = function(){localStorage.setItem("notes2", n2.value);}
// autosave onchange and every 500ms and when you close the window 
n2.onchange = s2();
setInterval( s2, 500);
window.onunload = s2();

/* Third page of notes */
var n3 = document.getElementById("notes3");
// retrieve (only on page load) 
if(window.localStorage){ n3.value = localStorage.getItem("notes3");}
// save 
var s3 = function(){localStorage.setItem("notes3", n3.value);}
// autosave onchange and every 500ms and when you close the window 
n3.onchange = s3();
setInterval( s3, 500);
window.onunload = s3();

function toggleSidebar(){
	document.getElementById("sidebar").classList.toggle('active');
}

// Detect all clicks on the document
document.addEventListener("click", function(event) {
// If user clicks inside the element, do nothing
if (event.target.closest("#sidebar")) return;
if (event.target.closest(".sidebar-toggle")) return;

// If user clicks outside the element, hide it!
document.getElementById("sidebar").classList.remove('active');
});


/* Sidebar Tabs */
function changeTab(tabName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "selected"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" selected", "");
  }

  // Show the current tab, and add a "selected" class to the button that opened the tab
  document.getElementById(tabName).style.display = "block";
  event.currentTarget.className += " selected";
} 

// Get the element with id="defaultOpen" and click on it
document.getElementById("defaultOpen").click();

// @license-end
