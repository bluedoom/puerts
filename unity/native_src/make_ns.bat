chcp 65001
set CUR_DIR=%~dp0
cd %CUR_DIR%
del /s/q build_nx64
mkdir build_nx64 & pushd build_nx64

cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ns.toolchain.cmake ^
	-G "Visual Studio 17" -A NX64 ^
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
        -DBACKEND_DEFINITIONS="WITH_QUICKJS;V8_94_OR_NEWER;WITHOUT_INSPECTOR" ^
        -DJS_ENGINE=quickjs -DUSING_QJS=1 ^
        -DBACKEND_INC_NAMES=/Inc^
        ..
popd

cmake --build build_nx64 --config Release
xcopy /Y /E /I build_nx64\Release\*.* ..\Assets\core\upm\Plugins\NX64
