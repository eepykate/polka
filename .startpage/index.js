document.body.classList.remove('nojs')
var DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

var clockElem = document.getElementById('clock')
var dateElem = document.getElementById('date')
var topHeader = document.getElementById('top-header')

var sections = document.querySelectorAll('.nav-wrapper')

var vpwidth = document.documentElement.clientWidth
var stickpx = topHeader.clientHeight

window.addEventListener('resize', function () {
    vpwidth = document.documentElement.clientWidth
    stickpx = topHeader.clientHeight
})

function stickHeader() {
    console.log(stickpx, window.pageYOffset)
    if (window.pageYOffset > stickpx) {
        header.classList.add('sticky')
    } else {
        header.classList.remove('sticky')
    }
}

window.addEventListener('scroll', stickHeader)

function padNumber(size, num) {
    var snum = num.toString()
    for (var i = 0; i < size - snum.length; i++) {
        snum = '0' + snum
    }
    return snum
}

function ClockComp(elem, date) {
    var hh = padNumber(2, date.getHours())
    var mm = padNumber(2, date.getMinutes())

    elem.innerHTML = hh + ':' + mm;
}

function DateComp(elem, date) {
    var dow = DAYS[date.getDay()]
    var dd = padNumber(2, date.getDate())
    var mm = padNumber(2, date.getMonth() + 1)
    var yy = padNumber(4, date.getFullYear())

    elem.innerHTML = dow + ' ' + yy + '-' + mm + '-' + dd
}

function timer() {
    var now = new Date()
    ClockComp(clockElem, now)
    DateComp(dateElem, now)
    stickpx = topHeader.clientHeight
}

setInterval(timer, 500)
timer()

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

fixSectionHeight()
window.addEventListener('resize', fixSectionHeight)

