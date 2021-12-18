import QtQuick 2.12
import QtQuick.Controls 2.12

import BaseUI 1.0

Page {
    id: root

    property StackView stack: StackView.view
    property alias appToolBar: appToolBar
    property alias leftButton: appToolBar.leftButton
    property alias rightButtons: appToolBar.rightButtons

    function pop(item, operation) {
        if (stack.currentItem != root)
            return false

        return stack.pop(item, operation)
    }

    function back() {
        pop()
    }

    Keys.onBackPressed: function(event) {
        if (stack.depth > 1) {
            event.accepted = true
            back()
        } else {
            Qt.quit()
        }
    }

    Action {
        id: backAction
        icon.source: Icons.arrow_back
        onTriggered: root.back()
    }

    AppToolBar {
        id: appToolBar
        title: root.title
        leftButton: stack && stack.depth > 1 ? backAction : null
    }
}
