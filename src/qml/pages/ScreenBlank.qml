import QtQuick 2.0
import Nemo.DBus 2.0

// Source: https://together.jolla.com/question/93323/harbour-api-request-keep-screen-onprevent-screen-blanking/?answer=154926#post-id-154926

Item {
    property bool enabled: false

    function request() {
        var method = "req_display" + (enabled ? "" : "_cancel") + "_blanking_pause";
        dbif.call(method, [])
    }

    onEnabledChanged: request()

    DBusInterface {
        id: dbif

        service: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        bus: DBusInterface.SystemBus
    }

    Timer { //request seems to time out after a while:
        running: parent.enabled
        interval: 15000 //minimum setting for blank display is 15s
        repeat: true
        onTriggered: parent.enabled && parent.request()
    }

    Component.onDestruction: enabled = false
}
