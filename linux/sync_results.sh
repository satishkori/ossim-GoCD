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

echo; echo "Running sync_results.sh script from <$PWD>...";

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/set_obt_environment.sh

GOCD_RESOURCE_NAME = $1

RSYNC_CMD="rsync -avz --delete"

echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
  exit 1;
fi

REPO_EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
if [ ! -d $REPO_EXPECTED_RESULTS_DIR ] ; then
  echo "Resource subdirectory on repository is missing. Creating...";
  mkdir -p $REPO_EXPECTED_RESULTS_DIR;
fi

# rsync expected results:
echo "STATUS: Syncing expected results to the repository...";
$RSYNC_CMD $OBT_EXP_DIR $REPO_EXPECTED_RESULTS_DIR
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync.";
  exit 1;
fi

exit 0;


