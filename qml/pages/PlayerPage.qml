import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var program: ({})
    property bool overlayVisible: false
    property bool errorState: false

    onOverlayVisibleChanged: overlayVisible && overlayTimer.start()

    Connections {
        target: Qt.application
        onActiveChanged: !Qt.application.active ? video.pause() : video.play()
    }

    function initialize() {
        YleApi.getMediaUrl(program.id, program.mediaId)
            .then(function(url) {
                video.source = url
                video.play()
                YleApi.reportUsage(program.id, program.mediaId)
            })
            .catch(function(error) {
                console.log("mediaUrlError", JSON.stringify(error))
                errorState = true;
            })
    }

    function formatTime(milliseconds) {
        var minutes = YleApi.zeropad(String(Math.floor((milliseconds / 1000) / 60)), 2)
        var seconds = YleApi.zeropad(String(Math.floor((milliseconds / 1000) % 60)), 2)
        return minutes + ":" + seconds
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    ScreenBlank {
        enabled: video.playbackState === MediaPlayer.PlayingState
    }

    Timer {
        id: overlayTimer
        onTriggered: overlayVisible = false
        interval: 5000
        repeat: false
    }

    Video {
        id: video
        width : parent.width
        height : parent.height
        focus: true

        Component.onCompleted: initialize()

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
                        video.seek(video.position - 10000)
                        overlayTimer.restart()
                    }
                }
            }

            Image {
                id: play
                source: video.playbackState == MediaPlayer.PlayingState
                        ? "image://theme/icon-m-pause"
                        : "image://theme/icon-m-play"

                MouseArea {
                    anchors.fill: parent
                    onClicked: video.playbackState == MediaPlayer.PlayingState
                               ? video.pause()
                               : video.play()
                }
            }

            Image {
                id: forward
                source: "image://theme/icon-m-right"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.seek(video.position + 10000)
                        overlayTimer.restart()
                    }
                }
            }
        }

        Slider {
            width: parent.width
            maximumValue: 1.0
            value: video.position / video.duration
            valueText: formatTime(video.position)
            visible: overlayVisible

            anchors {
                bottom: parent.bottom
                left: parent.left
            }

            onSliderValueChanged: {
                down && video.seek(sliderValue * video.duration)
                overlayTimer.restart()
            }
        }

        BusyIndicator {
            anchors.centerIn: controls
            running: video.status === MediaPlayer.Loading || video.status === MediaPlayer.Buffering
        }

        Label {
            id: error
            anchors.centerIn: controls
            text: qsTr("Error loading media")
            visible: errorState
        }
    }
}
