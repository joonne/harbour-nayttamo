import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: programoverviewpage

    property var program: ({})

    Component.onCompleted: {
        YleApi.getProgramById(program.seriesId);
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Program overview"), program.title, program.itemTitle)
    }

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: column.height
        contentWidth: column.width

        PullDownMenu {
            MenuItem {
                text: qsTr("Play")
                onClicked: pageStack.replace(Qt.resolvedUrl("PlayerPage.qml"), {
                                                 "program": program
                                             })
            }
        }

        Column {
            id: column
            x: Theme.horizontalPageMargin
            width: programoverviewpage.width - 2 * Theme.horizontalPageMargin

            PageHeader {
                id: header
                title: program.title
            }

            Image {
                id: programThumbnail
                sourceSize.width: parent.width
                anchors.left: parent.left
                source: program.image && program.image.id && program.image.available
                        ? "http://images.cdn.yle.fi/image/upload/w_" + parent.width + ",h_" + Math.floor((parent.width * 16) / 9) + ",c_fit/" + program.image.id + ".jpg"
                        : ""
            }

            Label {
                id: itemTitle
                color: Theme.primaryColor
                text: (program.itemTitle && program.itemTitle !== program.title) ? qsTr("Episode") + ": " + program.itemTitle : ""
                truncationMode: TruncationMode.Fade
                visible: text !== ""
                width: parent.width
            }
            Label {
                id: episode
                color: Theme.primaryColor
                text: YleApi.formatProgramDetails(program.seasonNumber, program.episodeNumber)
                truncationMode: TruncationMode.Fade
                visible: text !== ""
                width: parent.width
            }
            Label {
                id: time
                color: Theme.primaryColor
                text: qsTr("Released") + ": " + program.startTime
                width: parent.width
            }
            Label {
                id: duration
                color: Theme.primaryColor
                text: qsTr("Duration") + ": " + program.duration
                width: parent.width
            }

            TextArea {
                id: description
                color: Theme.secondaryColor
                readOnly: true
                wrapMode: TextEdit.WordWrap
                text: program.description
                width: parent.width
            }
        }
    }
}
