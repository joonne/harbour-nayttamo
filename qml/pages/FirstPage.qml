/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/yleApi.js" as YleApi

Page {
    id: page

    Component.onCompleted: {
        YleApi.getCurrentBroadcasts()
            .then(function(broadcasts) {
                listView.model = broadcasts
            })
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Haku")
                onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
            }
            MenuItem {
                text: qsTr("Kategoriat")
                onClicked: pageStack.push(Qt.resolvedUrl("CategoriesPage.qml"))
            }
        }

        SilicaListView {
            id: listView
            model: []
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("Nykyiset lähetykset")
            }
            delegate: ListItem {
                id: listItem
                contentHeight: column.height + Theme.paddingMedium
                contentWidth: listView.width

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Näytä ohjelman tiedot")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("ProgramOverviewPage.qml"), {
                                               "program": modelData
                                           })
                        }
                    }
                }

                Column {
                    id: column
                    x: Theme.horizontalPageMargin

                    Image {
                        id: programThumbnail
                        sourceSize.width: parent.width
                        anchors.left: parent.left
                        source: modelData.image && modelData.image.id && modelData.image.available
                                ? "http://images.cdn.yle.fi/image/upload/" + modelData.image.id + ".jpg"
                                : null
                    }

                    Label {
                        text: modelData.title
                    }
                }
                onClicked: pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                              "program": modelData
                                          })
            }
            VerticalScrollDecorator {}
        }
    }
}

