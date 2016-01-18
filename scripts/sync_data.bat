@echo off
set GOCD_RESOURCE_NAME=%1

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "%0"` for resource <%1> out of <%CD%>"
echo "################################################################################"

set RSYNC_CMD=rsync -rlptvz
set SCRIPT_DIR=%~dp0

call:convertToRsync OSSIM_DATA_CYGDRIVE %OSSIM_DATA% 
call:convertToRsync OSSIM_DATA_REPOSITORY_CYGDRIVE %OSSIM_DATA_REPOSITORY% 

::Convert to cygdrive format.  The rsync on windows is a a cygwin port
::set DRIVE_ONLY=%OSSIM_DATA:~0,1%
::set FILE_NO_DRIVE=%OSSIM_DATA:~2,10000%
::set OSSIM_DATA_CYGDRIVE=/cygdrive/%DRIVE_ONLY%%FILE_NO_DRIVE%

::set DRIVE_ONLY=%OSSIM_DATA_REPOSITORY:~0,1%
::set FILE_NO_DRIVE=%OSSIM_DATA_REPOSITORY:~2,10000%
::set OSSIM_DATA_REPOSITORY_CYGDRIVE=/cygdrive/%DRIVE_ONLY%%FILE_NO_DRIVE%

::Let's make sure we are all forward slashes
::set OSSIM_DATA_REPOSITORY_CYGDRIVE=%OSSIM_DATA_REPOSITORY_CYGDRIVE:\=/%
::set OSSIM_DATA_CYGDRIVE=%OSSIM_DATA_CYGDRIVE:\=/%

::# Set GoCD-specific environment:
call %SCRIPT_DIR%\set_obt_environment.bat

::# Should already be there but create if not:
if not exist "%OSSIM_DATA%\elevation" ( mkdir "%OSSIM_DATA%\elevation" )
if not exist "%OSSIM_BATCH_TEST_DATA%\elevation" ( mkdir "%OSSIM_BATCH_TEST_DATA%\elevation" )
if not exist "%OSSIM_BATCH_TEST_EXPECTED%\elevation" ( mkdir "%OSSIM_BATCH_TEST_EXPECTED%\elevation" )


::echo; echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
::if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
::  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
::  echo; exit 1;
::fi

::# rsync elevation data:
echo; echo "STATUS: Syncing elevation data...";
echo %RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/dted/level0 %OSSIM_DATA_CYGDRIVE%/elevation/dted

%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/dted/level0 %OSSIM_DATA_CYGDRIVE%/elevation/dted
if ERRORLEVEL 1 exit 1
::# rsync nadcon data:
echo; echo "STATUS: Syncing nadcon data..."
echo %RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/nadcon %OSSIM_DATA_CYGDRIVE%/elevation
%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/nadcon %OSSIM_DATA_CYGDRIVE%/elevation
if ERRORLEVEL 1 exit 1

if not exist %OSSIM_DATA%\elevation\geoids (
   mkdir %OSSIM_DATA%\elevation\geoids
)

::# rsync geoid 96 data:
echo; echo "STATUS: Syncing geoid96 data..."
echo %RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/geoid96_little_endian/ %OSSIM_DATA_CYGDRIVE%/elevation/geoids/geoid96
%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/geoid96_little_endian/ %OSSIM_DATA_CYGDRIVE%/elevation/geoids/geoid96
if ERRORLEVEL 1 exit 1

::# rsync geoid 99 data:
echo; echo "STATUS: Syncing geoid99 data...";
%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/elevation/geoid99_little_endian/ %OSSIM_DATA_CYGDRIVE%/elevation/geoids/geoid99
if ERRORLEVEL 1 exit 1

::#rsync imagery
echo; echo "STATUS: Syncing image data...";
%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/test/data/public %OSSIM_BATCH_TEST_DATA_CYGDRIVE%/
if ERRORLEVEL 1 exit 1

%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/test/data/geoeye1 %OSSIM_BATCH_TEST_DATA_CYGDRIVE%/
if ERRORLEVEL 1 exit 1

%RSYNC_CMD% %OSSIM_DATA_REPOSITORY_CYGDRIVE%/test/data/rbt %OSSIM_BATCH_TEST_DATA_CYGDRIVE%/
if ERRORLEVEL 1 exit 1
  
::#rsync expected results (if exists)
set REPO_EXPECTED_RESULTS_DIR=%OSSIM_DATA_REPOSITORY%/test/expected_results/%GOCD_RESOURCE_NAME%
echo; echo "STATUS: Checking for expected results in <%REPO_EXPECTED_RESULTS_DIR%>...";
echo "STATUS: SKIP_EXPECTED_RESULTS_SYNC = %SKIP_EXPECTED_RESULTS_SYNC%";
::if [ -d $REPO_EXPECTED_RESULTS_DIR ] && [ -z $SKIP_EXPECTED_RESULTS_SYNC ]; then
::  echo; echo "STATUS: Syncing expected results from <$REPO_EXPECTED_RESULTS_DIR> to <$OSSIM_BATCH_TEST_EXPECTED>...";
::  $RSYNC_CMD $REPO_EXPECTED_RESULTS_DIR/ $OSSIM_BATCH_TEST_EXPECTED/;
::  if [ $? != 0 ] ; then 
::    echo "ERROR: Failed data repository rsync of expected results.";
::  echo; exit 1;
::  fi
::else
::  echo; echo "STATUS: Skipped sync of expected results" 
::fi

::echo 
::exit 0;


goto :done


:convertToRsync
setlocal enableextensions enabledelayedexpansion
set arg2=%2
set DRIVE_ONLY=%arg2:~0,1%
set FILE_NO_DRIVE=%arg2:~2,10000%
set tempVar=/cygdrive/%DRIVE_ONLY%%FILE_NO_DRIVE%
set tempVar=%tempVar:\=/%
if "%tempVar:~-1%"=="/" (set tempVar=%tempVar:~0,-1%)
endlocal  & SET %1=%tempVar%
GOTO :EOF

:done

