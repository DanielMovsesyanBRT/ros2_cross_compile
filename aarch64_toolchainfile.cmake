# Copyright (c) 2018, ARM Limited.
# SPDX-License-Identifier: Apache-2.0

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
# specify the cross compiler
# set(CMAKE_C_COMPILER $ENV{CROSS_COMPILE}gcc)
# set(CMAKE_CXX_COMPILER $ENV{CROSS_COMPILE}g++)
# where is the target environment
# set(CMAKE_SYSROOT /home/daniel/Development/Distr/nvidia)

# This assumes that pthread will be available on the target system
# (this emulates that the return of the TRY_RUN is a return code "0"
set(THREADS_PTHREAD_ARG "0"
  CACHE STRING "Result from TRY_RUN" FORCE)

if(NOT DEFINED TOOLCHAIN_PREFIX)
  if (DEFINED ENV{TOOLCHAIN_PREFIX})
    set(TOOLCHAIN_PREFIX $ENV{TOOLCHAIN_PREFIX} CACHE STRING "Tool-chain prefix" FORCE)
  else()
    set(TOOLCHAIN_PREFIX "${CMAKE_SYSTEM_PROCESSOR}-gnu-linux")
  endif()
endif()


if(NOT DEFINED TOOLCHAIN_PATH)
  if(DEFINED ENV{TOOLCHAIN_PATH})
    message(STATUS "TOOLCHAIN_PATH = ENV : $ENV{TOOLCHAIN_PATH}")
    set(TOOLCHAIN_PATH $ENV{TOOLCHAIN_PATH} CACHE STRING "Path to the toolchain path for cross-compilation" FORCE)
  else()
    message(FATAL_ERROR "TOOLCHAIN_PATH Variable has to be specified")
  endif()
elseif(NOT DEFINED ENV{TOOLCHAIN_PATH})
  set(ENV{TOOLCHAIN_PATH} ${TOOLCHAIN_PATH})
endif()



set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}/${TOOLCHAIN_PREFIX}-g++")
set(CMAKE_C_COMPILER "${TOOLCHAIN_PATH}/${TOOLCHAIN_PREFIX}-gcc")

set(CMAKE_EXECUTABLE_RUNTIME_CXX_FLAG       "-Wl,-rpath,")       # -rpath
set(CMAKE_EXECUTABLE_RUNTIME_C_FLAG         "-Wl,-rpath,")       # -rpath
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG     "-Wl,-rpath,")
set(CMAKE_SHARED_LIBRARY_RUNTIME_CXX_FLAG   "-Wl,-rpath,")

if(NOT CMAKE_EXE_LINKER_FLAGS MATCHES ".*-Wl,--allow-shlib-undefined.*")
  string(APPEND CMAKE_EXE_LINKER_FLAGS " -Wl,--allow-shlib-undefined")
endif()

if(NOT CMAKE_SHARED_LINKER_FLAGS MATCHES ".*-Wl,--allow-shlib-undefined.*")
  string(APPEND CMAKE_SHARED_LINKER_FLAGS " -Wl,--allow-shlib-undefined")
endif()

# if(NOT CMAKE_STATIC_LINKER_FLAGS MATCHES ".*\-Wl,\-\-allow\-shlib-undefined.*")
#   string(APPEND CMAKE_STATIC_LINKER_FLAGS " -Wl,--allow-shlib-undefined")
# endif()

# setup compiler for cross-compilation
set(CMAKE_CXX_FLAGS           "-fPIC"               CACHE STRING "c++ flags")
set(CMAKE_C_FLAGS             "-fPIC"               CACHE STRING "c flags")
# set(CMAKE_SHARED_LINKER_FLAGS ""                    CACHE STRING "shared linker flags")
# set(CMAKE_MODULE_LINKER_FLAGS ""                    CACHE STRING "module linker flags")
# set(CMAKE_EXE_LINKER_FLAGS    ""                    CACHE STRING "executable linker flags")

if(NOT DEFINED CUDA_TOOLKIT_ROOT_DIR)
  if(DEFINED ENV{CUDA_TOOLKIT_ROOT_DIR})
    message(STATUS "TOOLCHAIN_PATH = ENV : $ENV{TOOLCHAIN_PATH}")
    set(CUDA_TOOLKIT_ROOT_DIR $ENV{CUDA_TOOLKIT_ROOT_DIR} CACHE STRING "CUDA path" FORCE)
  else()
    message(FATAL_ERROR "TOOLCHAIN_PATH Variable has to be specified")
  endif()
elseif(NOT DEFINED ENV{CUDA_TOOLKIT_ROOT_DIR})
  set(ENV{CUDA_TOOLKIT_ROOT_DIR} ${CUDA_TOOLKIT_ROOT_DIR})
endif()

set(CUDA_INCLUDE_DIRS "${CUDA_TOOLKIT_ROOT_DIR}/include")
set(CUDA_CUDART_LIBRARY "${CUDA_TOOLKIT_ROOT_DIR}/lib64")


set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/install /home/daniel/Development/Distr/nvidia/usr ${CUDA_TOOLKIT_ROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

