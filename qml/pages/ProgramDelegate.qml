import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

ListItem {
    id: listItem
    contentWidth: ListView.view.width
    contentHeight: listContainer.height + 2 * Theme.paddingSmall

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Show program info")
            onClicked: pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                          "program": modelData
                                      })
        }
        MenuItem {
            visible: Boolean(modelData.seriesId)
            text: qsTr("Show programs in series")

            onClicked: pageStack.push(Qt.resolvedUrl("ProgramsPage.qml"), {
                                          "series": modelData
                                      })
        }
    }

    Item {
        id: listContainer
        height: title.height + episode.height + time.height
        width: parent.width - 2 * Theme.paddingMedium
        anchors.centerIn: parent

        Image {
            id: img
            height: parent.height
            width: Math.ceil((height * 16) / 9)
            opacity: 1.0
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            source: modelData.image && modelData.image.id && modelData.image.available
                    ? "http://images.cdn.yle.fi/image/upload/w_" + parent.width + ",h_" + parent.height + ",c_fit/" + modelData.image.id + ".jpg"
                    : ""
            BusyIndicator {
                anchors.centerIn: parent
                size: BusyIndicatorSize.Medium
                running: parent.status !== Image.Ready && parent.status !== Image.Error
                visible: running
            }
            Image {
                anchors.centerIn: parent
                visible: parent.status === Image.Error
                source: "image://theme/icon-m-image"
            }
        }

        Label {
            id: title
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            text: modelData.title ? modelData.title : ""
            font.bold: true
            font.pixelSize: Theme.fontSizeExtraSmall
            truncationMode: TruncationMode.Fade
            anchors {
                top: parent.top
                left: img.right
                right: parent.right
                leftMargin: Theme.paddingMedium
            }
        }

        Label {
            id: episode
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            text: modelData.shortDescription ? modelData.shortDescription : YleApi.formatProgramDetails(modelData.seasonNumber, modelData.episodeNumber)
            font.pixelSize: Theme.fontSizeExtraSmall
            truncationMode: TruncationMode.Fade
            visible: text !== ""
            anchors {
                left: img.right
                top: title.bottom
                right: parent.right
                leftMargin: Theme.paddingMedium
            }
        }
        Label {
            id: time
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            text: modelData.startTime
            font.pixelSize: Theme.fontSizeTiny
            anchors {
                top: episode.bottom
                left: img.right
                leftMargin: Theme.paddingMedium
            }
        }
        Label {
            id: duration
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            text: modelData.duration
            font.pixelSize: Theme.fontSizeTiny
            visible: text !== ""
            anchors {
                top: time.top
                right: parent.right
            }
        }
    }
    onClicked: pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                  "program": modelData
                              })
}
