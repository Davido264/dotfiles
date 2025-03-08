Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

WingetInstall-Package -Package EpicGames.EpicGamesLauncher
WingetInstall-Package -Package PrismLauncher.PrismLauncher

# TODO: move from gits to extra-packages
# https://gist.githubusercontent.com/Davido264/42b2e11fb5f5d246e0899c8f5dc1f4bc/raw/e4b8cc57dcf6d0f592cf699d101a1d393d954156/ssf2.json
ScoopInstall-Package -Package "$Global:REPO_DIR/res/extra-packages/windows/ssf2.json"
