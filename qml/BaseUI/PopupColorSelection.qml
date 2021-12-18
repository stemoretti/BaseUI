import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

PopupModalBase {
    property bool selectAccentColor: false
    property color currentColor: Material.primary
    property string currentColorName: colorModel.get(currentIndex).title
    property int currentIndex: 0

    signal colorSelected(color c)

    implicitWidth: parent.width * 0.9
    implicitHeight: Math.min(colorsList.contentHeight, parent.height * 0.9)

    ListView {
        id: colorsList
        anchors.fill: parent
        clip: true
        delegate: ItemDelegate {
            width: colorsList.width
            contentItem: RowLayout {
                spacing: 0
                Rectangle {
                    visible: selectAccentColor
                    color: Material.primary
                    Layout.margins: 0
                    Layout.minimumHeight: 32
                    Layout.minimumWidth: 48
                }
                Rectangle {
                    color: Material.color(model.bg)
                    Layout.margins: 0
                    Layout.minimumHeight: 32
                    Layout.minimumWidth: 32
                }
                LabelBody {
                    text: model.title
                    Layout.leftMargin: 6
                    Layout.fillWidth: true
                }
            }
            onClicked: {
                colorSelected(Material.color(model.bg))
                currentIndex = index
                close()
            }
        }

        model: ListModel {
            id: colorModel
            ListElement { title: "Material Red"; bg: Material.Red }
            ListElement { title: "Material Pink"; bg: Material.Pink }
            ListElement { title: "Material Purple"; bg: Material.Purple }
            ListElement { title: "Material DeepPurple"; bg: Material.DeepPurple }
            ListElement { title: "Material Indigo"; bg: Material.Indigo }
            ListElement { title: "Material Blue"; bg: Material.Blue }
            ListElement { title: "Material LightBlue"; bg: Material.LightBlue }
            ListElement { title: "Material Cyan"; bg: Material.Cyan }
            ListElement { title: "Material Teal"; bg: Material.Teal }
            ListElement { title: "Material Green"; bg: Material.Green }
            ListElement { title: "Material LightGreen"; bg: Material.LightGreen }
            ListElement { title: "Material Lime"; bg: Material.Lime }
            ListElement { title: "Material Yellow"; bg: Material.Yellow }
            ListElement { title: "Material Amber"; bg: Material.Amber }
            ListElement { title: "Material Orange"; bg: Material.Orange }
            ListElement { title: "Material DeepOrange"; bg: Material.DeepOrange }
            ListElement { title: "Material Brown"; bg: Material.Brown }
            ListElement { title: "Material Grey"; bg: Material.Grey }
            ListElement { title: "Material BlueGrey"; bg: Material.BlueGrey }
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < colorModel.count; ++i) {
            var tmp = colorModel.get(i)
            if (Material.color(tmp.bg) === currentColor) {
                currentIndex = i
                return
            }
        }
    }
}
