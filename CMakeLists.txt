cmake_minimum_required(VERSION 3.16)

project(FoodTracker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# DODANO: QuickControls2 - niezbędne do stylizacji przycisków
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appFoodTracker
    main.cpp
)

qt_add_qml_module(appFoodTracker
    URI FoodTracker
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        healthcontroller.h   # Upewnij się, że nazwy plików na dysku
        healthcontroller.cpp # są identyczne (małe/duże litery)!
    RESOURCES
        images/water_icon.png
        images/food_icon.png
        images/athlete_background.png
)

set_target_properties(appFoodTracker PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# DODANO: Qt6::QuickControls2 w linkowaniu
target_link_libraries(appFoodTracker
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appFoodTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
