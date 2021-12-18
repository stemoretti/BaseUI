import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import BaseUI 1.0

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

        Image {
            id: alarmIcon

            smooth: true
            source: Icons.error + "color=white"
            sourceSize.width: 36
            sourceSize.height: 36
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
