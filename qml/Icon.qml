import QtQuick

Item {
    id: root

    property alias icon: internal.source
    property color color: undefined

    Image {
        id: internal

        anchors.fill: parent
        layer.enabled: root.color != undefined
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property color color: root.color
            fragmentShader: "shaders/icon.frag.qsb"
        }
    }
}
