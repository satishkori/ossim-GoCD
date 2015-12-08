#!/bin/sh
#####################################################################################
#
# Synchronizes the repository's expected_results with the OTB generated results in
# the GoCD agent machine.
#
# Usage:  sync_results.sh <gocd_resource_name>
#
#   OSSIM_DATA_REPOSITORY -- local NFS mount point for data repository
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#
#####################################################################################

GOCD_RESOURCE_NAME=$1

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "$0"` for resource <$1> out of <$PWD>"
echo "################################################################################"

# Set GoCD-specific environment:
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/set_obt_environment.sh

RSYNC_CMD="rsync -rlptvz"

echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
  echo; exit 1;
fi

if [ -z $OSSIM_BATCH_TEST_EXPECTED ] || [ ! -d $OSSIM_BATCH_TEST_EXPECTED ] ; then
  echo "ERROR: Env var OSSIM_BATCH_TEST_EXPECTED must be defined and exist in order to syncronize against data repository.";
  echo; exit 1;
fi

REPO_EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
echo "STATUS: Checking existence of destination directory <$REPO_EXPECTED_RESULTS_DIR>...";
if [ ! -d $REPO_EXPECTED_RESULTS_DIR ] ; then
  echo "Resource subdirectory <$REPO_EXPECTED_RESULTS_DIR> on repository is missing. Creating...";
  mkdir -p $REPO_EXPECTED_RESULTS_DIR;
fi

# rsync expected results:
echo "STATUS: Syncing expected results in <$OSSIM_BATCH_TEST_EXPECTED> to the repository directory <$REPO_EXPECTED_RESULTS_DIR>...";
$RSYNC_CMD $OSSIM_BATCH_TEST_EXPECTED/ $REPO_EXPECTED_RESULTS_DIR/
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync."; 
  echo; exit 1;
fi

echo
exit 0;


