import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ItemDelegate {
    id: root

    property alias title: titleLabel.text
    property string subtitle
    property string subtitlePlaceholder
    property alias check: settingSwitch

    Layout.fillWidth: true

    contentItem: RowLayout {
        ColumnLayout {
            spacing: 2

            LabelSubheading {
                id: titleLabel

                wrapMode: Text.WordWrap

                Layout.fillWidth: true
            }
            LabelBody {
                id: subtitleLabel

                visible: text.length > 0 || root.subtitlePlaceholder.length > 0
                opacity: 0.6
                wrapMode: Text.WordWrap
                elide: Text.ElideMiddle
                text: root.subtitle.length > 0 ? root.subtitle : root.subtitlePlaceholder

                Layout.fillWidth: true
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Switch {
            id: settingSwitch
            visible: false
        }
    }
}
