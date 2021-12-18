import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

PopupModalBase {
    id: root

    property alias text: popupLabel.text

    closePolicy: Popup.CloseOnEscape

    ColumnLayout {
        spacing: 10

        width: parent.width

        LabelSubheading {
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

        ButtonFlat {
            Layout.alignment: Qt.AlignHCenter

            text: "OK"
            textColor: Style.accentColor
            onClicked: root.close()
        }
    }
}
