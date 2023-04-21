import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

CheckDelegate {
    id: root

    property alias title: root.text
    property string subtitle
    property string subtitlePlaceholder

    contentItem: ColumnLayout {
        spacing: 2

        LabelSubheading {
            rightPadding: root.indicator.width + root.spacing
            text: root.text
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        LabelBody {
            rightPadding: root.indicator.width + root.spacing
            text: root.subtitle.length > 0 ? root.subtitle : root.subtitlePlaceholder
            visible: text.length > 0 || root.subtitlePlaceholder.length > 0
            opacity: 0.6
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
