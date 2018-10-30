document.body.classList.remove('nojs')
var DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fry', 'Sat']

var clockElem = document.getElementById('clock')
var dateElem = document.getElementById('date')
var header = document.getElementById('sticky-header')
var topHeader = document.getElementById('top-header')
var analogClockCanvas = document.getElementById('analog-clock-canvas')

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
    AnalogClock(analogClockCanvas, now)
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

function AnalogClock(canvas, date) {
    var ctx = canvas.getContext('2d')

    var h = date.getHours() % 12
    var m = date.getMinutes()
    var s = date.getSeconds()

    var cx = canvas.height / 2
    var cy = canvas.width / 2
    var r = canvas.height / 2 - 1

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    ctx.beginPath()
    ctx.lineWidth = 2
    ctx.strokeStyle = '#eceff4'

    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
    ctx.stroke()

    var hr = (
        h * 2 * Math.PI / 12
        + m * 2 * Math.PI / 12 / 60
        - Math.PI / 2
    )
    var hlx = 3 / 5 * r * Math.cos(hr) + cx
    var hly = 3 / 5 * r * Math.sin(hr) + cy
    ctx.moveTo(cx, cy)
    ctx.lineTo(hlx, hly)

    var mr = m * 2 * Math.PI / 60 - Math.PI / 2
    var mlx = r * Math.cos(mr) + cx
    var mly = r * Math.sin(mr) + cy
    ctx.moveTo(cx, cy)
    ctx.lineTo(mlx, mly)
    ctx.stroke()

    ctx.beginPath()
    ctx.strokeStyle = '#5e81ac'
    var sr = s * 2 * Math.PI / 60 - Math.PI / 2
    var slx = r * Math.cos(sr) + cx
    var sly = r * Math.sin(sr) + cy
    ctx.moveTo(cx, cy)
    ctx.lineTo(slx, sly)

    ctx.stroke()
}