# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/hjabird/HBTK/archive/0.1.0.zip"
    FILENAME "hbtk-0.1.0.zip"
    SHA512 fd7568fb72599959abf9c249919af48f9a2483f16ab677a6810c8c2317e6c3e09253ec6e180723c6dc4c2cf58c23f06d9a6e22990ce3039e599ffbd7a0675d5b
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE} 
    # (Optional) A friendly name to use instead of the filename of the archive (e.g.: a version number or tag).
    # REF 1.0.0
    # (Optional) Read the docs for how to generate patches at: 
    # https://github.com/Microsoft/vcpkg/blob/master/docs/examples/patching.md
    # PATCHES
    #   001_port_fixes.patch
    #   002_more_port_fixes.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
					${CURRENT_PACKAGES_DIR}/release/include)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/hbtk/cmake)
file(RENAME 		${CURRENT_PACKAGES_DIR}/lib/cmake/hbtk/hbtk-targets.cmake
					${CURRENT_PACKAGES_DIR}/share/hbtk/cmake/hbtk-targets.cmake)
file(RENAME 		${CURRENT_PACKAGES_DIR}/lib/cmake/hbtk/hbtk-targets-release.cmake
					${CURRENT_PACKAGES_DIR}/share/hbtk/cmake/hbtk-targets-release.cmake)
file(RENAME 		${CURRENT_PACKAGES_DIR}/debug/lib/cmake/hbtk/hbtk-targets-debug.cmake
					${CURRENT_PACKAGES_DIR}/share/hbtk/cmake/hbtk-targets-debug.cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake
					${CURRENT_PACKAGES_DIR}/lib/cmake)	
file(COPY			${CURRENT_PORT_DIR}/LICENSE
					DESTINATION ${CURRENT_PACKAGES_DIR}/share/hbtk/copyright)
