import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page
    property real rowCount
    property real columnCount: isPortrait ? 1.0 : 2.0
    property real offsetY
    property int imageSizeX
    property int imageSizeY

    Component.onCompleted: {
        // This prevents image reload on orientation change
        imageSizeX = Math.min(width, height)
        imageSizeY = Math.floor(imageSizeX / 16.0 * 9.0)
        updateBroadcasts()
    }

    function updateBroadcasts() {
        gridView.model = []
        updateCover(qsTr("Current Broadcasts"), "", "")
        YleApi.getCurrentBroadcasts()
            .then(function(broadcasts) {
                gridView.model = broadcasts
                gridView.currentIndex = -1
            })
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Current Broadcasts"), "", "")
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    onOrientationChanged: rowCount = Math.ceil(gridView.model.length / columnCount)

    SilicaGridView {
        id: gridView
        property int previousIndex: -1
        property int firstOffsetIndex: -1
        model: []
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Current Broadcasts")
        }

        // To enable PullDownMenu, place our content in a SilicaFlickable
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: updateBroadcasts()
            }
            MenuItem {
                text: qsTr("Search")
                onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
            }
            MenuItem {
                text: qsTr("Categories")
                onClicked: pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
            }
        }

        onModelChanged: rowCount = Math.ceil(model.length / columnCount)

        // Cell width and height depend on columnCount, which depends on orientation
        cellWidth: page.width / columnCount
        cellHeight: page.width / columnCount / 16.0 * 9.0 + Theme.fontSizeMedium + Theme.paddingMedium

        delegate: ListItem {

            id: listItem
            width: page.width / columnCount
            height: gridView.cellHeight + (index === gridView.currentIndex | index === gridView.previousIndex ? offsetY : 0.0)
            contentWidth: width
            contentHeight: height
            enabled: gridView.currentIndex === index | gridView.currentIndex === -1

            Image {
                id: programThumbnail
                y: index >= gridView.firstOffsetIndex ? offsetY : 0.0
                width: parent.width
                height: width / 16.0 * 9.0
                sourceSize.width: imageSizeX
                sourceSize.height: imageSizeY
                source: modelData.image && modelData.image.id && modelData.image.available
                        ? "http://images.cdn.yle.fi/image/upload/w_" + imageSizeX + ",h_" + imageSizeY + ",c_fit/" + modelData.image.id + ".jpg"
                        : ""
                Image {
                    anchors.centerIn: parent
                    visible: parent.status === Image.Error
                    source: "image://theme/icon-l-image"
                }
            }

            Label {
                id: programLabel
                x: Theme.paddingSmall
                anchors.top: programThumbnail.bottom
                width: programThumbnail.width
                truncationMode: TruncationMode.Fade
                text: modelData.title
                font.pixelSize: Theme.fontSizeMedium
            }

            menu: ContextMenu {
                id: contextMenu

                // Using offsetY the listItem size changes dynamically.
                onHeightChanged: offsetY = height

                onActiveChanged: {
                    // When menu starts to open:
                    if(active) {
                        gridView.firstOffsetIndex = index + columnCount - index % columnCount
                        gridView.currentIndex = index
                        gridView.previousIndex = index
                    }
                    // When menu starts to close:
                    else {
                        gridView.currentIndex = -1
                    }
                }

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

            onClicked: {
                pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                   "program": modelData
                               })
            }
        }
        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: gridView.count === 0
            text: qsTr("No current broadcasts")
        }
    }
}

