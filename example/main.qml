import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import BaseUI as UI

UI.App {
    id: root

    width: 640
    height: 480

    property string primary: Material.primary
    property string accent: Material.accent
    property bool theme: false

    initialPage: UI.AppStackPage {
        id: homePage

        title: "HomePage"

        leftButton: Action {
            icon.source: UI.Icons.menu
            onTriggered: navDrawer.open()
        }

        rightButtons: [
            Action {
                icon.source: UI.Icons.more_vert
                onTriggered: optionsMenu.open()
            }
        ]

        Pane {
            id: mainPane

            anchors.fill: parent

            ColumnLayout {
                width: parent.width

                UI.LabelBody {
                    leftPadding: 10
                    rightPadding: 10
                    text: Qt.application.name
                }

                RowLayout {
                    UI.ButtonContained {
                        text: "Time Picker"
                        buttonColor: UI.Style.primaryColor
                        onClicked: timePicker.open()
                    }

                    UI.ButtonContained {
                        text: timePicker.time24h ? "24hr" : "AM/PM"
                        buttonColor: UI.Style.primaryColor
                        onClicked: timePicker.time24h = !timePicker.time24h
                    }

                    UI.LabelBody {
                        text: timePicker.timeString
                    }
                }
            }
        }

        Drawer {
            id: navDrawer

            interactive: homePage.stack.currentItem == homePage
            width: Math.min(240,  Math.min(parent.width, parent.height) / 3 * 2 )
            height: parent.height

            onAboutToShow: menuColumn.enabled = true

            Flickable {
                anchors.fill: parent
                contentHeight: menuColumn.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: menuColumn

                    anchors { left: parent.left; right: parent.right }
                    spacing: 0

                    Label {
                        text: Qt.application.displayName
                        color: Material.foreground
                        font.pixelSize: UI.Style.fontSizeHeadline
                        padding: (homePage.appToolBar.implicitHeight - contentHeight) / 2
                        leftPadding: 20
                        Layout.fillWidth: true
                    }

                    UI.HorizontalListDivider {}

                    Repeater {
                        id: pageList

                        model: [
                            {
                                icon: UI.Icons.settings,
                                text: "Settings",
                                page: settingsPageComponent
                            },
                            {
                                icon: UI.Icons.info_outline,
                                text: "Info",
                                page: infoPageComponent
                            }
                        ]

                        delegate: ItemDelegate {
                            icon.source: modelData.icon
                            text: modelData.text
                            Layout.fillWidth: true
                            onClicked: {
                                // Disable, or a double click will push the page twice.
                                menuColumn.enabled = false
                                navDrawer.close()
                                homePage.stack.push(modelData.page)
                            }
                        }
                    }
                }
            }
        }

        Menu {
            id: optionsMenu

            modal: true
            dim: false
            closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
            x: parent.width - width - 6
            y: -homePage.appToolBar.height + 6
            transformOrigin: Menu.TopRight

            onAboutToShow: enabled = true
            onAboutToHide: currentIndex = -1 // reset highlighting

            MenuItem {
                text: "Toast test"
                onTriggered: toastPopup.start("Toast message.")
            }
            MenuItem {
                text: "Error test"
                onTriggered: errorPopup.start("Error message.")
            }
            MenuItem {
                text: "Info test"
                onTriggered: infoPopup.open()
            }
        }

        UI.TimePickerCircular {
            id: timePicker
        }
    }

    Component {
        id: settingsPageComponent

        UI.AppStackPage {
            id: settingsPage

            title: "Settings"
            padding: 0

            leftButton: Action {
                icon.source: UI.Icons.arrow_back
                onTriggered: settingsPage.back()
            }

            Flickable {
                contentHeight: settingsPane.implicitHeight
                anchors.fill: parent

                Pane {
                    id: settingsPane

                    anchors.fill: parent
                    padding: 0

                    ColumnLayout {
                        width: parent.width
                        spacing: 0

                        UI.SettingsSectionTitle {
                            text: "Display"
                        }

                        UI.SettingsCheckItem {
                            title: "Dark Theme"
                            checkState: root.theme ? Qt.Checked : Qt.Unchecked
                            onClicked: root.theme = !root.theme
                            Layout.fillWidth: true
                        }

                        UI.SettingsItem {
                            title: "Primary Color"
                            subtitle: colorDialog.getColorName(root.primary)
                            onClicked: {
                                colorDialog.selectAccentColor = false
                                colorDialog.open()
                            }
                        }

                        UI.SettingsItem {
                            title: "Accent Color"
                            subtitle: colorDialog.getColorName(root.accent)
                            onClicked: {
                                colorDialog.selectAccentColor = true
                                colorDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: infoPageComponent

        UI.AppStackPage {
            id: infoPage
            title: "Info"
            padding: 10

            leftButton: Action {
                icon.source: UI.Icons.arrow_back
                onTriggered: infoPage.back()
            }

            Flickable {
                contentHeight: infoPane.implicitHeight
                anchors.fill: parent

                Pane {
                    id: infoPane

                    anchors.fill: parent

                    ColumnLayout {
                        width: parent.width

                        UI.LabelTitle {
                            text: Qt.application.name
                            horizontalAlignment: Qt.AlignHCenter
                        }

                        UI.LabelBody {
                            text: "<a href='%1'>%1</a>".arg("http://github.com/stemoretti/BaseUI")
                            linkColor: UI.Style.isDarkTheme ? "lightblue" : "blue"
                            onLinkActivated: Qt.openUrlExternally(link)
                            horizontalAlignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    UI.PopupToast {
        id: toastPopup
    }

    UI.PopupError {
        id: errorPopup
    }

    UI.PopupInfo {
        id: infoPopup

        parent: Overlay.overlay

        text: "Information message."
    }

    UI.OptionsDialog {
        id: colorDialog

        property bool selectAccentColor: false

        function getColorName(color) {
            var filtered = colorDialog.model.filter((c) => {
                return Material.color(c.bg) === color
            })
            return filtered.length ? filtered[0].name : ""
        }

        title: selectAccentColor ? qsTr("Choose accent color") : qsTr("Choose primary color")
        model: [
            { name: "Material Red", bg: Material.Red },
            { name: "Material Pink", bg: Material.Pink },
            { name: "Material Purple", bg: Material.Purple },
            { name: "Material DeepPurple", bg: Material.DeepPurple },
            { name: "Material Indigo", bg: Material.Indigo },
            { name: "Material Blue", bg: Material.Blue },
            { name: "Material LightBlue", bg: Material.LightBlue },
            { name: "Material Cyan", bg: Material.Cyan },
            { name: "Material Teal", bg: Material.Teal },
            { name: "Material Green", bg: Material.Green },
            { name: "Material LightGreen", bg: Material.LightGreen },
            { name: "Material Lime", bg: Material.Lime },
            { name: "Material Yellow", bg: Material.Yellow },
            { name: "Material Amber", bg: Material.Amber },
            { name: "Material Orange", bg: Material.Orange },
            { name: "Material DeepOrange", bg: Material.DeepOrange },
            { name: "Material DeepOrange", bg: Material.DeepOrange },
            { name: "Material Brown", bg: Material.Brown },
            { name: "Material Grey", bg: Material.Grey },
            { name: "Material BlueGrey", bg: Material.BlueGrey }
        ]
        delegate: RowLayout {
            spacing: 0

            Rectangle {
                visible: colorDialog.selectAccentColor
                color: UI.Style.primaryColor
                Layout.margins: 0
                Layout.leftMargin: 10
                Layout.minimumWidth: 48
                Layout.minimumHeight: 32
            }

            Rectangle {
                color: Material.color(modelData.bg)
                Layout.margins: 0
                Layout.leftMargin: colorDialog.selectAccentColor ? 0 : 10
                Layout.minimumWidth: 32
                Layout.minimumHeight: 32
            }

            RadioButton {
                checked: {
                    if (colorDialog.selectAccentColor)
                        Material.color(modelData.bg) === root.accent
                    else
                        Material.color(modelData.bg) === root.primary
                }
                text: modelData.name
                Layout.leftMargin: 4
                onClicked: {
                    colorDialog.close()
                    if (colorDialog.selectAccentColor)
                        root.accent = Material.color(modelData.bg)
                    else
                        root.primary = Material.color(modelData.bg)
                }
            }
        }
    }

    Component.onCompleted: {
        UI.Style.primaryColor = Qt.binding(function() { return root.primary })
        UI.Style.accentColor = Qt.binding(function() { return root.accent })
        UI.Style.isDarkTheme = Qt.binding(function() { return root.theme })
    }
}
