chcp 65001
# Set Nintendo SDK root environment variable
$NINTENDO_SDK_ROOT = "C:\Nintendo\Unity6000.0.46_20250527-OunceAddon20.5.6-Unity6\NintendoSDK"
$env:NINTENDO_SDK_ROOT="$NINTENDO_SDK_ROOT"
$env:NintendoSdkRoot="$NINTENDO_SDK_ROOT"
$env:NnToolchainDir="$NINTENDO_SDK_ROOT/Compilers/NintendoClang"
$CUR_DIR=$PSScriptRoot
Set-Location $CUR_DIR

$Dir = 'build_ounce64'
Remove-Item -Path $Dir -Force -Recurse
New-Item -Type Directory -Force -Path $Dir
Push-Location $Dir


cmake -DCMAKE_TOOLCHAIN_FILE="../cmake/ounce.toolchain.cmake" `
	-G "Visual Studio 17" -A Ounce64 `
	-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON `
        -DBACKEND_DEFINITIONS="WITH_QUICKJS;V8_94_OR_NEWER;WITHOUT_INSPECTOR" `
        -DJS_ENGINE=quickjs -DUSING_QJS=1 `
        -DBACKEND_INC_NAMES=/Inc `
        ..
Pop-Location

cmake --build $Dir --config Release
xcopy /Y /E /I $Dir\Release\*.* ..\Assets\core\upm\Plugins\Ounce64
