import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

ListItem {
    id: listItem
    contentWidth: ListView.view.width
    contentHeight: Theme.itemSizeLarge

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Show program info")
            onClicked: pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                          "program": modelData
                                      })
        }
    }

    Item {
        height: parent.height - 2 * Theme.paddingSmall
        width: parent.width - 2 * Theme.paddingMedium
        anchors.centerIn: parent

        Rectangle {
            id: img
            color: "black"
            height: parent.height
            width: Math.ceil((height * 16) / 9)
            Image {
                x: 0
                y: 0
                opacity: 1.0
                sourceSize.width: parent.width
                sourceSize.height: parent.height
                source: modelData.image && modelData.image.id && modelData.image.available
                        ? "http://images.cdn.yle.fi/image/upload/w_" + parent.width + ",h_" + parent.height + ",c_fit/" + modelData.image.id + ".jpg"
                        : null
            }
            anchors.left: parent.left
        }

        Label {
            id: title
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
            text: modelData.title ? modelData.title : ""
            font.bold: true
            font.pixelSize: Theme.fontSizeExtraSmall
            truncationMode: TruncationMode.Fade
            anchors {
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
                bottom: img.bottom
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
                right: parent.right
                baseline: time.baseline
            }
        }
    }
    onClicked: pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                  "program": modelData
                              })
}
