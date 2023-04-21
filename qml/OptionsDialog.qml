import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: root

    property alias model: listView.model
    property alias delegate: listView.delegate

    parent: Overlay.overlay

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: Math.min(Math.max(header.implicitWidth, listView.contentItem.childrenRect.width), parent.width * 0.9)
    height: Math.min(implicitHeight + listView.contentHeight, parent.height * 0.9)

    padding: 0

    modal: true
    dim: true

    closePolicy: Popup.CloseOnEscape

    onClosed: listView.positionViewAtBeginning()

    contentItem: ColumnLayout {
        spacing: 0

        HorizontalListDivider {
            opacity: listView.contentY - listView.originY > 0 ? 1 : 0
            Behavior on opacity { NumberAnimation {} }
        }

        ListViewEdgeEffect {
            id: listView

            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        HorizontalListDivider {
            opacity: listView.contentHeight - listView.contentY - listView.height > 0 ? 1 : 0
            Behavior on opacity { NumberAnimation {} }
        }
    }

    footer: DialogButtonBox {
        alignment: Qt.AlignRight

        ButtonFlat {
            text: qsTr("Cancel")
            textColor: Style.accentColor
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }
    }
}
