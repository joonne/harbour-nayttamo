import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: aboutpage

    readonly property string _APP_VERSION: appVersion
    readonly property string _APP_BUILD_NUMBER: appBuildNum

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            bottomPadding: Theme.horizontalPageMargin

            PageHeader {
                title: qsTr("About")
            }

            Image {
                id: icon
                source: "image://theme/harbour-nayttamo"
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeLarge
                height: Theme.iconSizeLarge
            }

            Label {
                id: appname
                text: qsTr("Näyttämö")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
            }

            Label {
                id: version
                text: qsTr("Version %1.%2").arg(_APP_VERSION).arg(_APP_BUILD_NUMBER)
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            SectionHeader {
                text: qsTr("General")
            }

            TextArea {
                id: description
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Native YLE Areena for Sailfish OS")
            }

            SectionHeader {
                text: qsTr("Contributors")
            }

            Repeater {

                model: ["joonne", "mlehtima"]

                Label {
                    width: aboutpage.width
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: modelData
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                }
            }

            SectionHeader {
                text: qsTr("Licence")
            }

            TextArea {
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("This software is licenced mostly under MIT. Some parts of the application are licenced under the BSD.")
            }

            SectionHeader {
                text: qsTr("Content")
            }

            TextArea {
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Näyttämö utilises YLE API")
            }

            Button {
                id: yledeveloper
                text: "YLE API"
                onClicked: Qt.openUrlExternally("https://developer.yle.fi/")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                text: qsTr("Source Code")
            }

            TextArea {
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("The source code is available at GitHub. Contributions, ideas and bug reports are welcome.")
            }

            Button {
                id: sourcecode
                text: qsTr("Project in GitHub")
                onClicked: Qt.openUrlExternally("https://github.com/joonne/harbour-nayttamo")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                text: qsTr("Translations")
            }

            TextArea {
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Näyttämö uses the Transifex translation platform to host the translations.")
            }

            Button {
                id: transifex
                text: qsTr("Help with translations")
                onClicked: Qt.openUrlExternally("https://www.transifex.com/joonne/nayttamo/")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        VerticalScrollDecorator { }
    }
}
