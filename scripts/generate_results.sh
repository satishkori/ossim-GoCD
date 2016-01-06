#!/bin/bash

######################################################################################
#
# Script for generate OBT expected results. Required environment variables are:
#
# Usage:  generate_results.sh <gocd_resource_name>
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

GOCD_RESOURCE_NAME=$1

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "$0"` out of <$PWD>"
echo "################################################################################"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPT_DIR/set_obt_environment.sh

if [ -d $OSSIM_BATCH_TEST_EXPECTED ]; then
  echo "STATUS: Previous expected results found in <$OSSIM_BATCH_TEST_EXPECTED>. Wiping the directory clean...";
  rm -rf $OSSIM_BATCH_TEST_EXPECTED/*
else
  mkdir -p $OSSIM_BATCH_TEST_EXPECTED;
fi

if [ ! -d $OSSIM_BATCH_TEST_RESULTS ]; then
  echo "STATUS: Creating directory <$OSSIM_BATCH_TEST_RESULTS> to hold test results.";
  mkdir -p $OSSIM_BATCH_TEST_RESULTS;
fi

# Generate expected results:
pushd $OSSIM_DEV_HOME/ossim-GoCD/batch_tests;
echo "STATUS: Running ossim-batch-test --accept-test super-test.kwl in <$PWD>...";echo
ossim-batch-test --accept-test all super-test.kwl
EXIT_CODE=$?
popd
echo "STATUS: ossim-batch-test exit code = $EXIT_CODE";echo
if [ $EXIT_CODE != 0 ]; then
  echo "FAIL: Error encountered generating expected results."; echo
  exit 1
fi

echo "STATUS: Successfully generated expected results in <$OSSIM_BATCH_TEST_EXPECTED>."; echo

REPO_EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
echo "STATUS: Checking existence of destination directory <$REPO_EXPECTED_RESULTS_DIR>...";
if [ ! -d $REPO_EXPECTED_RESULTS_DIR ] ; then
  echo "Resource subdirectory <$REPO_EXPECTED_RESULTS_DIR> on repository is missing. Creating...";
  mkdir -p $REPO_EXPECTED_RESULTS_DIR;
fi

# rsync expected results:
echo "STATUS: Syncing expected results in <$OSSIM_BATCH_TEST_EXPECTED> to the repository directory <$REPO_EXPECTED_RESULTS_DIR>...";
RSYNC_CMD="rsync -rlptvz"
$RSYNC_CMD $OSSIM_BATCH_TEST_EXPECTED/ $REPO_EXPECTED_RESULTS_DIR/
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync."; 
  echo; exit 1;
fi

echo
exit 0

