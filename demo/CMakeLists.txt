add_definitions (${CFLAGS} "-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")

set (EXEC_NAME ${PROJECT_NAME}-demo)

#
# Packages in PKG_DEPS are used with the vala compiler and other related tools (not versioned.)
# Packages in PKG_DEPS_CHECK are used with PKG-Config and for linking, etc. They can contain versions.
#
# Both should contain *the same packages*, except for those whose VAPI file has a different name. In
# such case, PKG_DEPS would use the name of the VAPI, and PKG_DEPS_CHECK would use the name of the
# package known by pkg-config.
#
set (DEMO_PKG_DEPS
    granite>=0.3
    glib-2.0
    ${PKG_DEPS})

set (DEMO_PKG_DEPS_CHECK
    granite>=0.3
    glib-2.0
    ${PKG_DEPS_CHECK})

# Check for the deps
find_package (PkgConfig)
pkg_check_modules (DEMO_DEPS REQUIRED ${DEMO_PKG_DEPS_CHECK})

get_target_property (BASALT_VAPI_FILES basalt VAPI_FILES)

vala_precompile (VALA_C ${EXEC_NAME}
    Demo.vala
PACKAGES
    ${DEMO_PKG_DEPS}
CUSTOM_VAPIS
    ${BASALT_VAPI_FILES}
OPTIONS
    ${VALAC_OPTIONS}
)

add_executable (${EXEC_NAME} EXCLUDE_FROM_ALL ${VALA_C})
target_link_libraries (${EXEC_NAME} ${PROJECT_NAME} ${DEMO_DEPS_LIBRARIES})
target_compile_options (${EXEC_NAME} PRIVATE ${DEMO_DEPS_CFLAGS})
