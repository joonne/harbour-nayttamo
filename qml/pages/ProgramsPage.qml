import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    property var category: ({})
    property var series: ({})

    property int offset: 0
    property int limit: 25
    property bool programsEnd: false

    function appendProgramsToList(programs) {
        if (programs.length < limit) {
            programsEnd = true
        }

        for (var i = 0; i < programs.length; i++) {
            listView.model.append({value: programs[i]});
        }
    }

    function getPrograms() {
        if (category.id) {
            YleApi.getProgramsByCategoryId(category.id, limit, offset)
                .then(appendProgramsToList)
                .catch(function(error) {
                    console.log('error', error)
                })
        } else if (series.seriesId) {
            YleApi.getProgramsBySeriesId(series.seriesId, limit, offset)
                .then(appendProgramsToList)
                .catch(function(error) {
                    console.log('error', error)
                })
        }
    }

    Component.onCompleted: {
        getPrograms();
    }

    onVisibleChanged: {
        if (visible) updateCover(category.title ? qsTr("Category") : qsTr("Series"), category.title ? category.title : series.title, "")
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

        delegate: ProgramDelegate {
            showSeriesMenuItem: false
        }

        VerticalScrollDecorator {}
    }
}
