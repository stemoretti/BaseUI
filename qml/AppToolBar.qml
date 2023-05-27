import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

ToolBar {
    id: root

    property Action leftButton
    property list<Action> rightButtons

    property alias title: titleLabel.text

    Material.background: Style.toolBarBackground

    RowLayout {
        focus: false
        spacing: 0
        anchors { fill: parent; leftMargin: 4; rightMargin: 4 }

        ToolButton {
            icon.source: root.leftButton?.icon.source ?? ""
            icon.color: Style.toolBarForeground
            focusPolicy: Qt.NoFocus
            opacity: Style.opacityTitle
            enabled: root.leftButton && root.leftButton.enabled
            onClicked: root.leftButton.trigger()
        }
        LabelTitle {
            id: titleLabel
            elide: Label.ElideRight
            color: Style.toolBarForeground
            Layout.fillWidth: true
        }
        Repeater {
            model: root.rightButtons.length
            delegate: ToolButton {
                icon.source: root.rightButtons[index].icon.source
                icon.color: Style.toolBarForeground
                focusPolicy: Qt.NoFocus
                opacity: Style.opacityTitle
                enabled: root.rightButtons[index].enabled
                onClicked: root.rightButtons[index].trigger()
            }
        }
    }
}
