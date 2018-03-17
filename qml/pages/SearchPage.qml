import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: searchpage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Component.onDestruction: {
        listView.model = []
    }

    function search(text) {
        YleApi.search(searchField.text)
            .then(function(programs) {
                listView.model = programs
            })
            .catch(function() {
                listView.model = []
            })
    }

    function formatProgramDetails(seasonNumber, episodeNumber) {
        if (seasonNumber && episodeNumber) {
            return qsTr("Kausi %1 Jakso %2").arg(seasonNumber).arg(episodeNumber)
        } else if (seasonNumber) {
            return qsTr("Kausi %1").arg(seasonNumber)
        } else if (episodeNumber) {
            return qsTr("Jakso %1").arg(episodeNumber)
        }
        return qsTr("Kausi - Jakso -")
    }

    Timer {
        id: textDebounce
        interval: 1000
        onTriggered: search(searchField.text)
    }

    SearchField {
        id: searchField
        width: searchpage.width
        anchors {
            top: searchpage.top
            topMargin: (Theme.paddingLarge * 4)
        }
        placeholderText: qsTr("Etsi ohjelmaa")
        EnterKey.onClicked: {
            search(text)
            focus = false
        }

        onTextChanged: {
            if (text.length > 0) {
                textDebounce.start()
            } else {
                listView.model = []
            }
        }
    }

    SilicaListView {
        id: listView
        anchors.top: searchField.bottom
        height: (searchpage.height - searchField.height - Theme.paddingLarge)
        width: searchpage.width
        clip: true
        model: []

        delegate: ListItem {
            id: listItem
            contentHeight: column.height + Theme.paddingMedium
            contentWidth: listView.width
            onClicked: {
                pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                   "program": modelData
                               })
            }

            Column {
                id: column
                x: Theme.paddingLarge

                Image {
                    id: programThumbnail
                    sourceSize.width: parent.width
                    anchors.left: parent.left
                    source: modelData.image && modelData.image.id && modelData.image.available
                            ? "http://images.cdn.yle.fi/image/upload/" + modelData.image.id + ".jpg"
                            : null
                }

                Label {
                    id: title
                    text: modelData.title + " Kausi " + modelData.seasonNumber + " Jakso " + modelData.episodeNumber
                    width: listItem.width - (2 * Theme.paddingLarge)
                    truncationMode: TruncationMode.Fade
                    color: Theme.primaryColor
                }

                Label {
                    id: episode
                    text: formatProgramDetails(modelData.seasonNumber, modelData.episodeNumber)
                    width: listItem.width - (2 * Theme.paddingLarge)
                    truncationMode: TruncationMode.Fade
                    color: Theme.primaryColor
                }
            }
        }

        VerticalScrollDecorator {
            id: decorator
        }

        ViewPlaceholder {
            enabled: listView.count === 0
            text: qsTr("Tänne ilmestyy tavaraa kun etsit jotain")
            anchors.centerIn: listView

        }
    }
}
