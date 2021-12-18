cmake_minimum_required(VERSION 3.10)

project(baseui VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

option(BASEUI_EMBED_QML "BaseUI embed qml" OFF)
option(BASEUI_EMBED_ICONS "BaseUI embed icons" OFF)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Qml Quick Gui QuickControls2 REQUIRED)

add_library(${PROJECT_NAME} STATIC
    include/BaseUI/core.h
    src/core.cpp
    src/iconprovider.h
    src/icons.h
    src/icons.cpp
)

if(BASEUI_EMBED_QML)
    target_sources(${PROJECT_NAME} PRIVATE "qml/BaseUI/baseui_qml.qrc")
    target_compile_definitions(${PROJECT_NAME} PRIVATE BASEUI_EMBED_QML)
else()
    file(GLOB QML_FILES "qml/BaseUI/*.qml" "qml/BaseUI/qmldir")

    add_custom_target(copy_qml_to_binary_dir ALL
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_BINARY_DIR}/BaseUI"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different ${QML_FILES} "${CMAKE_BINARY_DIR}/BaseUI"
        COMMENT "Copying QML files to binary directory"
        VERBATIM
    )
endif()

if(BASEUI_EMBED_ICONS)
    target_sources(${PROJECT_NAME} PRIVATE "icons/baseui_icons.qrc")
    target_compile_definitions(${PROJECT_NAME} PRIVATE BASEUI_EMBED_ICONS)
else()
    add_custom_target(copy_icons_to_binary_dir ALL
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_BINARY_DIR}/BaseUI/icons"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different
                "${PROJECT_SOURCE_DIR}/icons/codepoints.json"
                "${PROJECT_SOURCE_DIR}/icons/MaterialIcons-Regular.ttf"
                "${CMAKE_BINARY_DIR}/BaseUI/icons"
        COMMENT "Copying icons files to binary directory"
        VERBATIM
    )
endif()

target_include_directories(${PROJECT_NAME} PUBLIC "${PROJECT_SOURCE_DIR}/include")

set_target_properties(${PROJECT_NAME} PROPERTIES
    CXX_STANDARD              11
    CXX_STANDARD_REQUIRED     YES
    CXX_EXTENSIONS            NO
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:
            QT_QML_DEBUG
            # enable deprecated warnings for qt < 5.13
            QT_DEPRECATED_WARNINGS
        >

        $<$<CONFIG:Release>:
            # disable deprecated warnings for qt >= 5.13
            QT_NO_DEPRECATED_WARNINGS
        >
)

target_compile_options(${PROJECT_NAME}
    PRIVATE
        $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:GNU>>:
            -Wall
            -Wextra
            -Wpedantic
        >

        $<$<CXX_COMPILER_ID:MSVC>:
            /W4
        >
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::QuickControls2
)
