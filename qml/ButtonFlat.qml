import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Button {
    id: root

    property alias textColor: buttonText.color

    focusPolicy: Qt.NoFocus
    leftPadding: 6
    rightPadding: 6

    contentItem: Text {
        id: buttonText
        text: root.text
        opacity: enabled ? 1.0 : 0.3
        color: Style.flatButtonTextColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.capitalization: Font.AllUppercase
        font.weight: Font.Medium
    }

    background: Rectangle {
        id: buttonBackground
        implicitHeight: 48
        color: root.pressed ? buttonText.color : "transparent"
        radius: 2
        opacity: root.pressed ? 0.12 : 1.0
    }
}
