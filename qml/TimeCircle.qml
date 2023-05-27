import QtQuick

Item {
    id: root

    required property Item screen

    property int hours: 0
    property int minutes: 0
    readonly property string timeString: _zeroPad(hours) + ":" + _zeroPad(minutes)
    readonly property bool isPM: hours >= 12

    readonly property alias pickMinutes: clock.pickMinutes
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

    function setPickMinutes(pick) {
        if (!animation.running)
            clock.pickMinutes = pick
    }

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
        var minAngle = 360 / 60 * root.minutes
        var hourAngle = 360 / 12 * (root.hours - (root.hours >= 12 ? 12 : 0))

        var diff = minAngle - hourAngle
        if (Math.abs(diff) <= 180) {
            handToAnimation.to = handFromAnimation.from = (minAngle + hourAngle) / 2
        } else {
            handToAnimation.to     = root.pickMinutes ? (diff >= 0 ? 0 : 360) : (diff >= 0 ? 360 : 0)
            handFromAnimation.from = root.pickMinutes ? (diff >= 0 ? 360 : 0) : (diff >= 0 ? 0 : 360)
        }
        circleToAnimation.to = handToAnimation.to / 180 * Math.PI
        circleFromAnimation.from = handFromAnimation.from / 180 * Math.PI

        var toMiddleTime
        var fromMiddleTime
        if (root.pickMinutes) {
            toMiddleTime = Math.abs(hourAngle - handToAnimation.to) / 180 * 400
            fromMiddleTime = Math.abs(minAngle - handFromAnimation.from) / 180 * 400
        } else {
            toMiddleTime = Math.abs(minAngle - handToAnimation.to) / 180 * 400
            fromMiddleTime = Math.abs(hourAngle - handFromAnimation.from) / 180 * 400
        }
        var animTime = toMiddleTime + fromMiddleTime
        if (animTime > 0 && animTime < 200) {
            toMiddleTime = toMiddleTime / animTime * 200
            fromMiddleTime = fromMiddleTime / animTime * 200
        }
        handToAnimation.duration = circleToAnimation.duration = toMiddleTime
        handFromAnimation.duration = circleFromAnimation.duration = fromMiddleTime

        animation.interval = Math.max(toMiddleTime + fromMiddleTime, 200)

        animation.start()
    }

    Timer {
        id: animation
    }

    Rectangle {
        id: clock

        property bool pickMinutes: false

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

            enabled: !animation.running
            anchors.fill: parent
            pressAndHoldInterval: 100

            onClicked: (mouse) => { selectTime(mouse, true); clock.pickMinutes = true }
            onPositionChanged: (mouse) => { if (isHold) selectTime(mouse) }
            onPressAndHold: (mouse) => { isHold = true; selectTime(mouse) }
            onReleased: { if (isHold) { isHold = false; clock.pickMinutes = true } }
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
                enabled: animation.running
                SequentialAnimation {
                    NumberAnimation { id: handToAnimation }
                    NumberAnimation { id: handFromAnimation }
                }
            }
            Behavior on height {
                enabled: animation.running
                NumberAnimation { duration: animation.interval }
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
                visible: root.pickMinutes && !animation.running && root.minutes % 5
                color: root.labelDotColor
            }

            Behavior on angle {
                enabled: animation.running
                SequentialAnimation {
                    NumberAnimation { id: circleToAnimation }
                    NumberAnimation { id: circleFromAnimation }
                }
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
                color: layer.enabled || modelData != root.hours ? root.labelsColor : root.labelsSelectedColor
                text: modelData
                layer.enabled: root.labelsSelectedColor != root.labelsColor && animation.running
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
                color: {
                    if (!layer.enabled) {
                        if (root.time24h) {
                            if (modelData == root.hours)
                                return root.labelsSelectedColor
                        } else if (root.isPM) {
                            if (modelData == root.hours - 12
                                || (modelData == 12 && root.hours == 12))
                                return root.labelsSelectedColor
                        } else if (modelData == root.hours
                                   || (modelData == 12 && root.hours == 0)) {
                            return root.labelsSelectedColor
                        }
                    }
                    return root.labelsColor
                }
                text: modelData
                layer.enabled: root.labelsSelectedColor != root.labelsColor && animation.running
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
                color: animation.running || modelData != root.minutes
                        ? root.labelsColor : root.labelsSelectedColor
                text: _zeroPad(modelData)
                layer.enabled: animation.running
                                || (root.labelsSelectedColor != root.labelsColor
                                    && root.minutes != modelData
                                    && (Math.abs(root.minutes - modelData) < 5
                                        || (modelData == 0 && root.minutes > 55)))
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
