#CMAKE best practices document : CMAKE Introduction and best practices by Daniel Pfeifer, 21 May 2015
#Also found here : https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1
#
# ∙ CMake sets several variables based on project().
# ∙ Call to project() must be direct, not through a function/macro/include.
# ∙ CMake will add a call to project() if not found on the top level.
# ∙ Embed projects as sub-projects.
# ∙ CMake creates a Makefile/Solution for each subproject.
# ∙ The subproject does not have to reside in a subfolder.
# ∙ Make sure that all your projects can be built both standalone 
#     and as a subproject of another project
# ∙ Don’t assume that your project root is the build root.
# ∙ Don’t modify global compile/link flags.
# ∙ Don’t make any global changes!
# ∙ Don’t add -std=c++11 to CMAKE_<LANG>_FLAGS.
# ∙ Don’t pass -std=c++11 to target_compile_options().
# ∙ Goal: No cmake custom variables.
# ∙ Goal: No cmake custom functions.

# -----------------------------------------------------
cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)

# -----------------------------------------------------
#https://cmake.org/cmake/help/v3.18/command/add_compile_options.html
if (MSVC)
    # warning level 4 and all warnings as errors
    add_compile_options(/W4 /WX)
else()
    # lots of warnings and all warnings as errors
    add_compile_options(-Wall -Wextra -pedantic -Werror)
endif()

# -----------------------------------------------------
#Project name.
project (helloProject LANGUAGES CXX)

# -----------------------------------------------------
#https://cmake.org/cmake/help/latest/command/add_executable.html
#Adds an executable target called 'Hello' to be built from the source files listed.
#Will also be the alias target in Cmake file, Create target 'Hello'
#Not Recommended to :
# file(GLOB sources ”*.cpp”)
# add_executable(Hello ${sources})
#list all sources explicitly
add_executable(Hello 
  src/hello.cxx
  #src/file1.cpp
  #src/file2.cpp
  #src/another_file.cpp
  )
# remove me ? => add_executable(hello::my_class ALIAS Hello)

# -----------------------------------------------------
#Default C++ is 14, we need to set it explicitly to 17
#https://cmake.org/cmake/help/latest/command/target_compile_features.html
#https://cmake.org/cmake/help/latest/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
#Specifies compiler features required when compiling a given target
target_compile_features(Hello PRIVATE cxx_std_17)
# INFO : If add feature that require another feature, it must be noted that if the new feature added requires an additional compiler flag, 
#        such as -std=gnu++11, the flag will be added automatically.

# -----------------------------------------------------
#https://cmake.org/cmake/help/latest/command/include_directories.html
#Bring the headers, such as Student.h into the project
#include_directories(include)
#
#Note Prefer the target_include_directories() command to add include directories to individual targets
#https://cmake.org/cmake/help/latest/command/target_include_directories.html
#PUBLIC    : both this library and all linked program/libraries
#PRIVATE   : only this library
#INTERFACE : only linked program/libraries. This library will not be able to use it in itself
#
#Set include directories.
target_include_directories(Hello
   PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
   )

# -----------------------------------------------------
# Include volk as part of the build tree to make the target known.
#
# We do not modify the source code (volk.c), so no need to use cmake_using_source_directly
# because maybe overhead at dynamic runtime load.
# We do not want to install volk library on the system (/usr/lib), so we cannot use cmake_using_installed_headers
# It is valid option to choose static built library and build it (include everything) inside the project.
#   so another valid option is to use cmake_using_subdir_static
#
# For the moment the choosen solution is include header only, cmake_using_subdir_headers
#https://cmake.org/cmake/help/latest/command/add_subdirectory.html?highlight=add_subdirectory
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/libs/volk volk)

# -----------------------------------------------------
#https://cmake.org/cmake/help/latest/command/add_library.html
#Libraries can be INTERFACE or MODULE.
#
# ∙ Always add namespaced aliases for libraries.
# ∙ Leave the control of BUILD_SHARED_LIBS to your clients!
# ∙ Dont’t make libraries STATIC/SHARED unless they cannot be built otherwise.
# ∙ Default can be controlled with BUILD_SHARED_LIBS. You get to pick a type of library, STATIC, SHARED, or MODULE. 
#      If you leave this choice off, the value of BUILD_SHARED_LIBS will be used to pick between STATIC and SHARED.
#      cmake -D BUILD_SHARED_LIBS=TRUE => SHARED    if =FALSE => STATIC (default value)
# ∙ MODULE are used in general to represent "plugins" for other software.
#      It will manifest itself as a shared library but cannot be linked into other libraries.
#      You can't target_link_libraries() to the MODULE library, MODULE are intended to be loaded using dlopen only.
#
# add_library(foo
#  foo1.cpp
#  foo2.cpp
#  )
# add_library(my::foo ALIAS foo)

# -----------------------------------------------------
#https://cmake.org/cmake/help/latest/command/target_link_libraries.html
#Set libraries as dependency.
#PRIVATE Only used for this target.
#PUBLIC Used for this target and all targets that link against it.
#INTERFACE Only used for targets that link against this library.
#
# ∙ Prefer to link against namespaced targets.
# ∙ Specify the dependencies are private or public.
# ∙ Avoid the link_libraries() command.
# ∙ Avoid the link_directories() command.
# ∙ No need to call add_dependencies().
#
# Link the executable to the xyz library. 
# Since the xyz library has public include directories 
# we will use those link directories when building foobar
# target_link_libraries (foobar PUBLIC xyz)
#
target_link_libraries( Hello 
  PUBLIC volk::volk_headers
  )
