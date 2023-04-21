import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Label {
    leftPadding: 16
    topPadding: 6
    bottomPadding: 6
    font.bold: true
    font.pixelSize: Style.fontSizeBodyAndButton
    color: Style.isDarkTheme ? "white" : Qt.lighter("gray", 1.1)

    background: Rectangle {
        color: Style.isDarkTheme ? Qt.darker("gray") : Qt.lighter("lightgray", 1.1)
    }

    Layout.fillWidth: true
}
