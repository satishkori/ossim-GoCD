#!/bin/sh
#####################################################################################
#
# Synchronizes the local GoCD agent machine with the OBT test data on repository
#
# Usage:  sync_data.sh <gocd_resource_name>
#
# Required ENV vars:
#
#   OSSIM_DATA_REPOSITORY -- local NFS mount point for data repository
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#
# Optional referenced  env var:
#
#   SKIP_EXPECTED_RESULTS_SYNC -- if defined, implies the data sync is for 
#      *generating* expected results, therefore prior expected results are not synced
#      from the repo (they are ignored).
#
#####################################################################################

GOCD_RESOURCE_NAME=$1

echo; echo; 
echo "################################################################################"
echo "#  Running `basename "$0"` for resource <$1> out of <$PWD>"
echo "################################################################################"

RSYNC_CMD="rsync -rlptvz"

# Set GoCD-specific environment:
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPT_DIR/set_obt_environment.sh

# Should already be there but create if not:
if [ ! -d $OSSIM_DATA/elevation ] ; then
  mkdir $OSSIM_DATA/elevation
fi
if [ ! -d $OSSIM_BATCH_TEST_DATA ] ; then
  mkdir $OSSIM_BATCH_TEST_DATA
fi
if [ ! -d $OSSIM_BATCH_TEST_EXPECTED ] ; then 
  mkdir $OSSIM_BATCH_TEST_EXPECTED
fi

echo; echo "STATUS: Checking access to data repository at <$OSSIM_DATA_REPOSITORY>...";
if [ -z $OSSIM_DATA_REPOSITORY ] || [ ! -d $OSSIM_DATA_REPOSITORY ] ; then
  echo "ERROR: Env var OSSIM_DATA_REPOSITORY must be defined and exist in order to syncronize against data repository.";
  echo; exit 1;
fi

# rsync elevation data:
echo; echo "STATUS: Syncing elevation data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/dted/level0 $OSSIM_DATA/elevation/dted;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of elevation.";
  echo; exit 1;
fi

# rsync nadcon data:
echo; echo "STATUS: Syncing nadcon data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/nadcon $OSSIM_DATA/elevation;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of nadcon grids.";
  echo; exit 1;
fi

if [ ! -d $OSSIM_DATA/elevation/geoids ] ; then
  echo; echo "STATUS: Creating missing geoids subdirectory";
  mkdir $OSSIM_DATA/elevation/geoids; 
  if [ $? != 0 ] ; then 
    echo "ERROR: Failed creatiion of geoids directory at <$OSSIM_DATA/elevation/geoids>.";
    echo; exit 1;
  fi
fi

# rsync geoid 96 data:
echo; echo "STATUS: Syncing geoid96 data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/geoid96_little_endian/ $OSSIM_DATA/elevation/geoids/geoid96;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of geoid96 grids.";
  echo; exit 1;
fi

# rsync geoid 99 data:
echo; echo "STATUS: Syncing geoid99 data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/elevation/geoid99_little_endian/ $OSSIM_DATA/elevation/geoids/geoid99;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of geoid99 grids.";
  echo; exit 1;
fi

#rsync imagery
echo; echo "STATUS: Syncing image data...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/test/data/public $OSSIM_BATCH_TEST_DATA;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of imagery.";
  echo; exit 1;
fi
  
#rsync expected results (if exists)
REPO_EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
echo; echo "STATUS: Checking for expected results in <$REPO_EXPECTED_RESULTS_DIR>...";
echo "STATUS: SKIP_EXPECTED_RESULTS_SYNC = <$SKIP_EXPECTED_RESULTS_SYNC>";
if [ -d $REPO_EXPECTED_RESULTS_DIR ] && [ ! -z $SKIP_EXPECTED_RESULTS_SYNC ]; then
  echo; echo "STATUS: Syncing expected results from <$REPO_EXPECTED_RESULTS_DIR> to <$OSSIM_BATCH_TEST_EXPECTED>...";
  $RSYNC_CMD $REPO_EXPECTED_RESULTS_DIR/ $OSSIM_BATCH_TEST_EXPECTED/;
  if [ $? != 0 ] ; then 
    echo "ERROR: Failed data repository rsync of expected results.";
  echo; exit 1;
  fi
else
  echo; echo "STATUS: Skipped sync of expected results" 
fi

echo 
exit 0;


