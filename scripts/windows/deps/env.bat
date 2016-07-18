@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
SET TMP=C:\TMP
if not exist "%TMP%" ( mkdir "%TMP%" )


