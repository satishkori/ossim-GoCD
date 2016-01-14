@echo off
setlocal enabledelayedexpansion
set SCRIPT_DIR="%~dp0"

call %SCRIPT_DIR%env-WINDOWS

echo ************ Extracting dependencies ************
cd %OSSIM_DEV_HOME%
7z x -y ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip

