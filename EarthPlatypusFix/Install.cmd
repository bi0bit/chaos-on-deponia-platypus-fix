@echo off
setlocal
title Earth Platypus minigame fix - Install
rem Use Windows PowerShell's own modules even if launched from PowerShell 7.
set "PSModulePath="
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Patch.ps1" -Action Install
set "patch_exit=%errorlevel%"
echo.
pause
exit /b %patch_exit%
