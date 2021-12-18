// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Button {
    id: button

    property alias textColor: buttonText.color

    focusPolicy: Qt.NoFocus
    leftPadding: 6
    rightPadding: 6

    Layout.minimumWidth: 88

    contentItem: Text {
        id: buttonText
        text: button.text
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
        color: button.pressed ? buttonText.color : "transparent"
        radius: 2
        opacity: button.pressed ? 0.12 : 1.0
    }
}
