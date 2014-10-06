# The following settings were derived from this article:
# http://cmake.org/Wiki/CMake:Component_Install_With_CPack#Principles_of_CPack_Component_Packaging

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${my_project_description}")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
set(CPACK_PACKAGE_CONTACT "Markus Elfring")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_VERSION_MAJOR "${OCaml_template_class_library_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${OCaml_template_class_library_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${OCaml_template_class_library_VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "OTCL-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}")

if(CPACK_BINARY_DEB)
   set(CPACK_DEBIAN_PACKAGE_DEPENDS "ocaml (>= ${OCAML_VERSION_MINIMUM})")
endif()

if(CPACK_BINARY_RPM)
   set(CPACK_RPM_PACKAGE_REQUIRES "ocaml >= ${OCAML_VERSION_MINIMUM}")
endif()

include(CPack)
