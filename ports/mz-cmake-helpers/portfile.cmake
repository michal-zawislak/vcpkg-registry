set(VCPKG_POLICY_CMAKE_HELPER_PORT enabled)
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO michal-zawislak/cmake-helpers
    REF "v${VERSION}"
    SHA512 55e64eccb841a761cfc11d22ffeacaba29a31c316d1bf2afbe7aea62b8ec2834945b21f7bdeec704fdaa3227b18cd9d64388eb32540960a5445bf4b42084dc4e
    HEAD_REF main
)

file(GLOB helper_scripts "${SOURCE_PATH}/*.cmake")
if(NOT helper_scripts)
    message(FATAL_ERROR "No *.cmake files found in ${SOURCE_PATH}")
endif()
file(INSTALL ${helper_scripts} DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/${PORT}-config.cmake" [=[
include_guard(GLOBAL)
file(GLOB _mz_helper_scripts "${CMAKE_CURRENT_LIST_DIR}/*.cmake")
foreach(_script IN LISTS _mz_helper_scripts)
  if(NOT _script MATCHES "-config\\.cmake$")
    include("${_script}")
  endif()
endforeach()
unset(_mz_helper_scripts)
set(mz-cmake-helpers_FOUND TRUE)
]=])

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/vcpkg-port-config.cmake" "...")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")