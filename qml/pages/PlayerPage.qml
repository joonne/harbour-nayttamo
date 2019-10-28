import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var program: ({})
    property bool overlayVisible: false
    property bool errorState: false
    property string subtitlesUrl
    property var subtitles: ([])

    onOverlayVisibleChanged: overlayVisible && overlayTimer.start()

    Connections {
        target: Qt.application
        onActiveChanged: !Qt.application.active ? mediaPlayer.pause() : mediaPlayer.play()
    }

    Connections {
        target: mediaPlayer
        onPositionChanged: {
            if (page && page.subtitles && subtitlesText) {
                subtitlesText && subtitlesText.checkSubtitles()
            }
        }
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Now playing"), program.title, program.itemTitle)
    }

    function initialize() {
        var protocol =  playbackMode === "radio" ? "PMD" : "HLS"
        YleApi.getMediaUrl(program.id, program.mediaId, protocol)
            .then(function(response) {
                if (response.subtitlesUrl && subtitlesText) {
                    subtitlesUrl = response.subtitlesUrl
                    subtitlesText.getSubtitles(subtitlesUrl)
                }
                console.log("playbackMode", playbackMode, JSON.stringify(response))
                mediaPlayer.source = response.url
                mediaPlayer.play()
                YleApi.reportUsage(program.id, program.mediaId)
            })
            .catch(function(error) {
                console.log("mediaUrlError", JSON.stringify(error))
                errorState = true;
            })
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    ScreenBlank {
        enabled: mediaPlayer.playbackState === MediaPlayer.PlayingState
    }

    Timer {
        id: overlayTimer
        onTriggered: overlayVisible = false
        interval: 5000
        repeat: false
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    VideoOutput {
        id: videoOutput
        width : parent.width
        height : parent.height
        focus: true
        source: mediaPlayer

        Component.onCompleted: initialize()
        Component.onDestruction: {
            mediaPlayer.stop()
            mediaPlayer.source = ""
        }

        MouseArea {
            anchors.fill: parent
            onClicked: !errorState && (overlayVisible = !overlayVisible)
        }

        Row {
            id: controls
            anchors.centerIn: parent
            spacing: (parent.width - play.width - forward.width - backward.width) / 4
            visible: overlayVisible

            Image {
                id: backward
                source: "image://theme/icon-m-left"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mediaPlayer.seek(mediaPlayer.position - 10000)
                        overlayTimer.restart()
                    }
                }
            }

            Image {
                id: play
                source: mediaPlayer.playbackState === MediaPlayer.PlayingState
                        ? "image://theme/icon-m-pause"
                        : "image://theme/icon-m-play"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mediaPlayer.playbackState === MediaPlayer.PlayingState
                            ? mediaPlayer.pause()
                            : mediaPlayer.play()

                        if (subtitlesUrl && subtitlesText) {
                            subtitlesText.getSubtitles(subtitlesUrl)
                        }
                    }
                }
            }

            Image {
                id: forward
                source: "image://theme/icon-m-right"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mediaPlayer.seek(mediaPlayer.position + 10000)
                        overlayTimer.restart()
                    }
                }
            }
        }

        Slider {
            id: slider
            width: parent.width
            maximumValue: 1.0
            value: mediaPlayer.position / mediaPlayer.duration
            valueText: YleApi.formatTime(mediaPlayer.position)
            visible: overlayVisible

            anchors {
                bottom: parent.bottom
                left: parent.left
            }

            onSliderValueChanged: {
                down && mediaPlayer.seek(sliderValue * mediaPlayer.duration)
                overlayTimer.restart()
            }
        }

        BusyIndicator {
            anchors.centerIn: controls
            running: mediaPlayer.status === MediaPlayer.Loading || mediaPlayer.status === MediaPlayer.Buffering
        }

        Label {
            id: error
            anchors.centerIn: controls
            text: qsTr("Error loading media")
            visible: errorState
        }
    }

    SubtitlesItem {
        id: subtitlesText
        anchors { fill: parent; margins: page.orientation === Orientation.Portrait ? 10 : 50; }
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: overlayVisible ? Text.AlignTop : Text.AlignBottom
        pixelSize: Theme.fontSizeMedium
        bold: true
        color: "#FFFFFF"
        visible: subtitles ? true : false
    }
}
