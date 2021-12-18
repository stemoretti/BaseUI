import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import BaseUI 1.0 as UI

UI.App {
    id: root

    width: 360
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

                    Rectangle {
                        id: topItem

                        height: 140
                        color: UI.Style.primaryColor
                        Layout.fillWidth: true

                        Text {
                            text: Qt.application.name
                            color: UI.Style.textOnPrimary
                            font.pixelSize: UI.Style.fontSizeHeadline
                            wrapMode: Text.WordWrap
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                margins: 25
                            }
                        }
                    }

                    Repeater {
                        id: pageList

                        model: [
                            { icon: UI.Icons.settings, text: "Settings", page: settingsPage },
                            { icon: UI.Icons.info_outline, text: "About", page: aboutPage }
                        ]

                        delegate: ItemDelegate {
                            icon.source: modelData.icon
                            text: modelData.text
                            Layout.fillWidth: true
                            onClicked: {
                                // Disable, or a double click will push the page twice.
                                menuColumn.enabled = false
                                navDrawer.close()
                                pageStack.push(modelData.page)
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
    }

    Component {
        id: settingsPage

        UI.AppStackPage {
            title: "Settings"
            padding: 0

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

                        UI.SettingsItem {
                            title: "Dark Theme"
                            check.visible: true
                            check.checked: root.theme
                            check.onClicked: root.theme = !root.theme
                            onClicked: check.clicked()
                        }

                        UI.SettingsItem {
                            title: "Primary Color"
                            subtitle: primaryColorPopup.currentColorName
                            onClicked: primaryColorPopup.open()
                        }

                        UI.SettingsItem {
                            title: "Accent Color"
                            subtitle: accentColorPopup.currentColorName
                            onClicked: accentColorPopup.open()
                        }
                    }
                }
            }
        }
    }

    Component {
        id: aboutPage

        UI.AppStackPage {
            title: "About"
            padding: 10

            Flickable {
                contentHeight: aboutPane.implicitHeight
                anchors.fill: parent

                Pane {
                    id: aboutPane

                    anchors.fill: parent

                    ColumnLayout {
                        width: parent.width

                        UI.LabelTitle {
                            text: Qt.application.name
                            horizontalAlignment: Qt.AlignHCenter
                        }

                        UI.LabelBody {
                            property string url: "http://github.com/stemoretti/baseui"

                            text: "<a href='" + url + "'>" + url + "</a>"
                            linkColor: UI.Style.isDarkTheme ? "lightblue" : "blue"
                            onLinkActivated: Qt.openUrlExternally(link)
                            horizontalAlignment: Qt.AlignHCenter
                        }

                        UI.HorizontalDivider { }

                        UI.LabelSubheading {
                            text: "This app is based on the following software:"
                            wrapMode: Text.WordWrap
                        }

                        UI.LabelBody {
                            text: "Qt 6<br>"
                                  + "Copyright 2008-2021 The Qt Company Ltd."
                                  + " All rights reserved."
                            wrapMode: Text.WordWrap
                        }

                        UI.LabelBody {
                            text: "Qt is under the LGPLv3 license."
                            wrapMode: Text.WordWrap
                        }

                        UI.HorizontalDivider { }

                        UI.LabelBody {
                            text: "<a href='https://material.io/tools/icons/'"
                                  + "title='Material Design'>Material Design</a>"
                                  + " icons are under Apache license version 2.0"
                            wrapMode: Text.WordWrap
                            linkColor: UI.Style.isDarkTheme ? "lightblue" : "blue"
                            onLinkActivated: Qt.openUrlExternally(link)
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

    UI.PopupColorSelection {
        id: primaryColorPopup

        parent: Overlay.overlay

        currentColor: root.primary
        onColorSelected: function(c) { root.primary = c }
    }

    UI.PopupColorSelection {
        id: accentColorPopup

        parent: Overlay.overlay

        selectAccentColor: true
        currentColor: root.accent
        onColorSelected: function(c) { root.accent = c }
    }

    Component.onCompleted: {
        UI.Style.primaryColor = Qt.binding(function() { return root.primary })
        UI.Style.accentColor = Qt.binding(function() { return root.accent })
        UI.Style.isDarkTheme = Qt.binding(function() { return root.theme })
    }
}
