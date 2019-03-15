import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var category: ({})
    property int offset: 0
    property int limit: 25
    property bool programsEnd: false

    function getPrograms() {
        YleApi.getProgramsByCategoryId(category.id, limit, offset)
            .then(function(programs) {
                if (programs.length < limit) {
                    programsEnd = true
                }

                for (var i = 0; i < programs.length; i++) {
                    listView.model.append({value: programs[i]});
                }
            })
            .catch(function(error) {
                console.log('error', error)
            })
    }

    Component.onCompleted: {
        console.log(category.title)
        getPrograms();
    }

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Category"), category.title, "")
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel { id: programsModel }
        currentIndex: -1
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Programs")
        }

        onAtYEndChanged: {
            if (atYEnd && listView.count > 0 && !programsEnd) {
                offset += limit;
                getPrograms();
            }
        }

        delegate: ProgramDelegate {}

        VerticalScrollDecorator {}
    }
}
