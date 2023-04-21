import QtQuick

Item {
    id: root

    required property Item screen

    property int hours: 0
    property int minutes: 0
    readonly property string timeString: _zeroPad(hours) + ":" + _zeroPad(minutes)
    readonly property bool isPM: hours >= 12

    property bool pickMinutes: false
    property bool time24h: false

    property color clockColor: "gray"
    property color clockHandColor: "blue"
    property color labelsColor: "white"
    property color labelsSelectedColor: labelsColor
    property color labelDotColor: labelsColor

    property real innerRadius: clock.radius * 0.5
    property real outerRadius: clock.radius * 0.8

    property int labelsSize: 20
    property int clockHandCircleSize: 2 * labelsSize

    function update() {
        circle.pos = circle.mapToItem(root.screen, 0, circle.height)
        circle.pos.y = Window.height - circle.pos.y
    }

    function _zeroPad(n) { return n > 9 ? n : '0' + n }

    function _getSelectedAngle(fullAngle) {
        if (root.pickMinutes)
            return fullAngle / 60 * root.minutes
        else if (root.hours >= 12)
            return fullAngle / 12 * (root.hours - 12)
        else
            return fullAngle / 12 * root.hours
    }

    implicitWidth: labelsSize * 12
    implicitHeight: implicitWidth

    onPickMinutesChanged: {
        handAnimation.enabled = circleAnimation.enabled = true
        disableAnimationTimer.start()
    }

    Timer {
        id: disableAnimationTimer
        interval: 400
        repeat: false
        onTriggered: handAnimation.enabled = circleAnimation.enabled = false
    }

    Rectangle {
        id: clock

        width: Math.min(root.width, root.height)
        height: width
        radius: width / 2
        color: root.clockColor

        MouseArea {
            property bool isHold: false

            function getSectorFromAngle(rad, sectors) {
                let index = Math.round(rad / (2 * Math.PI) * sectors)
                return index < 0 ? index + sectors : index
            }

            function selectTime(mouse, tap) {
                let x = mouse.x - width / 2
                let y = -(mouse.y - height / 2)
                let angle = Math.atan2(x, y)
                if (root.pickMinutes) {
                    if (tap)
                        root.minutes = getSectorFromAngle(angle, 12) * 5
                    else
                        root.minutes = getSectorFromAngle(angle, 60)
                } else {
                    let hour = getSectorFromAngle(angle, 12)
                    if (root.time24h) {
                        let radius = (root.outerRadius + root.innerRadius) / 2
                        if (Qt.vector2d(x, y).length() > radius) {
                            if (hour == 0)
                                hour = 12
                        } else if (hour != 0) {
                            hour += 12
                        }
                    } else if (root.isPM) {
                        hour += 12
                    }
                    root.hours = hour
                }
            }

            anchors.fill: parent
            pressAndHoldInterval: 100

            onClicked: (mouse) => { selectTime(mouse, true); root.pickMinutes = true }
            onPositionChanged: (mouse) => { if (isHold) selectTime(mouse) }
            onPressAndHold: (mouse) => { isHold = true; selectTime(mouse) }
            onReleased: { if (isHold) { isHold = false; root.pickMinutes = true } }
        }

        // clock hand
        Rectangle {
            id: hand

            x: clock.width / 2 - width / 2
            y: clock.height / 2 - height
            width: 2
            height: root.pickMinutes
                    || !root.time24h
                    || (root.hours != 0 && root.hours <= 12)
                ? root.outerRadius
                : root.innerRadius

            transformOrigin: Item.Bottom
            rotation: _getSelectedAngle(360)
            color: root.clockHandColor
            antialiasing: true
            Behavior on rotation {
                id: handAnimation
                enabled: false
                NumberAnimation { duration: 400 }
            }
        }

        // label background
        Rectangle {
            id: circle

            property point pos: Qt.point(x, y)
            property real angle: _getSelectedAngle(2 * Math.PI)

            x: clock.width  / 2 + hand.height * Math.sin(angle) - width / 2
            y: clock.height / 2 - hand.height * Math.cos(angle) - height / 2
            width: root.clockHandCircleSize
            height: width
            radius: width / 2
            color: root.clockHandColor

            onXChanged: pos.x = mapToItem(root.screen, 0, 0).x
            // OpenGL origin is bottom left
            onYChanged: pos.y = Window.height - mapToItem(root.screen, 0, height).y

            Rectangle {
                width: 4
                height: width
                radius: width / 2
                anchors.centerIn: parent
                visible: root.pickMinutes && root.minutes % 5
                color: root.labelDotColor
            }

            Behavior on angle {
                id: circleAnimation
                enabled: false
                NumberAnimation { duration: 400 }
            }
        }

        // centerpoint
        Rectangle {
            anchors.centerIn: parent
            width: 10
            height: width
            radius: width / 2
            color: root.clockHandColor
        }

        Repeater {
            anchors.centerIn: parent
            model: [ 0, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23 ]
            delegate: Text {
                required property int modelData
                required property int index
                property real angle: 2 * Math.PI * index / 12
                x: clock.width  / 2 + root.innerRadius * Math.sin(angle) - width / 2
                y: clock.height / 2 - root.innerRadius * Math.cos(angle) - height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.labelsSize
                visible: root.time24h
                opacity: root.pickMinutes ? 0 : 1
                color: root.labelsColor
                text: modelData
                layer.enabled: true
                layer.samplerName: "maskSource"
                layer.effect: shaderEffect
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        Repeater {
            anchors.centerIn: parent
            model: [ 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ]
            delegate: Text {
                required property int modelData
                required property int index
                property real angle: 2 * Math.PI * index / 12
                x: clock.width  / 2 + root.outerRadius * Math.sin(angle) - width / 2
                y: clock.height / 2 - root.outerRadius * Math.cos(angle) - height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.labelsSize
                opacity: root.pickMinutes ? 0 : 1
                color: root.labelsColor
                text: modelData
                layer.enabled: true
                layer.samplerName: "maskSource"
                layer.effect: shaderEffect
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        Repeater {
            anchors.centerIn: parent
            model: 60
            delegate: Text {
                required property int modelData
                required property int index
                property real angle: 2 * Math.PI * index / 60
                x: clock.width  / 2 + root.outerRadius * Math.sin(angle) - width / 2
                y: clock.height / 2 - root.outerRadius * Math.cos(angle) - height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.labelsSize
                visible: modelData % 5 == 0
                opacity: root.pickMinutes ? 1 : 0
                color: root.labelsColor
                text: _zeroPad(modelData)
                layer.enabled: true
                layer.samplerName: "maskSource"
                layer.effect: shaderEffect
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }

    Component {
        id: shaderEffect
        ShaderEffect {
            property point pos: circle.pos
            property real radius: root.labelsSize
            property color color: root.labelsSelectedColor
            property real dpi: Screen.devicePixelRatio
            fragmentShader: "shaders/clock.frag.qsb"
        }
    }
}
