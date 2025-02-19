project(opendds_idl_compiler_tests CXX)
cmake_minimum_required(VERSION 3.8.2)

find_package(OpenDDS REQUIRED)

OPENDDS_SAVE_CACHE(OPENDDS_AUTO_LINK_DCPS BOOL ON)
OPENDDS_SAVE_CACHE(OPENDDS_USE_CORRECT_INCLUDE_SCOPE BOOL ON)

macro(subtest name)
  set(target "${PROJECT_NAME}_${name}")
  add_library(${target})
  set(idl_file "${CMAKE_CURRENT_BINARY_DIR}/${name}.idl")
  configure_file(test.idl "${idl_file}" COPYONLY)
endmacro()

function(remove_build_interface incs out_var)
  foreach(inc ${incs})
    string(REGEX REPLACE "\\$<BUILD_INTERFACE:" "" inc "${inc}")
    string(REGEX REPLACE ">\$" "" inc "${inc}")
    list(APPEND out "${inc}")
  endforeach()
  set("${out_var}" "${out}" PARENT_SCOPE)
endfunction()

function(assert_includes target public_and_interface public_and_private)
  get_target_property(interface_include_directories ${target} INTERFACE_INCLUDE_DIRECTORIES)
  remove_build_interface("${interface_include_directories}" interface_include_directories)
  foreach(inc ${public_and_interface})
    if(NOT "${inc}" IN_LIST interface_include_directories)
      message(SEND_ERROR "ERROR: ${target} expected ${inc} in public/interface includes")
    endif()
  endforeach()
  if(interface_include_directories)
    foreach(inc ${interface_include_directories})
      if(NOT "${inc}" IN_LIST public_and_interface)
        message(SEND_ERROR "ERROR: ${target} unexpected ${inc} in public/interface includes")
      endif()
    endforeach()
  endif()
  get_target_property(include_directories ${target} INCLUDE_DIRECTORIES)
  remove_build_interface("${include_directories}" include_directories)
  foreach(inc ${public_and_private})
    if(NOT ${inc} IN_LIST include_directories)
      message(SEND_ERROR "ERROR: ${target} expected ${inc} in public/private includes")
    endif()
  endforeach()
  if(include_directories)
    foreach(inc ${include_directories})
      if(NOT ${inc} IN_LIST public_and_private)
        message(SEND_ERROR "ERROR: ${target} unexpected ${inc} in public/private includes")
      endif()
    endforeach()
  endif()
endfunction()

set(opendds_gen "${CMAKE_CURRENT_BINARY_DIR}/opendds_generated")

subtest(no_scope)
OPENDDS_TARGET_SOURCES(${target} ${idl_file})
assert_includes(${target} "" "${opendds_gen}")

subtest(public)
OPENDDS_TARGET_SOURCES(${target} PUBLIC ${idl_file})
assert_includes(${target} "${opendds_gen}" "${opendds_gen}")

subtest(interface)
OPENDDS_TARGET_SOURCES(${target} INTERFACE ${idl_file})
assert_includes(${target} "${opendds_gen}" "${opendds_gen}")

subtest(private)
OPENDDS_TARGET_SOURCES(${target} PRIVATE ${idl_file})
assert_includes(${target} "" "${opendds_gen}")

subtest(o_opt)
OPENDDS_TARGET_SOURCES(${target} ${idl_file}
  OPENDDS_IDL_OPTIONS -o opendds-idl-output
  TAO_IDL_OPTIONS -o tao-idl-output)
assert_includes(${target} "" "${opendds_gen}/opendds-idl-output;${opendds_gen}/tao-idl-output")

OPENDDS_RESTORE_CACHE()
