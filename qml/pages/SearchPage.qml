import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: searchpage
    property int offset: 0
    property int limit: 25
    property bool programsEnd: false

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    onVisibleChanged: {
        if (visible) updateCover(qsTr("Search"), searchField.text, "")
    }
    Component.onDestruction: {
        listView.model.clear()
    }

    function search(text) {
        updateCover(qsTr("Search"), searchField.text, "")
        YleApi.search(searchField.text, limit, offset)
            .then(function(programs) {
                if (programs.length < limit) {
                    programsEnd = true
                }

                for (var i = 0; i < programs.length; i++) {
                    listView.model.append({value: programs[i]});
                }
            })
            .catch(function() {
                listView.model.clear()
            })
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
        placeholderText: qsTr("Search for a program")
        EnterKey.onClicked: {
            textDebounce.stop()
            search(text)
            focus = false
        }

        onTextChanged: {
            if (text.length > 0) {
                offset = 0;
                listView.model.clear();
                textDebounce.start()
            } else {
                offset = 0;
                listView.model.clear();
            }
        }
    }

    SilicaListView {
        id: listView
        anchors.top: searchField.bottom
        currentIndex: -1
        height: (searchpage.height - searchField.height - Theme.paddingLarge)
        width: searchpage.width
        clip: true
        model: ListModel { id: programsModel }

        onAtYEndChanged: {
            if (atYEnd && listView.count > 0 && !programsEnd) {
                offset += limit;
                search(searchField.text);
            }
        }

        delegate: ProgramDelegate{}

        VerticalScrollDecorator {
            id: decorator
        }

        ViewPlaceholder {
            enabled: listView.count === 0
            text: qsTr("Here will be stuff when you search for something")
            anchors.centerIn: listView
        }
    }
}
