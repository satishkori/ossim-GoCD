#!/bin/bash

######################################################################################
#
# Script for setting OBT environment in GoCD. Required environment variables are:
#
#   OSSIM_DATA -- Local directory to contain elevation, imagery, and expected results
#
######################################################################################
#set -x; trap read debug

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $SCRIPT_DIR/../..
export GOCD_WORKSPACE=$PWD
popd

#export the GoCD-specfic OSSIM runtime env to child processes:
export OSSIM_INSTALL_DIR=$GOCD_WORKSPACE/install
export PATH=$OSSIM_INSTALL_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OSSIM_INSTALL_DIR/lib64:$LD_LIBRARY_PATH
export OSSIM_PREFS_FILE=$GOCD_WORKSPACE/ossim-GoCD/ossim-gocd.prefs

echo "Checking for required environment variables..."

if [ -z $OSSIM_DATA ]; then
  echo "ERROR: The environment variable OSSIM_DATA is not defined. Aborting with error.";
  exit 1;
fi
  
if [ ! -d $OSSIM_DATA ] || [ ! -w $OSSIM_DATA ]; then
  echo "ERROR: The directory <$OSSIM_DATA> does not exist or is not writable. Make sure the user has write permissions.";
  exit 1;
fi

if [ -z $OSSIM_BATCH_TEST_DATA ]; then
  export OSSIM_BATCH_TEST_DATA=$OSSIM_DATA/data
fi

if [ -z $OSSIM_BATCH_TEST_EXPECTED ]; then
  export OSSIM_BATCH_TEST_EXPECTED=$OSSIM_DATA/expected_results
fi

if [ -z $OSSIM_BATCH_TEST_RESULTS ]; then
  export OSSIM_BATCH_TEST_RESULTS=$GOCD_WORKSPACE/results
fi

echo; echo "Test Environment:"
echo "  GOCD_WORKSPACE            = $GOCD_WORKSPACE"
echo "  OSSIM_DATA                = $OSSIM_DATA"
echo "  OSSIM_INSTALL_DIR         = $OSSIM_INSTALL_DIR"
echo "  OSSIM_PREFS_FILE          = $OSSIM_PREFS_FILE"
echo "  OSSIM_BATCH_TEST_DATA     = $OSSIM_BATCH_TEST_DATA"
echo "  OSSIM_BATCH_TEST_EXPECTED = $OSSIM_BATCH_TEST_EXPECTED"  
echo "  OSSIM_BATCH_TEST_RESULTS  = $OSSIM_BATCH_TEST_RESULTS"  
echo "  OBT_OUT_DIR               = $OBT_OUT_DIR"
echo "  LD_LIBRARY_PATH           = $LD_LIBRARY_PATH"
echo "  PATH                      = $PATH"
echo


