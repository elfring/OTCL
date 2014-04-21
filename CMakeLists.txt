cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

if(DEFINED CMAKE_BUILD_TYPE)
   #set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
   #    "Choose the build type: None, Debug, Release, RelWithDebInfo or MinSizeRel.")
else()
   # Set the preferred default type for the software generation here.
   set(CMAKE_BUILD_TYPE "Release" CACHE STRING
       "Choose the build type: None, Debug, Release, RelWithDebInfo or MinSizeRel.")
endif()

project(OCaml_template_class_library NONE)

set(OCaml_template_class_library_VERSION_MAJOR 1)
set(OCaml_template_class_library_VERSION_MINOR 0)
set(OCaml_template_class_library_VERSION_PATCH 0)

set(OCaml_COMPILER_INTERFACE "ocamlopt.opt" CACHE FILEPATH
    "Which tool should compile an interface file for an OCaml module?")
set(my_base_modules
    obuffer
    ohashtbl
    omap
    omapping
    oqueue
    oset
    ostack
    ostream)

foreach(name ${my_base_modules} ogenlex)
   add_custom_command(OUTPUT ${name}.ml
                      COMMAND "${CMAKE_COMMAND}" -E copy "${PROJECT_SOURCE_DIR}/${name}.ml" "${PROJECT_BINARY_DIR}/${name}.ml"
                      MAIN_DEPENDENCY "${PROJECT_SOURCE_DIR}/${name}.ml"
                      COMMENT "copy the source file for \"${name}\" to the build directory"
                      VERBATIM)
   add_custom_command(OUTPUT ${name}.mli
                      COMMAND "${CMAKE_COMMAND}" -E copy "${PROJECT_SOURCE_DIR}/${name}.mli" "${PROJECT_BINARY_DIR}/${name}.mli"
                      MAIN_DEPENDENCY "${PROJECT_SOURCE_DIR}/${name}.mli"
                      COMMENT "copy the interface file for \"${name}\" to the build directory"
                      VERBATIM)
   add_custom_command(OUTPUT ${name}.cmi
                      COMMAND "${OCaml_COMPILER_INTERFACE}" ${name}.mli
                      MAIN_DEPENDENCY "${PROJECT_BINARY_DIR}/${name}.mli"
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "compilation for interface file of ${name}"
                      VERBATIM)
endforeach()

option(OCaml_BUILD_BYTECODE "Should bytecode be generated for OCaml source files?" ON)

if(OCaml_BUILD_BYTECODE)
   set(OCaml_COMPILER_BYTECODE "ocamlc.opt" CACHE FILEPATH
       "Which tool should compile an OCaml source file to a bytecode format?")

   set(my_parts "")
   set(my_debs "")

   foreach(name ${my_base_modules})
      list(APPEND my_parts ${name}.cmo)
      set(my_part "${PROJECT_BINARY_DIR}/${name}.cmo")
      list(APPEND my_debs "${my_part}")
      add_custom_command(OUTPUT "${my_part}"
                         COMMAND "${OCaml_COMPILER_BYTECODE}" -c ${name}.ml
                         MAIN_DEPENDENCY "${PROJECT_BINARY_DIR}/${name}.ml"
                         DEPENDS "${PROJECT_BINARY_DIR}/${name}.cmi"
                         WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                         COMMENT "compilation for ${name} ..."
                         VERBATIM)
   endforeach()

   add_custom_command(OUTPUT ogenlex.cmo
                      COMMAND "${OCaml_COMPILER_BYTECODE}" -c -pp camlp4o ogenlex.ml
                      MAIN_DEPENDENCY "${PROJECT_BINARY_DIR}/ogenlex.ml"
                      DEPENDS "${PROJECT_BINARY_DIR}/ogenlex.cmi"
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "compilation ..."
                      VERBATIM)

   set(OCaml_LIBRARIAN_BYTECODE "ocamlc.opt" CACHE FILEPATH
       "Which tool should generate a library from OCaml modules in bytecode format?")

   add_custom_command(OUTPUT stdclass.cma
                      COMMAND "${OCaml_LIBRARIAN_BYTECODE}" -a -o stdclass.cma ${my_parts}
                      DEPENDS ${my_debs}
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "generation of a bytecode library ..."
                      VERBATIM)
   add_custom_command(OUTPUT ogenlex.cma
                      COMMAND "${OCaml_LIBRARIAN_BYTECODE}" -a -o ogenlex.cma ogenlex.cmo
                      MAIN_DEPENDENCY ogenlex.cmo
                      DEPENDS "${PROJECT_BINARY_DIR}/obuffer.cmi"
                              "${PROJECT_BINARY_DIR}/ohashtbl.cmi"
                              "${PROJECT_BINARY_DIR}/ostream.cmi"
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "generation of a bytecode library ..."
                      VERBATIM)
   add_custom_target(bytecode ALL
                     DEPENDS "${PROJECT_BINARY_DIR}/stdclass.cma"
                             "${PROJECT_BINARY_DIR}/ogenlex.cma")
   add_custom_target(standard_classes_bytecode
                     DEPENDS "${PROJECT_BINARY_DIR}/stdclass.cma")
   add_custom_target(genlex_bytecode
                     DEPENDS "${PROJECT_BINARY_DIR}/ogenlex.cma")
endif()

option(OCaml_BUILD_NATIVE_CODE "Should native code be generated for OCaml source files?" ON)

if(OCaml_BUILD_NATIVE_CODE)
   set(OCaml_COMPILER_NATIVE "ocamlopt.opt" CACHE FILEPATH
       "Which tool should compile an OCaml source file to a native-code format?")

   set(my_parts "")
   set(my_debs "")

   foreach(name ${my_base_modules})
      list(APPEND my_parts ${name}.cmx)
      set(my_part "${PROJECT_BINARY_DIR}/${name}.cmx")
      list(APPEND my_debs "${my_part}")
      add_custom_command(OUTPUT "${my_part}"
                         COMMAND "${OCaml_COMPILER_NATIVE}" -c ${name}.ml
                         MAIN_DEPENDENCY "${PROJECT_BINARY_DIR}/${name}.ml"
                         DEPENDS "${PROJECT_BINARY_DIR}/${name}.cmi"
                         WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                         COMMENT "compilation for ${name} ..."
                         VERBATIM)
   endforeach()

   add_custom_command(OUTPUT ogenlex.cmx
                      COMMAND "${OCaml_COMPILER_NATIVE}" -c -pp camlp4o ogenlex.ml
                      MAIN_DEPENDENCY "${PROJECT_BINARY_DIR}/ogenlex.ml"
                      DEPENDS "${PROJECT_BINARY_DIR}/ogenlex.cmi"
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "compilation ..."
                      VERBATIM)

   set(OCaml_LIBRARIAN_NATIVE "ocamlopt.opt" CACHE FILEPATH
       "Which tool should generate a library from OCaml modules in native-code format?")

   add_custom_command(OUTPUT stdclass.cmxa
                      COMMAND "${OCaml_LIBRARIAN_NATIVE}" -a -o stdclass.cmxa ${my_parts}
                      DEPENDS ${my_debs}
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "generation of a native-code library ..."
                      VERBATIM)
   add_custom_command(OUTPUT ogenlex.cmxa
                      COMMAND "${OCaml_LIBRARIAN_NATIVE}" -a -o ogenlex.cmxa ogenlex.cmx
                      MAIN_DEPENDENCY ogenlex.cmx
                      DEPENDS "${PROJECT_BINARY_DIR}/obuffer.cmi"
                              "${PROJECT_BINARY_DIR}/ohashtbl.cmi"
                              "${PROJECT_BINARY_DIR}/ostream.cmi"
                      WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
                      COMMENT "generation of a native-code library ..."
                      VERBATIM)
   add_custom_target(native ALL
                     DEPENDS "${PROJECT_BINARY_DIR}/stdclass.cmxa"
                             "${PROJECT_BINARY_DIR}/ogenlex.cmxa")
   add_custom_target(standard_classes_native
                     DEPENDS "${PROJECT_BINARY_DIR}/stdclass.cmxa")
   add_custom_target(genlex_native
                     DEPENDS "${PROJECT_BINARY_DIR}/ogenlex.cmxa")
endif()
