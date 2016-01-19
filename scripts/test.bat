@echo off
::######################################################################################
::#
::# Test script for all OSSIM repositories. Required environment variables are:
::#
::#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
::#
::######################################################################################
::#set -x; trap read debug

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "%0"` out of <%CD%>"
echo "################################################################################"

::# Set GoCD-specific environment:
set SCRIPT_DIR=%~dp0
call %SCRIPT_DIR%\set_obt_environment.bat
if ERRORLEVEL 1 exit 1

::# TEST 1: Check ossim-info version:
echo; echo "STATUS: Running ossim-info --config test...";
call ossim-info --config --plugins
::$COMMAND1
::if [ $? -ne 0 ]; then
::  echo; echo "ERROR: Failed while attempting to run <$COMMAND1>."
::  echo; exit 1;
::fi
echo "STATUS: Passed ossim-info --config test.";
echo; echo "STATUS: Running ossim-info --version test...";
set SUBSTRING=1.9
echo "ossim-info --version | FINDSTR /C:%SUBSTRING% >nul & IF ERRORLEVEL 1"
ossim-info --version | FINDSTR /C:%SUBSTRING% >nul & IF ERRORLEVEL 1 (
     echo Testing against wrong version
     exit 1
)
echo "STATUS: Passed ossim-info --config test.";

::echo; echo "STATUS: Running ossim-info --plugins test...";
::set SUBSTRING="ossim_kakadu_plugin ossim_png_plugin ossim_sqlite_plugin"
::echo "ossim-info --plugins | FINDSTR /i /r /C:%SUBSTRING% >nul & IF ERRORLEVEL 1"
::ossim-info --plugins | FINDSTR /C:%SUBSTRING% >nul & IF ERRORLEVEL 1 (
::     echo "ERROR: Plugins, kakadu, png, and sqlite are needed for base testing and were not found."
::     exit 1
::)

if not exist %OSSIM_BATCH_TEST_EXPECTED%(
  echo "ERROR: No expected results were detected in <%OSSIM_BATCH_TEST_EXPECTED%>. Cannot continue.";
  echo; exit 1;
)

if not exist %OSSIM_BATCH_TEST_RESULTS%(
   mkdir %OSSIM_BATCH_TEST_RESULTS%
)

::# Run batch tests
cd %OSSIM_DEV_HOME%\ossim-GoCD\batch_tests;
echo; echo "STATUS: Running batch tests in <%CD%>..."
ossim-batch-test super-test.kwl
echo "STATUS: Passed all tests."
echo


