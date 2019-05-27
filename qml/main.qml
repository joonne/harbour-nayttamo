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
    property string playbackMode: "tv"

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

