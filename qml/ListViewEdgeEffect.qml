import QtQuick
import QtQuick.Controls

ListView {
    id: root

    boundsMovement: Flickable.StopAtBounds
    boundsBehavior: Flickable.DragOverBounds

    // XXX: disable optimizations
    cacheBuffer: height * 1000

    add: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 200 }
    }
    moveDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 200 }
    }
    removeDisplaced: Transition {
        NumberAnimation { property: "y"; duration: 200 }
    }

    ScrollIndicator.vertical: ScrollIndicator { }

    EdgeEffect {
        width: root.width
        anchors.top: root.top
        side: EdgeEffect.Side.Top
        overshoot: root.verticalOvershoot < 0 ? -root.verticalOvershoot : 0
        maxOvershoot: root.height
        color: Style.isDarkTheme ? "gray" : "darkgray"
    }

    EdgeEffect {
        width: root.width
        anchors.bottom: root.bottom
        side: EdgeEffect.Side.Bottom
        overshoot: root.verticalOvershoot > 0 ? root.verticalOvershoot : 0
        maxOvershoot: root.height
        color: Style.isDarkTheme ? "gray" : "darkgray"
    }
}
