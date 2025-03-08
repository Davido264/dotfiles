Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

if ($Global:WINDOWS_MUSIC -eq 0)
{
    return
}

WingetInstall-Package -Package ImageLine.FLStudio
# TODO: move all gists to extra-packages
# https://gist.githubusercontent.com/Davido264/a277db84cb1914188f110255ebf2561c/raw/d0dad6536d50e3d267f55b275224a1b8e13c885e/youlean-meter.json
# https://gist.githubusercontent.com/Davido264/a277db84cb1914188f110255ebf2561c/raw/d0dad6536d50e3d267f55b275224a1b8e13c885e/labs-lm.json
ScoopInstall-Package -Package "$Global:REPO_DIR/res/extra-packages/windows/youlean-meter.json"
ScoopInstall-Package -Package "$Global:REPO_DIR/res/extra-packages/windows/labs-lm.json"

# pending https://xferrecords.com/product_downloads/25/freeware
# pending https://plugins4free.com/plugin/2233/
# pending https://plugins4free.com/plugin/3181/
