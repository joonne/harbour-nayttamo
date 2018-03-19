import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: searchpage
    property int offset: 0
    property int limit: 25

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Component.onDestruction: {
        listView.model = []
    }

    function search(text) {
        YleApi.search(searchField.text, limit, offset)
            .then(function(programs) {
                listView.model = programs
            })
            .catch(function() {
                listView.model = []
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
                    search(searchField.text);
                }
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
