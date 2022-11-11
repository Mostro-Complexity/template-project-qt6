cmake_minimum_required(VERSION 3.21)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

set(PROJECT_NAME smart-camera)

include(vcpkg)

project(${PROJECT_NAME})

list(APPEND source_dirs ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

add_compile_options(
  $<$<AND:$<NOT:$<COMPILE_LANGUAGE:CUDA>>,$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>>:/MP8>
)

# decide compiler frontend variant, an optional condition is
# CMAKE_<LANG>_COMPILER_ID
if("${CMAKE_CXX_SIMULATE_ID}" STREQUAL "Clang") # using clang
  add_compile_options(-Qunused-arguments)
elseif("${CMAKE_CXX_SIMULATE_ID}" STREQUAL "GNU") # using GCC

elseif("${CMAKE_CXX_SIMULATE_ID}" STREQUAL "Intel") # using Intel C++

elseif("${CMAKE_CXX_SIMULATE_ID}" STREQUAL "MSVC" OR "${CMAKE_CXX_SIMULATE_ID}"
                                                     STREQUAL ""
) # using Visual Studio C++
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")

option(BUILD_DEBUG_POSTFIX_D "Append d suffix to debug libraries" ON)
option(BUILD_SHARED_LIBS "Build shared libs" OFF)
option(BUILD_SMARTCAM_SHARED_LIBS "Build smart camera shared libs" ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CPACK_GENERATOR "ZIP")
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

set(BUILD_EXAMPLES OFF CACHE BOOL "build examples" FORCE)
set(ADS_VERSION "3.8.3" CACHE STRING "to skip git checks" FORCE)
set(FRAMELESSHELPER_BUILD_EXAMPLES OFF CACHE BOOL "build FramelessHelper demo applications." FORCE)
set(QT_VERSION_MAJOR "6" CACHE STRING "qt major version" FORCE)

include(CPack)
include(fetch/ads)
include(fetch/FramelessHelper)

add_subdirectory(example)
