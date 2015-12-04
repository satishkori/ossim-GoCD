#!/bin/bash

######################################################################################
#
# Script for generate OBT expected results. Required environment variables are:
#
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#   OSSIM_PREFS_FILE -- Path to preferences used by test executables.
#
# Optional environment variables are:
#
#   OSSIM_BATCH_TEST_DATA -- Defaults to $OSSIM_DATA/data
#
######################################################################################
#set -x; trap read debug

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "$0"` out of <$PWD>"
echo "################################################################################"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPT_DIR/set_obt_environment.sh

if [ -d $OBT_EXP_DIR ]; then
  echo "STATUS: Previous expected results found in <$OBT_EXP_DIR>. Wiping the directory clean...";
  rm -rf $OBT_EXP_DIR/*
else
  mkdir -p $OBT_EXP_DIR;
fi

if [ ! -d $OBT_OUT_DIR ]; then
  echo "STATUS: Creating directory <$OBT_OUT_DIR> to hold test results.";
  mkdir -p $OBT_OUT_DIR;
fi

# Move into batch test working directory that should contain all config files 
# from previous rsync to data repo:
pushd $GOCD_WORKSPACE/batch_tests;

# Generate expected results:
echo "STATUS: Running ossim-batch-test --accept-test super-test.kwl...";echo
mkdir -p $OBT_EXP_DIR;
ossim-batch-test --accept-test all super-test.kwl
EXIT_CODE=$?
popd
echo "STATUS: ossim-batch-test exit code = $EXIT_CODE";echo
if [ $EXIT_CODE != 0 ]; then
  echo "FAIL: Error encountered generating expected results."; echo
  exit 1
fi

echo "STATUS: Successfully generated expected results in <$OBT_OUT_DIR>."; echo
exit 0

