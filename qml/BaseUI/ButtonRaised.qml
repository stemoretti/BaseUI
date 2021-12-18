import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Button {
    id: button

    property alias textColor: buttonText.color
    property alias buttonColor: buttonBackground.color

    focusPolicy: Qt.NoFocus
    leftPadding: 6
    rightPadding: 6

    Layout.minimumWidth: 80

    contentItem: Text {
        id: buttonText
        text: button.text
        opacity: enabled ? 1.0 : 0.3
        color: Style.textOnPrimary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.capitalization: Font.AllUppercase
    }

    background: Rectangle {
        id: buttonBackground
        implicitHeight: 48
        color: Style.primaryColor
        radius: 2
        opacity: button.pressed ? 0.75 : 1.0
        /*
        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 2
            horizontalOffset: 1
            color: dropShadow
            samples: button.pressed ? 20 : 10
            spread: 0.5
        }
        */
    }
}
