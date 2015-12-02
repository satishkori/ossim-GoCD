#!/bin/sh
#####################################################################################
#
# Test data results rsync script for all OSSIM repositories. The following env vars  
# must be set in the GoCD environment:
#
# Usage:  sync_results.sh <gocd_resource_name>
#
#   OSSIM_DATA_REPOSITORY -- local NFS mount point for data repository
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#
# The test data directory, specified by the env var OSSIM_DATA is
# syncronized against a master repository. The master data repository is
# assumed to be NFS-mounted at the mount point specified in the environment
# variable "OSSIM_DATA_REPOSITORY". The data will be rsynced to the local
# directory specified by "OSSIM_DATA" env var.
#
#####################################################################################

echo; echo "Running sync_results.sh script from <$PWD>...";

GOCD_RESOURCE_NAME = $1

RSYNC_CMD="rsync -avz --delete"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
pushd $SCRIPT_DIR/../..
GOCD_WORKSPACE=$PWD
echo "Set working directory GOCD_WORKSPACE = <$GOCD_WORKSPACE>"
popd

echo "STATUS: Checking presence of env var OSSIM_DATA = <$OSSIM_DATA>...";
if [ -z $OSSIM_DATA ] || [ ! -d $OSSIM_DATA ] ; then
  echo "ERROR: Env var OSSIM_DATA must be defined and exist in order to syncronize against data repository.";
  exit 1;
fi

echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
  exit 1;
fi

EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
if [ ! -d $EXPECTED_RESULTS_DIR ] ; then
  echo "Resource subdirectory on repository is missing. Creating...";
  mkdir -p $EXPECTED_RESULTS_DIR;
fi

# rsync expected results:
echo "STATUS: Syncing expected results to the repository...";
$RSYNC_CMD $OSSIM_DATA/expected_results $EXPECTED_RESULTS_DIR
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync.";
  exit 1;
fi

exit 0;


