import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window

Popup {
    id: root

    function start(toastText) {
        toastLabel.text = toastText
        if (!toastTimer.running)
            open()
        else
            toastTimer.restart()
    }

    x: (parent.width - width) / 2
    y: (parent.height - height)

    closePolicy: Popup.CloseOnPressOutside
    bottomMargin: Screen.primaryOrientation === Qt.LandscapeOrientation ? 24 : 80

    background: Rectangle {
        color: Style.toastColor
        radius: 24
        opacity: Style.toastOpacity
    }

    onAboutToShow: toastTimer.start()
    onAboutToHide: toastTimer.stop()

    Timer {
        id: toastTimer

        interval: 3000
        repeat: false

        onTriggered: root.close()
    }

    Label {
        id: toastLabel

        width: parent.width
        leftPadding: 16
        rightPadding: 16
        font.pixelSize: 16
        color: "white"
        wrapMode: Label.WordWrap
    }
}
