// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
Item {
    height: 8
    Layout.fillWidth: true
    // anchors.left: parent.left
    // anchors.right: parent.right
    // anchors.margins: 6
    // https://www.google.com/design/spec/components/dividers.html#dividers-types-of-dividers
    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: 1
        opacity: Style.dividerOpacity
        color: Style.dividerColor
    }
}
