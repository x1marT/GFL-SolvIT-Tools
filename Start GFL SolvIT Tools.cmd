@echo off
rem Double-click this file to start GFL SolvIT Tools.
rem If PowerShell reports an error, this window stays open so you can read it.
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0GFL SolvIT Tools v2.ps1"
if errorlevel 1 (
    echo.
    echo GFL SolvIT Tools closed with an error. See the message above.
    pause
)
