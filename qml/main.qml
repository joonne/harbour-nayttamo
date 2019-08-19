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

    property var state: null

    onStateChanged: {
        if (state === null) {
            console.log('initialization, do not set the state')
            return
        }
        serializer.setState(state)
    }

    Component.onCompleted: {
        state = serializer.getState()
    }

    function setState(path, value) {
        function setStateRecursive(obj, path, value) {
            if (!Array.isArray(path)) {
                path = path.split('.')
            }

            if (path.length === 1) {
                obj[path[0]] = value
                return
            }

            if (!obj[path[0]]) {
                obj[path[0]] = {}
            }

            return setStateRecursive(obj[path[0]], path.slice(1), value)
        }

        var newState = JSON.parse(JSON.stringify(state))
        console.log('start', JSON.stringify(newState))
        setStateRecursive(newState, path, value)
        console.log("done", JSON.stringify(newState))
        state = newState
    }

    function insertStartedProgram(program) {
        setState('startedPrograms.' + program.id, program.progress)
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
