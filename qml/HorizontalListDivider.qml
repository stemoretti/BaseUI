import QtQuick
import QtQuick.Layouts

// special divider for list elements
// using height 1 ensures that it looks good if highlighted
Item {
    height: 1
    Layout.fillWidth: true
    Rectangle {
        width: parent.width
        height: 1
        opacity: Style.dividerOpacity
        color: Style.dividerColor
    }
}
