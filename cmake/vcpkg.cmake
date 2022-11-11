include(FetchContent)

set(USE_VCPKG_AS_SUBMODULE ON CACHE BOOL "Whether to use vcpkg as a submodule")
set(vcpkg_ROOT_DIR ${CMAKE_SOURCE_DIR}/third_party/vcpkg)

if(USE_VCPKG_AS_SUBMODULE)
    message(STATUS "Fetching vcpkg as submodule")
    if(NOT EXISTS ${vcpkg_ROOT_DIR})
        execute_process(
            COMMAND git clone https://github.com/microsoft/vcpkg --branch=master ${vcpkg_ROOT_DIR}
        )
    endif()
    message(STATUS "Fetched vcpkg as submodule")
    set(CMAKE_TOOLCHAIN_FILE ${vcpkg_ROOT_DIR}/scripts/buildsystems/vcpkg.cmake
        CACHE STRING "vcpkg toolchain file"
    )
    set(VCPKG_OVERLAY_TRIPLETS ${CMAKE_CURRENT_LIST_DIR}/custom-triplets)
    set(VCPKG_TARGET_TRIPLET "x64-windows-mixed" CACHE STRING "vcpkg triplet")
    set(VCPKG_INSTALLED_DIR ${CMAKE_SOURCE_DIR}/third_party/vcpkg_installed)
    set(VCPKG_MAX_CONCURRENCY 22)
    set(VCPKG_BINARY "${vcpkg_ROOT_DIR}/vcpkg")
    set(VCPKG_BOOTSTRAP_SCRIPT "${vcpkg_ROOT_DIR}/bootstrap-vcpkg.sh")
    if(NOT EXISTS ${VCPKG_BINARY})
        message(STATUS "Bootstraping vcpkg")
        execute_process(COMMAND "${VCPKG_BOOTSTRAP_SCRIPT}")
    endif()

endif()
