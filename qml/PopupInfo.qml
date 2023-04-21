import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: root

    property alias text: popupLabel.text

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    modal: true
    dim: true

    closePolicy: Popup.CloseOnEscape

    contentItem: LabelSubheading {
        id: popupLabel

        Layout.fillWidth: true

        topPadding: 20
        leftPadding: 8
        rightPadding: 8
        color: Style.popupTextColor
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        linkColor: Style.isDarkTheme ? "lightblue" : "blue"
        onLinkActivated: Qt.openUrlExternally(link)
    }

    footer: DialogButtonBox {
        alignment: Qt.AlignHCenter
        standardButtons: DialogButtonBox.Ok

        onAccepted: root.close()

        ButtonFlat {
            text: "OK"
            textColor: Style.accentColor
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }
}
