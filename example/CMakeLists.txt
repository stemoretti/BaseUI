cmake_minimum_required(VERSION 3.10)

project(example VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 COMPONENTS Core Gui Qml Quick QuickControls2 REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

add_subdirectory(BaseUI)

qt_add_executable(example WIN32 MACOSX_BUNDLE main.cpp)

qt_add_qml_module(example
    URI Example
    VERSION 1.0
    QML_FILES main.qml
    NO_RESOURCE_TARGET_PATH
)

target_link_libraries(example
    PUBLIC
        Qt::Core
        Qt::Gui
        Qt::Qml
        Qt::Quick
        Qt::QuickControls2
        baseui
)
