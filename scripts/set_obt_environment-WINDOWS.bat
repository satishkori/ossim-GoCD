
::######################################################################################
::#
::# Script for setting OBT environment in GoCD. Required environment variables are:
::#
::#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
::#
::######################################################################################

set SCRIPT_DIR=%~dp0
cd %SCRIPT_DIR%\..\..
set OSSIM_DEV_HOME=%CD%


set OSSIM_PREFS_FILE=%OSSIM_DEV_HOME%\ossim-GoCD\ossim-gocd.prefs
set JAVA_CLASS_PATH=%OSSIM_INSTALL_PREFIX%\share\java

if "%OSSIM_INSTALL_PREFIX"=="" ( 
   set OSSIM_INSTALL_PREFIX=%OSSIM_DEV_HOME%\install
)

if "%OSSIM_DEPENDENCIES"=="" ( 
   set OSSIM_DEPENDENCIES=%OSSIM_DEV_HOME%\ossim-deps-%DEPENDENCY_VERSION%
)

set PATH=%OSSIM_DEPENDENCIES%\bin:%OSSIM_INSTALL_PREFIX%\bin:%PATH%

echo "Checking for required environment variables..."

if "%OSSIM_VERSION%"=="" (set OSSIM_VERSION=1.9.0)

if "%OSSIM_DATA%"=="" (exit 1)
::if [ -z $OSSIM_DATA ]; then
::  echo "ERROR: The environment variable OSSIM_DATA is not defined. Aborting with error.";
::  exit 1;
::fi
  
::if [ ! -d $OSSIM_DATA ] || [ ! -w $OSSIM_DATA ]; then
::  echo "ERROR: The directory <$OSSIM_DATA> does not exist or is not writable. Make sure the user has write permissions.";
::  exit 1;
::fi

::if [ -z $OSSIM_BATCH_TEST_DATA ]; then
::  export OSSIM_BATCH_TEST_DATA=$OSSIM_DATA/data
::fi

::if [ -z $OSSIM_BATCH_TEST_EXPECTED ]; then
::  export OSSIM_BATCH_TEST_EXPECTED=$OSSIM_DATA/expected_results
::fi

::if [ -z $OSSIM_BATCH_TEST_RESULTS ]; then
::  export OSSIM_BATCH_TEST_RESULTS=$OSSIM_DEV_HOME/results
::fi

::echo; echo "Test Environment:"
::echo "  OSSIM_DEV_HOME            = $OSSIM_DEV_HOME"
::echo "  OSSIM_DATA                = $OSSIM_DATA"
::echo "  OSSIM_INSTALL_DIR         = $OSSIM_INSTALL_DIR"
::echo "  OSSIM_PREFS_FILE          = $OSSIM_PREFS_FILE"
::echo "  OSSIM_BATCH_TEST_DATA     = $OSSIM_BATCH_TEST_DATA"
::echo "  OSSIM_BATCH_TEST_EXPECTED = $OSSIM_BATCH_TEST_EXPECTED"  
::echo "  OSSIM_BATCH_TEST_RESULTS  = $OSSIM_BATCH_TEST_RESULTS"  
::echo "  LD_LIBRARY_PATH           = $LD_LIBRARY_PATH"
::echo "  PATH                      = $PATH"
::echo


