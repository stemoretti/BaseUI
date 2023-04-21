import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Button {
    id: root

    property alias textColor: buttonText.color
    property alias buttonColor: buttonBackground.color

    focusPolicy: Qt.NoFocus
    leftPadding: 6
    rightPadding: 6

    contentItem: Text {
        id: buttonText
        text: root.text
        opacity: enabled ? 1.0 : 0.3
        color: Style.textOnPrimary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.capitalization: Font.AllUppercase
        font.weight: Font.Medium
    }

    background: Rectangle {
        id: buttonBackground
        implicitHeight: 48
        color: Style.primaryColor
        radius: 2
        opacity: root.pressed ? 0.75 : 1.0
    }
}
