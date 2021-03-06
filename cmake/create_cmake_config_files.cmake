#######################################################################################################################
# create_cmake_config_files.cmake
#
# Create the Find${PROJECT_NAME}.cmake cmake macro and the ${PROJECT_NAME}-config shell script and installs them.
#
# Expects the following input variables:
#   ${PROJECT_NAME}_SOVERSION - version of the .so library file
#   ${PROJECT_NAME}_INCLUDE_DIRS - list include directories needed when compiling against this project
#   ${PROJECT_NAME}_LIBRARY_DIRS - list of library directories needed when linking against this project
#   ${PROJECT_NAME}_LIBRARIES - list of libraries needed when linking against this project
#   ${PROJECT_NAME}_CPPFLAGS - list of C++ compiler flags when compiling against this project
#   ${PROJECT_NAME}_LDFLAGS - list of linker flags when linking against this project
#
#######################################################################################################################

# check that all config variables which have to be replaced are set
foreach(CONFIG_VARIABLE SOVERSION INCLUDE_DIRS LIBRARY_DIRS LIBRARIES CPPFLAGS LDFLAGS)
  if(DEFINED ${${PROJECT_NAME}_${CONFIG_VARIABLE}} )
    message(FATAL_ERROR "${PROJECT_NAME}_${CONFIG_VARIABLE} not set in CMakeListst.txt")
  endif()
endforeach()

# create variables for standard makefiles
set(${PROJECT_NAME}_CPPFLAGS_MAKEFILE "${${PROJECT_NAME}_CPPFLAGS}")

string(REPLACE " " ";" LIST ${${PROJECT_NAME}_INCLUDE_DIRS})
foreach(INCLUDE_DIR ${LIST})
  set(${PROJECT_NAME}_CPPFLAGS_MAKEFILE "${${PROJECT_NAME}_CPPFLAGS_MAKEFILE} -I${INCLUDE_DIR}")
endforeach()

set(${PROJECT_NAME}_LDFLAGS_MAKEFILE "${${PROJECT_NAME}_LDFLAGS}")

string(REPLACE " " ";" LIST ${${PROJECT_NAME}_LIBRARY_DIRS})
foreach(LIBRARY_DIR ${LIST})
  set(${PROJECT_NAME}_LDFLAGS_MAKEFILE "${${PROJECT_NAME}_LDFLAGS_MAKEFILE} -L${LIBRARY_DIR}")
endforeach()

string(REPLACE " " ";" LIST ${${PROJECT_NAME}_LIBRARIES})
foreach(LIBRARY ${LIST})
  set(${PROJECT_NAME}_LDFLAGS_MAKEFILE "${${PROJECT_NAME}_LDFLAGS_MAKEFILE} -l${LIBRARY}")
endforeach()

# we have nested @-statements, so we have to parse twice:

# create the cmake Find package script
configure_file(cmake/FindPROJECT_NAME.cmake.in.in "${PROJECT_BINARY_DIR}/cmake/Find${PROJECT_NAME}.cmake.in")
configure_file(${PROJECT_BINARY_DIR}/cmake/Find${PROJECT_NAME}.cmake.in "${PROJECT_BINARY_DIR}/Find${PROJECT_NAME}.cmake")

# create the shell script for standard make files
configure_file(cmake/PROJECT_NAME-config.in.in "${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.in")
configure_file(${PROJECT_BINARY_DIR}/cmake/${PROJECT_NAME}-config.in "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config")

# install the script
install(FILES "${PROJECT_BINARY_DIR}/Find${PROJECT_NAME}.cmake"
  DESTINATION share/cmake-${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}/Modules COMPONENT dev)

install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config DESTINATION bin COMPONENT dev)

