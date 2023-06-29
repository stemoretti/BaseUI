cmake_minimum_required(VERSION 3.19)

project(BaseUI VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

option(BASEUI_INCLUDE_ICONS "Include Material icons" ON)

find_package(Qt6 COMPONENTS Core Gui Qml Quick QuickControls2 ShaderTools REQUIRED)

set_source_files_properties(qml/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(baseui
    URI BaseUI
    VERSION 1.0
    SOURCES
        include/BaseUI/core.h
        src/core.cpp
        src/iconprovider.h
        src/icons.cpp
        src/icons.h
        src/plugin.h
    QML_FILES
        qml/App.qml
        qml/AppStackPage.qml
        qml/AppToolBar.qml
        qml/ButtonContained.qml
        qml/ButtonFlat.qml
        qml/DatePicker.qml
        qml/EdgeEffect.qml
        qml/HorizontalDivider.qml
        qml/HorizontalListDivider.qml
        qml/Icon.qml
        qml/LabelBody.qml
        qml/LabelBodySecondary.qml
        qml/LabelSubheading.qml
        qml/LabelTitle.qml
        qml/ListViewEdgeEffect.qml
        qml/OptionsDialog.qml
        qml/PopupError.qml
        qml/PopupInfo.qml
        qml/PopupToast.qml
        qml/SettingsCheckItem.qml
        qml/SettingsItem.qml
        qml/SettingsSectionTitle.qml
        qml/Style.qml
        qml/TimeCircle.qml
        qml/TimePickerCircular.qml
        qml/TimePickerTumbler.qml
    RESOURCE_PREFIX
        "/baseui/imports"
)

qt_add_shaders(baseui "baseui_shaders"
    BATCHABLE
    PRECOMPILE
    PREFIX
        "/baseui/imports/BaseUI"
    FILES
        qml/shaders/clock.frag
        qml/shaders/icon.frag
)

if(BASEUI_INCLUDE_ICONS)
    target_compile_definitions(baseui PRIVATE BASEUI_INCLUDE_ICONS)
    qt_add_resources(baseui "baseui_icons"
        PREFIX
            "/baseui/imports/BaseUI"
        FILES
            icons/codepoints.json
            icons/MaterialIcons-Regular.ttf
    )
endif()

target_include_directories(baseui
    PUBLIC  "${PROJECT_SOURCE_DIR}/include"
    PRIVATE "${PROJECT_SOURCE_DIR}/src"
)

set_target_properties(baseui PROPERTIES
    CXX_STANDARD              17
    CXX_STANDARD_REQUIRED     YES
    CXX_EXTENSIONS            NO
)

target_compile_definitions(baseui
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(baseui
    PRIVATE
        Qt::Core
        Qt::Gui
        Qt::Qml
        Qt::Quick
        Qt::QuickControls2
)
