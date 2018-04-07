WorkerScript.onMessage = function(message) {
    var sub = [];
    var text = [];
    var a = message.subtitles;
    var pos = message.position;
    var ii = 0;
    var i0 = 0;
    var i1 = a.length;

    while (i1 - i0 > 1) {
        ii = (i0 + i1) >> 1;
        if (pos < a[ii].start) i1 = ii; else i0 = ii;
    }

    while (i0 >= 0 && pos <= a[i0].end) i0--;

    for (ii = i0 + 1; ii < i1; ii++) {
        sub = a[ii];
        if (sub.start <= pos) {
            text.push(sub.text);
        }
    }

    WorkerScript.sendMessage(text.join('\n'));
}
