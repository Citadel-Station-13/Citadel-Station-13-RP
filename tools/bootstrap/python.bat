@echo off
@REM Pass args over to ps1
call powershell.exe -NoLogo -ExecutionPolicy Bypass -File "%~dp0\python_.ps1" %*
