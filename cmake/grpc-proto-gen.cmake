function(GRPC_GENERATE_CPP SRCS HDRS)
    cmake_parse_arguments(grpc "" "" "" ${ARGN})

    set(PROTO_FILES "${grpc_UNPARSED_ARGUMENTS}")

    if(NOT PROTO_FILES)
        message(SEND_ERROR "Error: GRPC_GENERATE_CPP() called without any proto files")
        return()
    endif()

    if(GRPC_GENERATE_CPP_APPEND_PATH)
        # Create an include path for each file specified
        foreach(FIL ${PROTO_FILES})
            get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
            get_filename_component(ABS_PATH ${ABS_FIL} PATH)
            list(FIND _grpc_include_path ${ABS_PATH} _contains_already)

            if(${_contains_already} EQUAL -1)
                list(APPEND _grpc_include_path -I ${ABS_PATH})
            endif()
        endforeach()
    else()
        set(_grpc_include_path -I ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    if(DEFINED GRPC_IMPORT_DIRS)
        foreach(DIR ${GRPC_IMPORT_DIRS})
            get_filename_component(ABS_PATH ${DIR} ABSOLUTE)
            list(FIND _grpc_include_path ${ABS_PATH} _contains_already)

            if(${_contains_already} EQUAL -1)
                list(APPEND _grpc_include_path -I ${ABS_PATH})
            endif()
        endforeach()
    endif()

    set(${SRCS})
    set(${HDRS})

    foreach(FIL ${PROTO_FILES})
        get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
        get_filename_component(FIL_WE ${FIL} NAME_WE)

        if(NOT GRPC_GENERATE_CPP_APPEND_PATH)
            get_filename_component(FIL_DIR ${FIL} DIRECTORY)

            if(FIL_DIR)
                set(FIL_WE "${FIL_DIR}/${FIL_WE}")
            endif()
        endif()

        list(APPEND ${SRCS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.cc")
        list(APPEND ${SRCS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc")
        list(APPEND ${HDRS} "${CMAKE_CURRENT_BINARY_DIR}/")
        list(APPEND ${HDRS} "${CMAKE_CURRENT_BINARY_DIR}/")

        add_custom_command(
            OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.cc"
            "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.h"
            "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc"
            "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.h"
            COMMAND protobuf::protoc
            ARGS "--cpp_out=${CMAKE_CURRENT_BINARY_DIR}"
            "--descriptor_set_out=${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.descriptor"
            ${_grpc_include_path}
            ${ABS_FIL}
            COMMAND protobuf::protoc
            ARGS "--grpc_out=${CMAKE_CURRENT_BINARY_DIR}"
            "--plugin=protoc-gen-grpc=$<TARGET_FILE:gRPC::grpc_cpp_plugin>"
            ${_grpc_include_path}
            ${ABS_FIL}
            DEPENDS ${ABS_FIL} protobuf::protoc gRPC::grpc_cpp_plugin
            COMMENT "Running C++ protocol buffer compiler on ${FIL}"
            VERBATIM
        )
    endforeach()

    set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)
    set(${SRCS} ${${SRCS}} PARENT_SCOPE)
    set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()
