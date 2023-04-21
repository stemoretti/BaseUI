import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: root

    readonly property int hours: {
        if (root.timeAMPM) {
            if (amPmTumbler.currentIndex === 0) {
                if (hoursTumbler.currentIndex === 0)
                    12
                else
                    hoursTumbler.currentIndex + 12
            } else {
                if (hoursTumbler.currentIndex === 12)
                    0
                else
                    hoursTumbler.currentIndex
            }
        } else {
            hoursTumbler.currentIndex
        }
    }
    readonly property int minutes: minutesTumbler.currentIndex
    readonly property string timeString: _zeroPad(hours) + ":" + _zeroPad(minutes) + ":00"

    property bool timeAMPM: false

    function setTime(hour, minute) {
        if (root.timeAMPM) {
            if (hour >= 12) {
                hour -= 12
                // XXX: doesn't work. why?
                // amPmTumbler.positionViewAtIndex(0, Tumbler.Center)
                amPmTumbler.currentIndex = 0
            } else {
                // amPmTumbler.positionViewAtIndex(1, Tumbler.Center)
                amPmTumbler.currentIndex = 1
            }
        }
        hoursTumbler.positionViewAtIndex(hour, Tumbler.Center)
        minutesTumbler.positionViewAtIndex(minute, Tumbler.Center)
    }

    function _zeroPad(n) { return n > 9 ? n : '0' + n }

    parent: Overlay.overlay

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    padding: 0
    topPadding: 0

    modal: true
    dim: true
    focus: true

    header: Pane {
        LabelSubheading {
            text: qsTr("Select time")
            font.bold: true
            opacity: 1
        }
    }

    contentItem: Pane {
        RowLayout {
            id: tumblerRow

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: 10

            Tumbler {
                id: hoursTumbler

                model: root.timeAMPM ? [ 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] : 24
                delegate: delegateComponent
            }

            Label {
                text: ":"
                font.pixelSize: 40
            }

            Tumbler {
                id: minutesTumbler

                model: 60
                delegate: delegateComponent
            }

            Tumbler {
                id: amPmTumbler

                visible: root.timeAMPM
                model: ["PM", "AM"]
                delegate: Label {
                    text: modelData
                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 40
                }
            }
        }
    }

    footer: DialogButtonBox {
        alignment: Qt.AlignRight
        background: Pane {}

        ButtonFlat {
            text: qsTr("Cancel")
            textColor: Style.primaryColor
            // implicitWidth: 80
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
        }

        ButtonFlat {
            text: qsTr("OK")
            textColor: Style.primaryColor
            implicitWidth: 80
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }
    }

    Component {
        id: delegateComponent

        Label {
            text: _zeroPad(modelData)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
        }
    }
}
