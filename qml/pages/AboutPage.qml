import QtQuick 2.0
import Sailfish.Silica 1.0

import '../components'

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

            PageHeader {
                title: qsTr("About")
            }

            Image {
                id: icon
                source: "image://theme/harbour-nayttamo"
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - icon.width) / 2
            }

            HorizontalSeparator { }

            Label {
                id: appname
                text: "Näyttämö"
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - appname.width) / 2
                color: Theme.primaryColor
            }

            Label {
                id: version
                text: qsTr("Version %1.%2").arg(_APP_VERSION).arg(_APP_BUILD_NUMBER)
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - version.width) / 2
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            HorizontalSeparator { }

            SectionHeader {
                text: qsTr("General")
            }

            TextArea {
                width: aboutpage.width
                readOnly: true
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Native YLE Areena for Sailfish OS")
            }

            HorizontalSeparator { }

            SectionHeader {
                text: qsTr("Contributors")
            }

            Repeater {

                model: ["joonne", "mlehtima"]

                TextField {
                    width: aboutpage.width
                    readOnly: true
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: modelData
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
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - yledeveloper.width) / 2
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
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - sourcecode.width) / 2
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
                anchors.left: parent.left
                anchors.leftMargin: (aboutpage.width - sourcecode.width) / 2
            }

            HorizontalSeparator { }
        }

        VerticalScrollDecorator { }
    }
}
