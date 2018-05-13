import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var category: ({})
    property int offset: 0
    property int limit: 25

    function getPrograms() {
        YleApi.getProgramsByCategoryId(category.id, limit, offset)
            .then(function(programs) {
                console.log('programs', programs)
                listView.model = programs
            })
            .catch(function(error) {
                console.log('error', error)
                listView.model = []
            })
    }

    Component.onCompleted: {
        console.log(category)
        getPrograms();
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Category"), category.title, "")
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

        PullDownMenu {
            MenuItem {
                text: qsTr("Previous page")
                enabled: offset > 0
                onClicked: {
                    console.log("Previous page")
                    offset -= limit;
                    getPrograms();
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Next page")
                enabled: listView.count === limit
                onClicked: {
                    console.log("Next page", listView.count, offset, limit)
                    offset += limit;
                    getPrograms();
                }
            }
        }

        delegate: ProgramDelegate {}

        VerticalScrollDecorator {}
    }
}
