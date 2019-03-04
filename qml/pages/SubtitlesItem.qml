/**

  Heavily inspired and/or copied from harbour-videoPlayer: https://github.com/llelectronics/videoPlayer
  original source file: https://github.com/llelectronics/videoPlayer/blob/master/qml/pages/helper/SubtitlesItem.qml
  Original source license: BSD (3-clause)

**/

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: rootItem

    property variant wrapMode
    property variant horizontalAlignment
    property variant verticalAlignment
    property variant pixelSize
    property variant bold
    property variant color
    property bool isSolid: false

    function getSubtitles(url) {
        subsGetter.sendMessage(url !== "" ? url : streamUrl)
    }

    function setSubtitles(subs) { subtitles = subs }

    WorkerScript {
        id: subsGetter

        source: "../js/getSubtitles.js"
        onMessage: setSubtitles(messageObject)
    }

    function checkSubtitles() {
        subsChecker.sendMessage({ "position": mediaPlayer.position, "subtitles": subtitles })
    }

    WorkerScript {
        id: subsChecker

        source: "../js/checkSubtitles.js"
        onMessage: !isSolid
                   ? subtitlesText.text = messageObject
                   : subtitlesTextArea.text = messageObject
    }

    function contrastingColor(color) {
        var rgb = getRGB(color)

        if (!rgb) {
            return null
        }

        // TODO: what are these values?
        return (0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]) > 180 ? "black" : "white"
    }

    // TODO: find out how to clean this and if we need it
    function getRGB(b) {
        var a;
        if (b && b.constructor === Array && b.length === 3) return b;
        if (a = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(b)) return [parseInt(a[1]), parseInt(a[2]), parseInt(a[3])];
        if (a = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(b)) return [parseFloat(a[1]) * 2.55, parseFloat(a[2]) * 2.55, parseFloat(a[3]) * 2.55];
        if (a = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(b)) return [parseInt(a[1], 16), parseInt(a[2], 16), parseInt(a[3],
                                                                                                                                      16)];
        if (a = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(b)) return [parseInt(a[1] + a[1], 16), parseInt(a[2] + a[2], 16), parseInt(a[3] + a[3], 16)];
    }

    Label {
        id: subtitlesText

        z: 100
        anchors.fill: parent
        wrapMode: rootItem.wrapMode
        horizontalAlignment: rootItem.horizontalAlignment
        verticalAlignment: rootItem.verticalAlignment
        font.pixelSize: rootItem.pixelSize
        font.bold: rootItem.bold
        color: rootItem.color
        visible: parent.visible && !isSolid
        style: Text.Outline
        styleColor: contrastingColor(color)
    }

    TextEdit {
        id: subtitlesTextArea

        z: 100
        anchors.fill: parent
        wrapMode: rootItem.wrapMode
        horizontalAlignment: rootItem.horizontalAlignment
        verticalAlignment: rootItem.verticalAlignment
        font.pixelSize: rootItem.pixelSize
        font.bold: rootItem.bold
        color: rootItem.color
        textFormat: Text.AutoText
        selectedTextColor: rootItem.color
        selectionColor: contrastingColor(color)
        visible: parent.visible && isSolid
    }
}
