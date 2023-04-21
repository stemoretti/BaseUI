import QtQuick

Item {
    id: root

    enum Side {
        Top,
        Bottom
    }

    required property int overshoot
    required property int maxOvershoot

    property int side: EdgeEffect.Side.Top
    property color color: "gray"

    implicitHeight: 30

    onColorChanged: canvas.requestPaint()

    Canvas {
        id: canvas

        anchors.fill: parent
        opacity: root.overshoot / root.maxOvershoot

        onPaint: {
            if (root.side === EdgeEffect.Side.Top) {
                var y1 = 0
                var y2 = height
            } else {
                var y1 = height
                var y2 = 0
            }
            var ctx = getContext("2d")
            ctx.save()
            ctx.reset()
            ctx.fillStyle = root.color
            ctx.beginPath()
            ctx.moveTo(0, y1)
            ctx.bezierCurveTo(width / 4, y2, 3 * width / 4, y2, width, y1)
            ctx.fill()
            ctx.restore()
        }
    }
}
