include(FetchContent)

FetchContent_Declare(
  framelesshelper
  GIT_REPOSITORY https://github.com/wangwenx190/framelesshelper.git
  GIT_TAG 2.3.3
  GIT_SHALLOW ON
)

FetchContent_MakeAvailable(framelesshelper)
