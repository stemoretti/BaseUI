import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    property alias pageStack: stackView
    property alias initialPage: stackView.initialItem

    visible: true
    locale: Qt.locale("en_US")

    header: stackView.currentItem ? stackView.currentItem.appToolBar : null

    StackView {
        id: stackView

        anchors.fill: parent

        onCurrentItemChanged: {
            // make sure that the phone physical back button will get key events
            currentItem.forceActiveFocus()
        }
    }

    Material.primary: Style.primaryColor
    Material.accent: Style.accentColor
    Material.theme: Style.isDarkTheme ? Material.Dark : Material.Light
}
