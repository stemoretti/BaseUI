import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ItemDelegate {
    id: root

    property alias title: titleLabel.text
    property string subtitle
    property string subtitlePlaceholder

    Layout.fillWidth: true

    contentItem: ColumnLayout {
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
}
