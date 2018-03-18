import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var category: ({})

    Component.onCompleted: {
        console.log(category)
        YleApi.getProgramsByCategoryId(category.id)
            .then(function(programs) {
                console.log('programs', programs)
                listView.model = programs
            })
            .catch(function(error) {
                console.log('error', error)
                listView.model = []
            })
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: []
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Programs")
        }
        delegate: ListItem {
            id: listItem
            contentHeight: column.height + Theme.paddingMedium
            contentWidth: listView.width

            Column {
                id: column
                x: Theme.horizontalPageMargin

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
                    text: modelData.title
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                          "program": modelData
                                      })
        }
        VerticalScrollDecorator {}
    }
}
