import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    Component.onCompleted: {
        updateCover(qsTr("Current Broadcasts"), "", "")
        YleApi.getCurrentBroadcasts()
            .then(function(broadcasts) {
                listView.model = broadcasts
            })
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Current Broadcasts"), "", "")
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Search")
                onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
            }
            MenuItem {
                text: qsTr("Categories")
                onClicked: pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
            }
        }

        SilicaListView {
            id: listView
            model: []
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("Current Broadcasts")
            }
            delegate: ListItem {
                id: listItem
                contentHeight: column.height + Theme.paddingMedium
                contentWidth: listView.width

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Show program info")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                               "program": modelData
                                           })
                        }
                    }
                }

                Column {
                    id: column
                    x: Theme.horizontalPageMargin
                    width: page.width - 2 * Theme.horizontalPageMargin

                    Image {
                        id: programThumbnail
                        sourceSize.width: parent.width
                        anchors.left: parent.left
                        source: modelData.image && modelData.image.id && modelData.image.available
                                ? "http://images.cdn.yle.fi/image/upload/w_" + parent.width + ",h_" + Math.floor(parent.width * 16 / 9) + ",c_fit/" + modelData.image.id + ".jpg"
                                : ""
                    }

                    Label {
                        width: parent.width
                        truncationMode: TruncationMode.Fade
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
}

