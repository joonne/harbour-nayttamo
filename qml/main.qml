import QtQuick 2.2
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: appWindow

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}

