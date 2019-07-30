import QtQuick 2.2
import Sailfish.Silica 1.0
import QtMultimedia 5.5

import "pages"

ApplicationWindow
{
    id: appWindow

    property string coverMode: ""
    property string coverTitle: ""
    property string coverSubTitle: ""

    property var state: ({
                             startedPrograms: {}
                         })
    onStateChanged: serializer.setState(state)

    Component.onCompleted: {
        state = serializer.getState()
    }

    function setState(obj, path, value) {
        if (!Array.isArray(path)) path = path.split('.')
        if (path.length === 1) return obj[path[0]] = value
        if (!obj[path[0]]) obj[path[0]] = {}
        return setState(obj[path[0]], path.slice(1), value)
    }

    function insertStartedProgram(program) {
        setState(state, 'startedPrograms.' + program.id, program.progress)
    }

    function updateCover(newCoverMode, newCoverTitle, newCoverSubtitle) {
        coverMode = newCoverMode ? newCoverMode : ""
        coverTitle = newCoverTitle ? newCoverTitle : ""
        coverSubTitle = newCoverSubtitle ? newCoverSubtitle : ""
    }

    MediaPlayer {
        id: mediaPlayer
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}

