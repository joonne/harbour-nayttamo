import QtQuick 2.2
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: programoverviewpage

    property var program: ({})

    Component.onCompleted: {
        YleApi.getProgramById(program.seriesId);
    }

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                id: header
                title: program.title
            }

            Image {
                id: coverImage
                sourceSize.width: parent.width
                anchors.left: parent.left
                source: program.coverImage && program.coverImage.id && program.coverImage.available
                        ? "http://images.cdn.yle.fi/image/upload/" + program.coverImage.id + ".jpg"
                        : null
            }

            TextField {
                id: genre
                label: qsTr("Kuvaus")
                width: programoverviewpage.width
                text: "ASDASDASDASD"
                color: Theme.secondaryColor
                readOnly: true
            }
        }
    }
}
