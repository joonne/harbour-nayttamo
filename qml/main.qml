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

    function updateCover(newCoverMode, newCoverTitle, newCoverSubtitle) {
        coverMode = newCoverMode
        coverTitle = newCoverTitle
        coverSubTitle = newCoverSubtitle
    }

    MediaPlayer {
        id: mediaPlayer
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}

