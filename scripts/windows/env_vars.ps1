Import-Module "$Env:SROOT/utils.psm1"

[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "%USERPROFILE%\.config", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", "%USERPROFILE%\.cache", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("XDG_DATA_HOME", "%USERPROFILE%\.local\share", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("XDG_STATE_HOME", "%USERPROFILE%\.local\state", [EnvironmentVariableTarget]::User)

[Environment]::SetEnvironmentVariable("FZF_DEFAULT_OPTS", "--delimiter=\t --exit-0 --select-1 --bind=ctrl-z:ignore,btab:up,tab:down --tabstop=1 --height=50% --layout=reverse --prompt '∷ ' --pointer ▶ --marker ⇒", [EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("RCLONE_CONFIG", "$HOME\.config\rclone\config.conf", [EnvironmentVariableTarget]::User)

if ($Env:WINDOWS_DEV -eq 1)
{
    [Environment]::SetEnvironmentVariable("GOBIN", "%XDG_DATA_HOME%\go\bin", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("GOPATH", "%XDG_DATA_HOME%\go", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("RUSTUP_HOME", "%XDG_DATA_HOME%\rustup", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("CARGO_HOME", "%XDG_DATA_HOME%\cargo", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("DOCKER_CONFIG", "%XDG_CONFIG_HOME%\docker", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("OMNISHARPHOME", "%XDG_CONFIG_HOME%\omnisharp", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("DOTNET_CLI_HOME", "%XDG_DATA_HOME%\dotnet", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "%XDG_CACHE_HOME%\NuGetPackages", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("PYTHON_HISTORY", "%XDG_STATE_HOME%\python\history", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("ANDROID_USER_HOME", "%XDG_DATA_HOME%\android", [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("JAVA_HOME", "$HOME\scoop\apps\openjdk\current", [EnvironmentVariableTarget]::User)

    [Environment]::SetEnvironmentVariable("PATH", "$Env:PATH;$Env:GOBIN", [EnvironmentVariableTarget]::User)
}

[Environment]::SetEnvironmentVariable("PATH", "$Env:PATH;$HOME\bin", [EnvironmentVariableTarget]::User)

sudo {
    Clean-Enviroment -Target "User"
    Clean-Enviroment -Target "Machine"
}
