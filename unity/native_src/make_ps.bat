set CUR_DIR=%~dp0
cd %CUR_DIR%

@REM del /s/q buildPS5
mkdir buildPS5 & pushd buildPS5

@REM -DCMAKE_BUILD_TYPE=Release ^
call "%SCE_ROOT_DIR%\Prospero\Tools\CMake\PS5CMake.bat" ^
        -DJS_ENGINE=quickjs -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
        -DBACKEND_DEFINITIONS="WITH_QUICKJS;V8_94_OR_NEWER;WITHOUT_INSPECTOR" ^
        ..
popd
@REM cmake --build buildPS5 --config Debug
cmake --build buildPS5 --config Release
pause