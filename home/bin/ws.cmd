@echo off
bb.exe --config "%~dp0\clj\bb.edn" -m workspacer %*
