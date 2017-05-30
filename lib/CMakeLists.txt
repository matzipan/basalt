set (VALA_SOURCES
    Widgets/Sidebar/SidebarParentRowModel.vala
    Widgets/Sidebar/SidebarHeaderModel.vala
    Widgets/Sidebar/SidebarExpandableRowModel.vala
    Widgets/Sidebar/SidebarRowModel.vala
    Widgets/Sidebar/SidebarHeader.vala
    Widgets/Sidebar/SidebarExpandableRow.vala
    Widgets/Sidebar/SidebarRow.vala
    Widgets/Sidebar/Sidebar.vala
    Widgets/Sidebar/SidebarStore.vala
    Widgets/Sidebar/IndicatorBar.vala
    Widgets/Sidebar/CustomPixbuf.vala
    Widgets/Sidebar/PixbuffableIcon.vala
)

# Link all
set (CFLAGS ${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER})
add_definitions (${CFLAGS} "-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")

set (LIBS ${DEPS_LIBRARIES} -lm)
set (LIB_PATHS ${DEPS_LIBRARY_DIRS})
link_directories (${LIB_PATHS})

option (VAPI_COMMENTS "Include comments in the generated vapi file" OFF)

if (VAPI_COMMENTS)
    set (VALAC_OPTIONS ${VALAC_OPTIONS} --vapi-comments)
endif ()

vala_precompile (VALA_C ${PROJECT_NAME}
    ${VALA_SOURCES}
PACKAGES
    ${PKG_DEPS}
GENERATE_HEADER
    ${PROJECT_NAME}
GENERATE_VAPI
    ${PROJECT_NAME}
CUSTOM_VAPIS
    ${CMAKE_CURRENT_SOURCE_DIR}/config.vapi
OPTIONS
    ${VALAC_OPTIONS}
)

set (LIB_FILES ${C_SOURCES} ${VALA_C})

add_library (${PROJECT_NAME} ${LIB_FILES})

target_link_libraries (${PROJECT_NAME} ${LIBS})