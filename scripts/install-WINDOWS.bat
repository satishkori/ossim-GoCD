@echo off
set SCRIPT_DIR=%~dp0

echo calling script %SCRIPT_DIR%env-WINDOWS.bat
call %SCRIPT_DIR%\env-WINDOWS.bat

echo ************ Extracting dependencies: %OSSIM_DEV_HOME%\ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip ************
echo cd %OSSIM_DEV_HOME%
cd %OSSIM_DEV_HOME%
 
if not exist %OSSIM_DEV_HOME%build (
  mkdir build
)

cd build 
if ERRORLEVEL 1 exit 1
jom install
%OSSIM_DEV_HOME%\ossim-GoCD\scripts\embed-manifests-WINDOWS.bat %OSSIM_INSTALL_PREFIX%\bin
%OSSIM_DEV_HOME%\ossim-GoCD\scripts\embed-manifests-WINDOWS.bat %OSSIM_INSTALL_PREFIX%\lib

if ERRORLEVEL 1 exit 1

