include(FetchContent)

FetchContent_Declare(ads 
    URL "https://devops-generic.pkg.coding.smoa.cloud/SmartCam/dependencies/Qt-Advanced-Docking-System-3.8.3.zip?version=latest"
)

FetchContent_MakeAvailable(ads)

FetchContent_GetProperties(ads SOURCE_DIR ads_DIR)
list(APPEND CMAKE_PREFIX_PATH ${ads_DIR})
