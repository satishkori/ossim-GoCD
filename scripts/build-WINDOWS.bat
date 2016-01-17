@echo off
set SCRIPT_DIR=%~dp0

echo calling script %SCRIPT_DIR%env-WINDOWS.bat
call %SCRIPT_DIR%\env-WINDOWS.bat

echo ************ Extracting dependencies: %OSSIM_DEV_HOME%\ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip ************
echo cd %OSSIM_DEV_HOME%
cd %OSSIM_DEV_HOME%

if not exist ossim-deps-%OSSIM_DEPENDENCY_VERSION% (
  echo 7z x -y .\ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip

  7z x -y ossim-deps-%OSSIM_DEPENDENCY_VERSION%.zip
  if ERRORLEVEL 1 exit 1
)
 
if not exist %OSSIM_DEV_HOME%build (
  mkdir build
)

cd build 
echo cmake -G "NMake Makefiles JOM" %CMAKE_PARAMETERS%
cmake -G "NMake Makefiles JOM" %CMAKE_PARAMETERS%
if ERRORLEVEL 1 exit 1
jom /J 8
if ERRORLEVEL 1 exit 1

