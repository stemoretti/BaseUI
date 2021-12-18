QT += qml quick quickcontrols2

BASEUI_DIR = BaseUI

INCLUDEPATH += \
    $$PWD/include

HEADERS += \
    $$PWD/include/BaseUI/core.h \
    $$PWD/src/iconprovider.h \
    $$PWD/src/icons.h

SOURCES += \
    $$PWD/src/core.cpp \
    $$PWD/src/icons.cpp

QML_FILES = \
    $$PWD/qml/BaseUI/qmldir \
    $$files($$PWD/qml/BaseUI/*.qml)

OTHER_FILES += $$QML_FILES

contains(CONFIG, baseui_embed_qml) {
    DEFINES += BASEUI_EMBED_QML
    RESOURCES += $$PWD/qml/BaseUI/baseui_qml.qrc
} else {
    qml_copy.path = $$BASEUI_DIR
    qml_copy.files = $$QML_FILES

    qml_install.path = $$DESTDIR/$$BASEUI_DIR
    qml_install.files = $$QML_FILES

    COPIES += qml_copy
    INSTALLS += qml_install
}

contains(CONFIG, baseui_embed_icons) {
    DEFINES += BASEUI_EMBED_ICONS
    RESOURCES += $$PWD/icons/baseui_icons.qrc
} else {
    BASEUI_ICONS_DIR = $$BASEUI_DIR/icons
    ICONS_FILES = \
        $$PWD/icons/codepoints.json \
        $$PWD/icons/MaterialIcons-Regular.ttf

    icons_copy.path = $$BASEUI_ICONS_DIR
    icons_copy.files = $$ICONS_FILES

    icons_install.path = $$DESTDIR/$$BASEUI_ICONS_DIR
    icons_install.files = $$ICONS_FILES

    COPIES += icons_copy
    INSTALLS += icons_install
}
