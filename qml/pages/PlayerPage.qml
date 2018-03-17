import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.5

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var program: ({})

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Video {
        id: video
        width : parent.width
        height : parent.height

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
            }
        }

        focus: true
        Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
        Keys.onLeftPressed: video.seek(video.position - 5000)
        Keys.onRightPressed: video.seek(video.position + 5000)

        Component.onCompleted: {
            console.log(JSON.stringify(program))
            YleApi.getMediaUrl(program.id, program.mediaId)
                .then(function(url) {
                    video.source = url
                    video.play()
                    YleApi.reportUsage(program.id, program.mediaId)
                })
                .catch(function(error) {
                    console.log("mediaUrlError", JSON.stringify(error));
                })
        }
    }
}
