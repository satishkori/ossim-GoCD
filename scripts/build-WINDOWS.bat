@echo off
setlocal enabledelayedexpansion
set SCRIPT_DIR="%~dp0"

call %SCRIPT_DIR%env-WINDOWS

echo ************ Extracting dependencies: %OSSIM_DEV_HOME%ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip ************
cd %OSSIM_DEV_HOME%
echo 7z x -y ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip

7z x -y ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip
 
rem cmake -G "NMake Makefiles JOM" %CMAKE_PARAMETERS%
