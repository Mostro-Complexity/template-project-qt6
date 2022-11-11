find_package(Qt6 COMPONENTS Core LinguistTools REQUIRED)

function(generate_translations CUSTOM_TARGET TS_DIR TS_FILES SRC_DIR)
    set(UPDATE_TS_TARGET_NAME ${CUSTOM_TARGET}_ts)
    set(UPDATE_QM_TARGET_NAME ${CUSTOM_TARGET}_qm)

    add_custom_target(${UPDATE_TS_TARGET_NAME}
        COMMAND ${Qt6_LUPDATE_EXECUTABLE} -recursive ${SRC_DIR} -ts ${TS_FILES}
        WORKING_DIRECTORY ${TS_DIR})

    add_custom_target(${UPDATE_QM_TARGET_NAME}
        COMMAND ${Qt6_LRELEASE_EXECUTABLE} ${TS_FILES}
        WORKING_DIRECTORY ${TS_DIR})

    add_dependencies(${UPDATE_QM_TARGET_NAME} ${UPDATE_TS_TARGET_NAME})
    add_dependencies(${CUSTOM_TARGET} ${UPDATE_QM_TARGET_NAME})
endfunction()
