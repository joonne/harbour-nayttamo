import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

CoverBackground {
    id: coverPage
    Label {
        id: label
        color: Theme.primaryColor
        font.bold: true
        text: qsTr("Näyttämö")
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.paddingMedium
        }
    }

    Column {
        width: parent.width - 2 * Theme.paddingSmall
        anchors.centerIn: parent
        Label {
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeExtraSmall
            horizontalAlignment: Text.AlignHCenter
            text: coverMode
            truncationMode: TruncationMode.Fade
            width: parent.width
        }
        Label {
            color: Theme.primaryColor
            horizontalAlignment: Text.AlignHCenter
            text: coverTitle
            truncationMode: TruncationMode.Fade
            width: parent.width
        }
        Label {
            color: Theme.secondaryColor
            horizontalAlignment: Text.AlignHCenter
            text: coverTitle !== coverSubTitle ? coverSubTitle : ""
            truncationMode: TruncationMode.Fade
            width: parent.width
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            text: YleApi.formatTime(mediaPlayer.position) + "/" + YleApi.formatTime(mediaPlayer.duration)
            visible: mediaPlayer.source.toString() !== ""
        }
    }
}

