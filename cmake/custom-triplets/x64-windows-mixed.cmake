set(VCPKG_TARGET_ARCHITECTURE x64)
if(${PORT} MATCHES "qtbase")
	set(VCPKG_CRT_LINKAGE dynamic)
	set(VCPKG_LIBRARY_LINKAGE dynamic)
else()
	set(VCPKG_CRT_LINKAGE dynamic)
	set(VCPKG_LIBRARY_LINKAGE static)
endif()