#!/bin/sh
#####################################################################################
#
# Test data setup script for all OSSIM repositories. The following env vars must be 
# set in the GoCD environment:
#
# Usage:  sync_data.sh <gocd_resource_name>
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

echo; echo "Running sync_data.sh script from <$PWD>...";

GOCD_RESOURCE_NAME = $1

RSYNC_CMD="rsync -avz --delete"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
pushd $SCRIPT_DIR/../..
GOCD_WORKSPACE=$PWD
echo "Set working directory GOCD_WORKSPACE = <$GOCD_WORKSPACE>"
popd

if [ -z $OSSIM_DATA ]; then
  echo "ERROR: The environment variable OSSIM_DATA is not defined. Aborting with error.";
  exit 1;
fi
  
if [ ! -d $OSSIM_DATA ] || [ ! -w $OSSIM_DATA ]; then
  echo "ERROR: The directory <$OSSIM_DATA> does not exist or is not writable. Make sure the user has write permissions.";
  exit 1;
fi

# Should already be there but create if not:
mkdir -p $OSSIM_DATA/elevation
mkdir -p $OSSIM_DATA/data
mkdir -p $OSSIM_DATA/expected_results
mkdir $GOCD_WORKSPACE/batch_tests

echo; echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
  exit 1;
fi

# rsync elevation data:
echo; echo "STATUS: Syncing elevation data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/dted/level0 $OSSIM_DATA/elevation/dted;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of elevation.";
  exit 1;
fi

# rsync nadcon data:
echo; echo "STATUS: Syncing nadcon data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/nadcon $OSSIM_DATA/elevation;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of nadcon grids.";
  exit 1;
fi

if [ ! -d $OSSIM_DATA/elevation/geoids ] ; then
  echo; echo "STATUS: Creating missing geoids subdirectory";
  mkdir $OSSIM_DATA/elevation/geoids; 
  if [ $? != 0 ] ; then 
    echo "ERROR: Failed creatiion of geoids directory at <$OSSIM_DATA/elevation/geoids>.";
    exit 1;
  fi
fi

# rsync geoid 96 data:
echo; echo "STATUS: Syncing geoid96 data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/geoid96_little_endian/ $OSSIM_DATA/elevation/geoids/geoid96;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of geoid96 grids.";
  exit 1;
fi

# rsync geoid 99 data:
echo; echo "STATUS: Syncing geoid99 data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/geoid99_little_endian/ $OSSIM_DATA/elevation/geoids/geoid99;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of geoid99 grids.";
  exit 1;
fi

#rsync imagery
echo; echo "STATUS: Syncing image data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/test/data/public $OSSIM_DATA/data;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of imagery.";
  exit 1;
fi
  
#rsync expected results (if exists)
EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
if [ -d $EXPECTED_RESULTS_DIR ] ; then
  echo; echo "STATUS: Syncing expected results...";
  $RSYNC_CMD $EXPECTED_RESULTS_DIR/ $OSSIM_DATA/expected_results;
  if [ $? != 0 ] ; then 
    echo "ERROR: Failed data repository rsync of expected results.";
    exit 1;
  fi
fi

# Finally rsync the batch test config KWLs to the temporary pipeline:
echo; echo "STATUS: Syncing batch test config files...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/test/public_batch_tests/ $GOCD_WORKSPACE/batch_tests;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of batch test config files.";
  exit 1;
fi

exit 0;


