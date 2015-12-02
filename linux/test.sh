#!/bin/bash

######################################################################################
#
# Test script for all OSSIM repositories. Required environment variables are:
#
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#   OSSIM_PREFS_FILE -- Path to preferences used by test executables.
#
# Optional environment variables are:
#
#   OSSIM_BATCH_TEST_DATA -- Defaults to $OSSIM_DATA/ossim_data
# 
# Usage: test.sh [genx]
# 
# The required environment variable OSSIM_DATA should also ontain elevation data as 
# specified in the ossim_preferences file.
#
# The test data referenced must be available at $OSSIM_BATCH_TEST_DATA. This 
# environment variable can be predefined, otherwise, will default to:
# $OSSIM_DATA/ossim_data.
#
# The expected results should be in $OSSIM_BATCH_TEST_EXPECTED. This environment 
# variable can be predefined, otherwise, will default to
# $OSSIM_BATCH_TEST_DATA/expected_results.
#
# If the optional "genx" argument is specified, or $OSSIM_BATCH_TEST_EXPECTED does not
# exist, then expected results will be generated.
#
######################################################################################
#set -x; trap read debug

echo; echo "Running test.sh out of <$PWD>"

GENERATE_EXPECTED_RESULTS=false
if [ "$1" == 'genx' ]; then
  GENERATE_EXPECTED_RESULTS=true;
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $SCRIPT_DIR/../..
GOCD_WORKSPACE=$PWD
echo "Set GOCD_WORKSPACE = <$GOCD_WORKSPACE>"

#export the GoCD-specfic OSSIM runtime env to child processes:
export OSSIM_INSTALL_DIR=$GOCD_WORKSPACE/install
export PATH=$OSSIM_INSTALL_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OSSIM_INSTALL_DIR/lib64:$LD_LIBRARY_PATH
export OSSIM_PREFS_FILE=$GOCD_WORKSPACE/ossim-GoCD/ossim-gocd.prefs

echo "Checking for required environment variables..."

if [ ! -d $OSSIM_DATA ]; then
  echo "ERROR: Required env var OSSIM_DATA is not defined or directory does not exist. Aborting setup..."; 
  exit 1
fi

if [ -z $OSSIM_BATCH_TEST_DATA ]; then
  export OSSIM_BATCH_TEST_DATA=$OSSIM_DATA/data
fi

if [ -z $OBT_EXP_DIR ]; then
  export OBT_EXP_DIR=$OSSIM_DATA/expected_results
fi

if [ -z $OBT_OUT_DIR ]; then
  export OBT_OUT_DIR=$GOCD_WORKSPACE/batch_tests
fi

if [ -z $OBT_CONFIG_DIR ]; then
  export OBT_CONFIG_DIR=$GOCD_WORKSPACE/batch_tests
fi

echo; echo "Test Environment:"
echo "  OSSIM_DATA=$OSSIM_DATA"
echo "  OSSIM_INSTALL_DIR=$OSSIM_INSTALL_DIR"
echo "  OSSIM_PREFS_FILE=$OSSIM_PREFS_FILE"
echo "  PATH=$PATH"
echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "  OSSIM_BATCH_TEST_DATA=$OSSIM_BATCH_TEST_DATA"
echo "  OBT_CONFIG_DIR=$OBT_CONFIG_DIR"
echo "  OBT_EXP_DIR=$OBT_EXP_DIR"
echo "  OBT_OUT_DIR=$OBT_OUT_DIR"
echo

if [ ! -d $OBT_EXP_DIR ] && [! $GENERATE_EXPECTED_RESULTS ]; then
  echo "STATUS: No expected results were detected. Cannot continue.";
  export GENERATE_EXPECTED_RESULTS="true";
  mkdir -p $OBT_EXP_DIR;
fi

if [ ! -d $OBT_OUT_DIR ]; then
  echo "STATUS: Creating directory <$OBT_OUT_DIR> to hold test results.";
  mkdir -p $OBT_OUT_DIR;
else
  echo "STATUS: Cleaning directory <$OBT_OUT_DIR> of old results.";
  rm -rf $OBT_OUT_DIR/*;
fi

# TEST 1: Check ossim-info version:
echo; echo "STATUS: Running ossim-info --config test...";
COMMAND1="ossim-info --config --plugins"
$COMMAND1
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Failed while attempting to run <$COMMAND1>."
  exit 1
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

# Move into batch test working directory that should contain all config files 
# from previous rsync to data repo:
pushd $GOCD_WORKSPACE/batch_tests;

echo; echo "GENERATE_EXPECTED_RESULTS = $GENERATE_EXPECTED_RESULTS"
if [ $GENERATE_EXPECTED_RESULTS ]; then
  # Generate expected results:
  echo "STATUS: Running ossim-batch-test --accept-test super-test.kwl...";echo
  mkdir -p $OBT_EXP_DIR;
  ossim-batch-test --accept-test all super-test.kwl
  EXIT_CODE=$?
  popd
  echo "STATUS: ossim-batch-test exit code = $EXIT_CODE";echo
  if [ $EXIT_CODE != 0 ]; then
    echo "FAIL: Error encountered generating expected results."
    exit 1
  else
    echo "STATUS: Successfully generated expected results."; echo
  fi

else
  # Run batch tests
  echo; echo "STATUS: Running batch tests..."
  ossim-batch-test super-test.kwl
  EXIT_CODE=$?
  popd
  echo "STATUS: ossim-batch-test EXIT_CODE = $EXIT_CODE"
  if [ $EXIT_CODE != 0 ]; then
    echo "FAIL: Failed batch test"
    exit 1
  else
    echo "STATUS: Passed batch test"
  fi

fi

# Success!
popd
echo "STATUS: Passed all tests."
exit 0

