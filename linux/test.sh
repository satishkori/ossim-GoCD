#!/bin/bash

######################################################################################
#
# Test script for all OSSIM repositories. Required environment variables are:
#
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#
######################################################################################
#set -x; trap read debug

echo; echo "Running test.sh out of <$PWD>"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/set_obt_environment.sh
if [ $? != 0 ] ; then 
  echo "ERROR: Could not set OBT environment.";
  exit 1;
fi

if [ ! -d $OBT_EXP_DIR ]; then
  echo "ERROR: No expected results were detected in <$OBT_EXP_DIR>. Cannot continue.";
  exit 1;
fi

if [ ! -d $OBT_OUT_DIR ]; then
  echo "ERROR: No batch test working directory detected in <$OBT_OUT_DIR>. Cannot continue.";
  exit 1;
fi

echo "STATUS: Cleaning directory <$OBT_OUT_DIR> of old results.";
pushd $OBT_OUT_DIR;
find . -type d -print -exec rm -rf {} \;

# TEST 1: Check ossim-info version:
echo; echo "STATUS: Running ossim-info --config test...";
COMMAND1="ossim-info --config --plugins"
$COMMAND1
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Failed while attempting to run <$COMMAND1>."
  exit 1;
fi
echo "STATUS: Passed ossim-info --config test.";

echo; echo "STATUS: Running ossim-info --version test...";
ossim-info --version
COUNT="$(ossim-info --version | grep --count 'version: 1.9')"
echo "COUNT = <$COUNT>"
if [ $COUNT != "1" ]; then
  echo "FAIL: Failed ossim-info --version test"; 
  exit 1;
fi
echo "STATUS: Passed ossim-info --version test.";

# Run batch tests
echo; echo "STATUS: Running batch tests..."
ossim-batch-test super-test.kwl
EXIT_CODE=$?
echo "STATUS: ossim-batch-test EXIT_CODE = $EXIT_CODE"
if [ $EXIT_CODE != 0 ]; then
  echo "FAIL: Failed batch test"
  exit 1;
fi

# Success!
popd
echo "STATUS: Passed all tests."
exit 0

