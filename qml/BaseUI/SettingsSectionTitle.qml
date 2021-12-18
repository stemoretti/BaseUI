import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Label {
    leftPadding: 16
    topPadding: 6
    bottomPadding: 6
    font.bold: true
    font.pixelSize: Style.fontSizeBodyAndButton
    color: Style.isDarkTheme ? "white" : "black"

    background: Rectangle {
        color: Style.isDarkTheme ? Qt.darker("gray") : "lightgray"
    }

    Layout.fillWidth: true
}
