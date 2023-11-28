@echo off
@REM Pass args over to ps1
call powershell.exe -NoLog -ExecutionPolicy Bypass -File "%~dp0\node_.ps1" %*
