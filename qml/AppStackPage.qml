import QtQuick
import QtQuick.Controls

Page {
    id: root

    readonly property StackView stack: StackView.view
    property alias appToolBar: appToolBar
    property alias leftButton: appToolBar.leftButton
    property alias rightButtons: appToolBar.rightButtons

    function pop(item, operation) {
        if (root.stack.currentItem != root)
            return false
        return root.stack.pop(item, operation)
    }

    function back() {
        pop()
    }

    Keys.onBackPressed: function(event) {
        if (root.stack.depth > 1) {
            event.accepted = true
            back()
        } else {
            Qt.quit()
        }
    }

    AppToolBar {
        id: appToolBar
        title: root.title
    }
}
