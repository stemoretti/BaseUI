import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window

import BaseUI as UI

Popup {
    id: root

    function start(errorText) {
        errorLabel.text = errorText
        if (!errorTimer.running)
            open()
        else
            errorTimer.restart()
    }

    closePolicy: Popup.CloseOnPressOutside
    bottomMargin: Screen.primaryOrientation === Qt.LandscapeOrientation ? 24 : 80
    implicitWidth: Screen.primaryOrientation === Qt.LandscapeOrientation ? parent.width * 0.50 : parent.width * 0.80

    x: (parent.width - implicitWidth) / 2
    y: (parent.height - height)

    background: Rectangle {
        color: Material.color(Material.Red, Style.isDarkTheme ? Material.Shade500 : Material.Shade800)
        radius: 24
        opacity: Style.toastOpacity
    }

    onAboutToShow: errorTimer.start()
    onAboutToHide: errorTimer.stop()

    Timer {
        id: errorTimer

        interval: 3000
        repeat: false

        onTriggered: root.close()
    }

    RowLayout {
        width: parent.width

        Icon {
            width: 36
            height: 36
            icon: UI.Icons.error
            color: "white"
        }

        Label {
            id: errorLabel

            Layout.fillWidth: true
            Layout.preferredWidth: 1

            rightPadding: 24
            font.pixelSize: 16
            color: "white"
            wrapMode: Label.WordWrap
        }
    }
}
