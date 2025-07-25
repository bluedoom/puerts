param(
    [string]$user,
    [SecureString]$password
)
$url = "https://k8s-npm.91act.com/"
$email = 'noah_group@91act.com'

function CopyBinary(){
   param (  
        [string]$from,
        [string]$toDir 
    )
    if (-not (Test-Path $toDir)) {
        New-Item -Path $toDir -ItemType Directory
    }
    Copy-Item -Path $from -Destination $toDir -Recurse -Force
}

CopyBinary .\unity\native_src\buildPS5\Release\* .\unity\Assets\core\upm\Plugins\Prospero\
CopyBinary .\unity\native_src\nx64\Release\* .\unity\Assets\core\upm\Plugins\NX64\
Copy-Item $PSScriptRoot\README.md .\unity\Assets\core\upm\README.md -Force
$USR = nrm current
Write-Host $USR
if (!$?) {
    npm install -g nrm --registry $url
    $USR = nrm current
}

if($USR -ne $user)
{
    nrm add $user $url
    nrm use $user
}
npm whoami --registry=$url
if(!$?)
{
    npm-cli-adduser --version
    if(!$?){ 
        npm install -g npm-cli-adduser
        if(!$?)
        {
            exit -1
        }
    }
}
npm-cli-adduser --registry $url --username $user --password $password --email $email
# npm config set loglevel verbose --global
Push-Location .\unity\Assets\core\upm
npm publish --verbose
Pop-Location
Remove-Item .\unity\Assets\core\upm\README.md -Force