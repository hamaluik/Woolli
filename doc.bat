@echo off
cls
haxe doc.hxml
if %errorlevel% neq 0 exit /b %errorlevel%
neko doc-build/doc.n