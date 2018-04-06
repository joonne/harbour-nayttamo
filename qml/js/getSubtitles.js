WorkerScript.onMessage = function(url) {
    var e = true;
    var cp = true;
    var def = true;
    var subtitles = [];
    var doc = new XMLHttpRequest();

    doc.onreadystatechange = function() {
        if (doc.readyState === XMLHttpRequest.DONE) {
            if (doc.status === 200) {
                try {
                    srtParser(doc, subtitles);
                    WorkerScript.sendMessage(subtitles);
                } catch(err) {
                    WorkerScript.sendMessage([]);
                }
            }
        }
    }

    doc.open("GET", url);
    doc.send();
}

/* This should work with multi line srts but might contain some bugs still */
function srtParser(doc, subtitles) {
    var srt_ = doc.responseText.replace(/\r\n?/g, '\n').trim().split(/\n{2,}/);
    var s, st, n, pp;
    for (s in srt_) {
        var sub = {};
        st = srt_[s].split('\n');
        if (st.length >=2) {
            n = st[0];
            pp = st[1].split(' --> ');
            sub["start"] = getSubTime(pp[0].trim());
            sub["end"] = getSubTime(pp[1].trim());
            sub["text"] = st[2];
            if (st.length > 3) {
                for (var j = 3; j < st.length; j++)
                    sub["text"] += '\n' + st[j];
            }
            subtitles.push(sub);
        }
    }
}

function getSubTime(time) {
    var hms = time.split(":");
    var hours = hms[0] * 3600000;
    var mins = hms[1] * 60000;
    var sms = hms[2].split(",");
    var secs = sms[0] * 1000;
    var msecs = parseInt(sms[1]);
    return hours + mins + secs + msecs;
}
