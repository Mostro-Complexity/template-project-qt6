if(NOT template-gen_Found)
    if(NOT DEFINED template-gen_URL)
        if(WIN32)
            set(template-gen_URL "https://devops-generic.pkg.coding.smoa.cloud/SmartCam/dependencies/TemplateGen-win64.zip?version=latest")
        else()
            message(FATEL_ERROR "only support win32")
        endif()
    endif()

    include(FetchContent)
    FetchContent_Declare(template-gen
        URL ${template-gen_URL}
    )
    message(STATUS "Fetching template-gen : ${template-gen_URL}")
    FetchContent_MakeAvailable(template-gen)
    message(STATUS "Fetching done")

    FetchContent_GetProperties(template-gen SOURCE_DIR template-gen_SOURCE_DIR)
    message(STATUS "template-gen src dir : ${template-gen_SOURCE_DIR}")

    if(WIN32)
        set(template-gen_DIR ${template-gen_SOURCE_DIR}/lib/cmake/template-gen)
        message(STATUS "template-gen DIR : ${template-gen_DIR}")
    else()
        message(FATEL_ERROR "only support win32")
    endif()
endif()