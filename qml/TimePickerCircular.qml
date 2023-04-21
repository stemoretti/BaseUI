import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

Dialog {
    id: root

    property alias time24h: timePicker.time24h

    readonly property string timeString: timePicker.timeString + ":00"

    function setTime(hour, minute) {
        timePicker.hours = hour
        timePicker.minutes = minute
    }

    readonly property bool _isLandscape: parent.width > parent.height

    function _zeroPad(n) { return n > 9 ? n : '0' + n }

    parent: Overlay.overlay

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    padding: 0
    topPadding: 0

    modal: true
    dim: true
    focus: true

    onOpened: timePicker.update()
    onClosed: timePicker.pickMinutes = false

    on_IsLandscapeChanged: updateTimer.restart()

    Timer {
        id: updateTimer
        interval: 1
        onTriggered: timePicker.update()
    }

    header: Pane {
        bottomPadding: 0

        LabelSubheading {
            text: qsTr("Select time")
            font.bold: true
            opacity: 1
        }
    }

    contentItem: Pane {
        topPadding: 0
        bottomPadding: 0

        GridLayout {
            flow: root._isLandscape ? GridLayout.LeftToRight : GridLayout.TopToBottom

            GridLayout {
                flow: root._isLandscape ? GridLayout.TopToBottom : GridLayout.LeftToRight

                Layout.alignment: Qt.AlignCenter

                RowLayout {
                    spacing: 0

                    Layout.alignment: Qt.AlignVCenter

                    Label {
                        color: timePicker.pickMinutes ? Material.foreground : Style.primaryColor
                        font.pixelSize: Style.fontSizeDisplay3
                        text: {
                            let hours = timePicker.hours
                            if (!timePicker.time24h) {
                                if (timePicker.isPM) {
                                    if (timePicker.hours != 12)
                                        hours = timePicker.hours - 12
                                } else {
                                    if (timePicker.hours == 0)
                                        hours = 12
                                }
                            }
                            _zeroPad(hours)
                        }
                        background: Rectangle {
                            color: timePicker.pickMinutes ? Qt.darker(Material.background, 1.1) : Qt.lighter(Style.primaryColor)
                            radius: 4
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: timePicker.pickMinutes = false
                        }
                    }

                    Label {
                        color: Material.foreground
                        font.pixelSize: Style.fontSizeDisplay3
                        text: ":"
                    }

                    Label {
                        color: timePicker.pickMinutes ? Style.primaryColor : Material.foreground
                        font.pixelSize: Style.fontSizeDisplay3
                        text: _zeroPad(timePicker.minutes)
                        background: Rectangle {
                            color: timePicker.pickMinutes ? Qt.lighter(Style.primaryColor) : Qt.darker(Material.background, 1.1)
                            radius: 4
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: timePicker.pickMinutes = true
                        }
                    }
                }

                ColumnLayout {
                    visible: !timePicker.time24h

                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        width: amLabel.width + 4
                        height: amLabel.height + 4
                        radius: 4
                        color: timePicker.isPM ? Material.background : Style.primaryColor

                        Label {
                            id: amLabel
                            anchors.centerIn: parent
                            font.pixelSize: Style.fontSizeTitle
                            color: timePicker.isPM ? Material.foreground : Style.textOnPrimary
                            text: "AM"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (timePicker.isPM)
                                    timePicker.hours -= 12
                            }
                        }
                    }

                    Rectangle {
                        width: pmLabel.width + 4
                        height: pmLabel.height + 4
                        radius: 4
                        color: timePicker.isPM ? Style.primaryColor : Material.background

                        Label {
                            id: pmLabel
                            anchors.centerIn: parent
                            font.pixelSize: Style.fontSizeTitle
                            color: timePicker.isPM ? Style.textOnPrimary : Material.foreground
                            text: "PM"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (!timePicker.isPM)
                                    timePicker.hours += 12
                            }
                        }
                    }
                }
            }

            TimeCircle {
                id: timePicker

                screen: Overlay.overlay
                clockColor: Qt.darker(Material.background, 1.1)
                clockHandColor: Style.primaryColor
                labelsColor: Style.isDarkTheme ? "#FFFFFF" : "#000000"
                labelsSelectedColor: Style.textOnPrimary
                labelDotColor: Style.textOnPrimary
                labelsSize: Style.fontSizeTitle

                Layout.alignment: Qt.AlignCenter
                Layout.leftMargin: root._isLandscape ? 30 : 0
            }
        }
    }

    footer: DialogButtonBox {
        alignment: Qt.AlignRight
        background: Pane {}

        ButtonFlat {
            text: qsTr("Cancel")
            textColor: Style.primaryColor
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }

        ButtonFlat {
            text: qsTr("OK")
            textColor: Style.primaryColor
            implicitWidth: 80
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }
}
