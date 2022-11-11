set(PROJECT_NAME scam_simple)

find_package(Qt6 COMPONENTS Core Widgets Gui)
find_package(ads COMPONENTS qtadvanceddocking)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

file(GLOB_RECURSE headers "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
     "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
)
file(GLOB_RECURSE sources "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
     "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
)
file(GLOB_RECURSE resources "${CMAKE_CURRENT_SOURCE_DIR}/resources/*.qrc"
     "${CMAKE_CURRENT_SOURCE_DIR}/resources/styles/*.qss"
     "${CMAKE_CURRENT_SOURCE_DIR}/resources/*.json"
)
list(APPEND all_files ${headers} ${sources} ${resources})

add_executable(${PROJECT_NAME} ${all_files})

target_sources(${PROJECT_NAME} PRIVATE ${sources} ${resources})

target_compile_definitions(
  ${PROJECT_NAME} PUBLIC ${Qt6Widgets_DEFINITIONS}
)

target_include_directories(
  ${PROJECT_NAME} PUBLIC $<INSTALL_INTERFACE:include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
          $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

target_link_libraries(
  ${PROJECT_NAME} PUBLIC Qt6::Core Qt6::Widgets Qt6::Gui ads::qtadvanceddocking FramelessHelper::Widgets
)

# set qt moc sources
qt_wrap_cpp(
  creator_moc
  ${headers}
  TARGET
  ${PROJECT_NAME}
  OPTIONS
  --no-notes # Don't display a note for the headers which don't produce a
             # moc_*.cpp
)

# add qt moc sources
target_sources(${PROJECT_NAME} PRIVATE ${creator_moc})

# copy qt dependency
add_custom_command(
  TARGET ${PROJECT_NAME}
  POST_BUILD
  COMMAND Qt6::windeployqt "--no-translations"
          $<TARGET_FILE:${PROJECT_NAME}>
  WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJECT_NAME}>
)
# copy other dependency
add_custom_command(
  TARGET ${PROJECT_NAME}
  POST_BUILD
  COMMAND
    ${CMAKE_COMMAND} -E copy_if_different $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}>
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
  COMMAND_EXPAND_LISTS
)
