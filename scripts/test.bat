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
call %SCRIPT_DIR%/set_obt_environment.bat

if ERRORLEVEL 1 exit 1


::if [ ! -d $OSSIM_BATCH_TEST_EXPECTED ]; then
::  echo "ERROR: No expected results were detected in <$OSSIM_BATCH_TEST_EXPECTED>. Cannot continue.";
::  echo; exit 1;
::fi

::if [ ! -d $OSSIM_BATCH_TEST_RESULTS ]; then
::  echo "STATUS: Creating directory <$OSSIM_BATCH_TEST_RESULTS> to hold test results.";
::  mkdir -p $OSSIM_BATCH_TEST_RESULTS;
::fi

::# TEST 1: Check ossim-info version:
echo; echo "STATUS: Running ossim-info --config test...";
::COMMAND1="ossim-info --config --plugins"
::$COMMAND1
::if [ $? -ne 0 ]; then
::  echo; echo "ERROR: Failed while attempting to run <$COMMAND1>."
::  echo; exit 1;
::fi
echo "STATUS: Passed ossim-info --config test.";

echo; echo "STATUS: Running ossim-info --version test...";
::ossim-info --version
::COUNT="$(ossim-info --version | grep --count 'version: 1.9')"
::echo "COUNT = <$COUNT>"
::if [ $COUNT != "1" ]; then
::  echo "FAIL: Failed ossim-info --version test"; 
::  echo; exit 1;
::fi
::echo "STATUS: Passed ossim-info --version test.";

::# Run batch tests
::pushd $OSSIM_DEV_HOME/ossim-GoCD/batch_tests;
echo; echo "STATUS: Running batch tests in <$PWD>..."
::ossim-batch-test super-test.kwl
::EXIT_CODE=$?
::popd
::echo "STATUS: ossim-batch-test EXIT_CODE = $EXIT_CODE"
::if [ $EXIT_CODE != 0 ]; then
::  echo "FAIL: Failed batch test"
::  echo; exit 1;
::fi

::# Success!
echo "STATUS: Passed all tests."
echo


