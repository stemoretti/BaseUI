import QtQuick
import QtQuick.Layouts

Item {
    height: 8
    Layout.fillWidth: true

    // https://www.google.com/design/spec/components/dividers.html#dividers-types-of-dividers
    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: 1
        opacity: Style.dividerOpacity
        color: Style.dividerColor
    }
}
