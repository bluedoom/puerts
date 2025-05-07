::# From https://github.com/Tencent/puerts/issues/1796 Author:NiceTry12138 
chcp 65001
set CUR_DIR=%~dp0
cd %CUR_DIR%
del /s/q nx64
mkdir nx64 & pushd nx64
@REM set "NINTENDO_SDK_ROOT_CMAKE=%NINTENDO_SDK_ROOT:\=/%"
@REM set NintendoSdkRoot=%NINTENDO_SDK_ROOT%
@REM set NXToolchainDir=%NINTENDO_SDK_ROOT%/Compilers/NintendoClang
@REM set NintendoSdkSpec=NX64
@REM set NintendoSdkBuildTarget=NX-NXFP2-a64
@REM set NintendoSdkBuildType=Release

cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ns.toolchain.cmake ^
	-G "Visual Studio 17" -A NX64 ^
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
        -DBACKEND_DEFINITIONS="WITH_QUICKJS;V8_94_OR_NEWER;WITHOUT_INSPECTOR" ^
        -DJS_ENGINE=quickjs -DUSING_QJS=1 ^
        -DBACKEND_INC_NAMES=/Inc -DBACKEND_LIB_NAMES=/Lib/NX/libquickjs.a ^
        ..
popd

cmake --build nx64 --config Release