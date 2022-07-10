# Taken from https://github.com/thegeeko/geg/blob/master/geg/cmake/modules/FindShaderc.cmake#L3. 

include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

find_library(SHADERC_LIBRARY_DEBUG NAMES shaderc_combinedd shaderc_combined HINTS $ENV{VULKAN_SDK} PATH_SUFFIXES lib DEBUG/lib)
find_library(SHADERC_LIBRARY_RELEASE NAMES shaderc_combined HINTS $ENV{VULKAN_SDK} PATH_SUFFIXES lib)
find_path(SHADERC_INLCUDE_DIRS NAMES shaderc/shaderc.h HINTS $ENV{VULKAN_SDK} PATH_SUFFIXES include)
find_program(GLSLANG_VALIDATOR_EXE NAMES glslangValidator HINTS $ENV{VULKAN_SDK} PATH_SUFFIXES bin)

select_library_configurations(SHADERC)

find_package_handle_standard_args(
	Shaderc
	DEFAULT_MSG
	SHADERC_LIBRARY
	SHADERC_INLCUDE_DIRS
	GLSLANG_VALIDATOR_EXE
)

if(WIN32)
	execute_process(COMMAND powershell "-c" "ls ${CMAKE_SOURCE_DIR}/VULKAN_SDK")
	execute_process(COMMAND powershell "-c" "ls ${CMAKE_SOURCE_DIR}/VULKAN_SDK")
else()
	execute_process(COMMAND bash "-c" "ls ${CMAKE_SOURCE_DIR}/VULKAN_SDK")
	execute_process(COMMAND bash "-c" "ls ${CMAKE_SOURCE_DIR}/VULKAN_SDK")
endif()

message(STATUS "${SHADERC_LIBRARY}")

# if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
# 	message(STATUS "CMAKE BUILD IS DEBUG")
# endif()

# if(NOT ${SHADERC_LIBRARY_DEBUG} MATCHES "shaderc_combinedd")
# 	message(STATUS "shaderc does not match debug")
# endif()

# if(${SHADERC_LIBRARY_DEBUG} MATCHES "shaderc_combinedd")
# 	message(STATUS "shaderc matches debug")
# endif()

if(NOT(NOT (${SHADERC_LIBRARY_DEBUG} MATCHES "shaderc_combinedd") AND ${CMAKE_BUILD_TYPE} STREQUAL "Debug"))
	message(WARNING "shaderc in release, build in debug. Unable to compile runtime shaders")
else()
	add_compile_definitions(RUSH_SHADER_COMPILE) #set macro for shader compiling (see src/backends/vulkan/shader.hpp)
endif()

add_executable(glslangValidator IMPORTED)
set_target_properties(glslangValidator PROPERTIES IMPORTED_LOCATION ${GLSLANG_VALIDATOR_EXE})

add_library(shaderc UNKNOWN IMPORTED)

set_target_properties(
	shaderc
		PROPERTIES
			IMPORTED_LOCATION_DEBUG ${SHADERC_LIBRARY_DEBUG}
			IMPORTED_LOCATION_RELEASE ${SHADERC_LIBRARY_RELEASE}
			IMPORTED_LOCATION ${SHADERC_LIBRARY_RELEASE}
			INTERFACE_INCLUDE_DIRECTORIES ${SHADERC_INLCUDE_DIRS}
)