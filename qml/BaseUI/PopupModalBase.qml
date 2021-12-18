import QtQuick 2.12
import QtQuick.Controls 2.12

Popup {
    id: root

    modal: true
    dim: true
    padding: 0
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    implicitWidth: Math.min(contentWidth, parent.width * 0.9)
    implicitHeight: Math.min(contentHeight, parent.height * 0.9)
}
