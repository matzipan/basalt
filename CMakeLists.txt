project (basalt C)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

set (API_VERSION 1.0)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/)

find_package (Vala REQUIRED)
include (ValaVersion)
include (ValaPrecompile)

ensure_vala_version ("0.23.2" MINIMUM)

#
# Packages in PKG_DEPS are used with the vala compiler and other related tools (not versioned.)
# Packages in PKG_DEPS_CHECK are used with PKG-Config and for linking, etc. They can contain versions.
#
# Both should contain *the same packages*, except for those whose VAPI file has a different name. In
# such case, PKG_DEPS would use the name of the VAPI, and PKG_DEPS_CHECK would use the name of the
# package known by pkg-config.
#
set (PKG_DEPS
    gtk+-3.0
    gee-0.8
    posix)

set (PKG_DEPS_CHECK
    gtk+-3.0>=3.14
    gee-0.8)

# Check for the deps
find_package (PkgConfig)
pkg_check_modules (DEPS REQUIRED ${PKG_DEPS_CHECK})

set (VALAC_OPTIONS
     --thread
     --target-glib=2.32)

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --define=LINUX)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "DragonFly")
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --define=DRAGON_FLY)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --define=FFREE_BSD)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "NetBSD")
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --define=NET_BSD)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "OpenBSD")
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --define=OPEN_BSD)
endif ()

add_subdirectory (lib)
# add_subdirectory (demo) @TODO
