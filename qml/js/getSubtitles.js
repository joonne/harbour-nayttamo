/**

  Heavily inspired and/or copied from harbour-videoPlayer: https://github.com/llelectronics/videoPlayer
  original source file: https://github.com/llelectronics/videoPlayer/blob/master/qml/pages/helper/getsubtitles.js

**/

var getSubTime = function(time) {
    var hms = time.split(":");
    var hours = hms[0] * 3600000;
    var mins = hms[1] * 60000;
    var sms = hms[2].split(",");
    var secs = sms[0] * 1000;
    var msecs = parseInt(sms[1]);

    return hours + mins + secs + msecs;
};

// TODO: rewrite this to be more clear?
var srtParser = function(doc) {
    var srt_ = doc.responseText.replace(/\r\n?/g, '\n').trim().split(/\n{2,}/);
    var s, st, n, pp;
    var subtitles = [];
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

    return subtitles;
};

WorkerScript.onMessage = function(url) {
    var e = true;
    var cp = true;
    var def = true;
    var doc = new XMLHttpRequest();

    doc.onreadystatechange = function() {
        if (doc.readyState === XMLHttpRequest.DONE) {
            if (doc.status === 200) {
                try {
                    WorkerScript.sendMessage(srtParser(doc));
                } catch(err) {
                    WorkerScript.sendMessage([]);
                }
            }
        }
    }

    doc.open("GET", url);
    doc.send();
}
