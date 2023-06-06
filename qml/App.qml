import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ApplicationWindow {
    id: root

    property alias initialPage: stackView.initialItem

    visible: true
    locale: Qt.locale("en_US")

    header: stackView.currentItem?.appToolBar

    StackView {
        id: stackView

        anchors.fill: parent

        // make sure that the phone physical back button will get key events
        onCurrentItemChanged: stackView.currentItem.forceActiveFocus()
    }

    Material.primary: Style.primaryColor
    Material.accent: Style.accentColor
    Material.theme: Style.theme == "System"
        ? Material.System
        : (Style.theme == "Dark" ? Material.Dark : Material.Light)
}
