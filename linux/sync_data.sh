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
#####################################################################################

echo; echo "Running sync_data.sh script from <$PWD>...";

GOCD_RESOURCE_NAME = $1

RSYNC_CMD="rsync -avz --delete"

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPT_DIR/set_obt_environment.sh

# Should already be there but create if not:
if [ ! -d $OSSIM_DATA/elevation ] ; then
  mkdir $OSSIM_DATA/elevation
fi
if [ ! -d $OSSIM_DATA/data ] ; then
  mkdir $OSSIM_DATA/data
fi
if [ ! -d $OBT_EXP_DIR ] ; then 
  mkdir $OBT_EXP_DIR
fi
if [ ! -d $OBT_OUT_DIR ] ; then 
  mkdir $OBT_OUT_DIR
fi

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
REPO_EXPECTED_RESULTS_DIR=$OSSIM_DATA_REPOSITORY/test/expected_results/$GOCD_RESOURCE_NAME
if [ -d $REPO_EXPECTED_RESULTS_DIR ] ; then
  echo; echo "STATUS: Syncing expected results...";
  $RSYNC_CMD $REPO_EXPECTED_RESULTS_DIR/ $OBT_EXP_DIR;
  if [ $? != 0 ] ; then 
    echo "ERROR: Failed data repository rsync of expected results.";
    exit 1;
  fi
fi

# Finally rsync the batch test config KWLs to the temporary pipeline:
echo; echo "STATUS: Syncing batch test config files...";
$RSYNC_CMD $OSSIM_DATA_REPOSITORY/test/public_batch_tests/ $OBT_OUT_DIR;
if [ $? != 0 ] ; then 
  echo "ERROR: Failed data repository rsync of batch test config files.";
  exit 1;
fi

exit 0;


