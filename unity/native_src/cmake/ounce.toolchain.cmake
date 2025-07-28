
set(SDK_ROOT "$ENV{NINTENDO_SDK_ROOT}" CACHE PATH "Nintendo SDK 根目录")
set(__COMPILER_NX 1)
set(CMAKE_SYSTEM_NAME Ounce64)  # Switch操作系统标识
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(CMAKE_SUPPRESS_REGENERATION TRUE)
# Set file suffixes/prefixes
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_STATIC_LIBRARY_SUFFIX_CXX ".a")

set(CMAKE_SHARED_LIBRARY_SUFFIX ".nss")

# 从环境变量获取 SDK 路径
macro(assert_path_exists path)
  if (NOT EXISTS "${path}")
    message(FATAL_ERROR "Path <${path}> does not exist")
  endif()
endmacro()
assert_path_exists(${SDK_ROOT})
# set(CMAKE_BUILD_TYPE Debug, Develop, Release)

# set($ENV{NintendoSdkRoot} ${SDK_ROOT})
# set($ENV{NXToolchainDir} ${SDK_ROOT}/Compilers/NintendoClang)

set(TOOLS_BIN "${SDK_ROOT}/Compilers/NintendoClang/bin")
assert_path_exists(${TOOLS_BIN})
# 编译器设置
set(CMAKE_C_COMPILER "${TOOLS_BIN}/clang.exe")
set(CMAKE_CXX_COMPILER "${TOOLS_BIN}/clang++.exe")
set(CMAKE_ASM_COMPILER "${TOOLS_BIN}/clang++.exe")
set(CMAKE_NM 			"${TOOLS_BIN}/llvm-nm.exe" 		CACHE PATH "nm")
set(CMAKE_OBJCOPY 		"${TOOLS_BIN}/llvm-objcopy.exe" CACHE PATH "objcopy")
set(CMAKE_OBJDUMP 		"${TOOLS_BIN}/llvm-objdump.exe" CACHE PATH "objdump")
# set(SCE_CMAKE_DIR "${SCE_ROOT_DIR}/Prospero/Tools/CMake/")
set(CMAKE_AR "${TOOLS_BIN}/llvm-ar.exe" CACHE PATH "archive")
set(CMAKE_LINKER "${TOOLS_BIN}/lld.exe" CACHE PATH "linker")

# 根据构建目标动态配置（例如 Switch、Switch2 等）
set(BUILD_TARGET "Ounce-ounce-a64" CACHE STRING "目标平台（Ounce）")

# 多语言配置文件路径
set(C_CONFIG "${SDK_ROOT}/Build/ClangConfigs/${BUILD_TARGET}/Compile/C/Application.cfg")
set(CXX_CONFIG "${SDK_ROOT}/Build/ClangConfigs/${BUILD_TARGET}/Compile/Cxx/Application.cfg")
set(ASM_CONFIG "${SDK_ROOT}/Build/ClangConfigs/${BUILD_TARGET}/Compile/Asm/Application.cfg")

set(CMAKE_FIND_ROOT_PATH ${SDK_ROOT}/Include ${SDK_ROOT}/TargetSpecificInclude/${BUILD_TARGET} 
  CACHE STRING "Root path that will be prepended to all search paths") # 目标平台库/头文件路径
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)

## 各语言编译配置
set(CMAKE_C_FLAGS "--config=${C_CONFIG} -DNN_NINTENDO_SDK ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "--config=${CXX_CONFIG} -DNN_NINTENDO_SDK ${CMAKE_CXX_FLAGS}")
set(CMAKE_ASM "--config=${ASM_CONFIG} ${CMAKE_ASM_FLAGS}")

include_directories("${SDK_ROOT}/Compilers/NintendoClang/include/aarch64-nintendo-nn-elf")
include_directories(${CMAKE_FIND_ROOT_PATH})
link_directories(${SDK_ROOT}/Libraries/${BUILD_TARGET}/${CMAKE_BUILD_TYPE})
# assert_path_exists("${CMAKE_CURRENT_LIST_DIR}/NX.local.props")
# set_property(GLOBAL PROPERTY VS_GLOBAL_NintendoSdkRoot ${SDK_ROOT})
# set(CMAKE_VS_GLOBALS "NintendoSdkRoot=${SDK_ROOT}" )
file( WRITE "${CMAKE_BINARY_DIR}/Directory.Build.rsp" "" )
file( APPEND "${CMAKE_BINARY_DIR}/Directory.Build.rsp" 
  " /p:NintendoSdkRoot=\"${SDK_ROOT}\""
  " /p:NXToolchainDir=\"${SDK_ROOT}/Compilers/NintendoClang\"" )
# set_property(GLOBAL PROPERTY VS_USER_PROPS "${CMAKE_CURRENT_LIST_DIR}/NX.local.props")
