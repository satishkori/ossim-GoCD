#!/bin/bash 
###############################################################################
#
# Install script for ossimlabs
#
# Usage: install.sh [create-link]
#
# This script can be run from anywhere. It performs two functions:
# 
#   1. performs a make install, and
#   2. zips the install directory for use as sandbox or artifact.
#   3. Optionally creates a link to the zipped install that does not contain
#      a timestamp or pipeline name, so it is accessible by other pipelines.
#
# No env vars need to be predefined. The install output will be written to
# $OSSIM_DEV_HOME/install where $OSSIM_DEV_HOME is the top-level
# folder containing all OSSIM repositories (including this one).
#
# For customized output location, you can define the env var OSSIM_INSTALL_PREFIX
# prior to building Makefiles, and the output will be written there.
#
###############################################################################

CREATE_LINK=$1

# Set GoCD-specific environment:
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPT_DIR/../..
export OSSIM_DEV_HOME=$PWD
popd

# Establish CMAKE's install directory:
if [ -z "$OSSIM_INSTALL_PREFIX" ]; then
    OSSIM_INSTALL_PREFIX=$OSSIM_DEV_HOME/install
fi


echo "STATUS: Checking presence of env var OSSIM_BUILD_DIR = <$OSSIM_BUILD_DIR>...";
if [ -z $OSSIM_BUILD_DIR ]; then
  OSSIM_BUILD_DIR=$OSSIM_DEV_HOME/build;
  if [ ! -d $OSSIM_BUILD_DIR ] ; then
    echo "ERROR: OSSIM_BUILD_DIR = <$OSSIM_BUILD_DIR> does not exist at this location. Cannot install";
    exit 1;
  fi
fi

pushd $OSSIM_BUILD_DIR
echo "STATUS: Performing make install to <$OSSIM_INSTALL_PREFIX>"
make install
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered during make install. Check the console log and correct."
  popd
  exit 1
fi
echo; echo "STATUS: Install completed successfully. Install located in $OSSIM_INSTALL_PREFIX"
popd # out of OSSIM_BUILD_DIR

pushd $OSSIM_INSTALL_PREFIX
INSTALL_DIRNAME=${PWD##*/}
echo; echo "STATUS: Zipping up install directory: <$INSTALL_DIRNAME>..."
cd ..

TIMESTAMP=`date +%Y-%m-%d-%H%M`
FILENAME_TS="install_$GO_PIPELINE_NAME_$TIMESTAMP.zip"
zip -r $FILENAME_TS $INSTALL_DIRNAME
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered while zipping the install dir. Check the console log and correct."
  popd
  exit 1
fi

if [ "$CREATE_LINK" == "create-link" ]; then
  # Create a link that can be used as artifact of latest build/install. This will overwrite previous sandbox's so only
  # the latest is used for testing (standalone) or generating expected results
  echo "Build timestamp: $TIMESTAMP" > install.txt  
  echo "Pipeline Name:   $GO_PIPELINE_NAME" >> install.txt
  echo "Job Name:        $GO_JOB_NAME" >> install.txt
  echo >> install.txt
  ln -s $FILENAME_TS "install.zip"
  echo "STATUS: Successfully zipped install dir to <$PWD/$FILENAME> and created link <install.zip>."
fi

popd # Out of dir containing install subdir
exit 0

