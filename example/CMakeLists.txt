cmake_minimum_required(VERSION 3.10)

project(example VERSION 0.1 LANGUAGES CXX)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Qml Quick Gui QuickControls2 REQUIRED)

set(CMAKE_AUTORCC ON)

add_executable(${PROJECT_NAME} main.cpp qml.qrc)

add_subdirectory(baseui)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::QuickControls2
        baseui
)
