#!/bin/bash 
###############################################################################
#
# Build script for all OSSIM repositories
#
# This script can be run from anywhere. It performs three functions:
# 
#   1. If running in an interactive shell, it queries for user for a build type
#      (Release, Debug, etc.),
#   2. It invokes the cmake configuration script to generate Makefiles in the
#      build directory.
#   3. It builds all OSSIM code.
#
# No env vars need to be predefined. The build output will be written to
# $OSSIMLABS_DIR/build/<build_type> where $OSSIMLABS_DIR is the top-level
# folder containing all OSSIM repositories (including this one).
#
# For customized output location, you can define the env var OSSIM_BUILD_DIR
# prior to running this script, and the output will be written there.
#
###############################################################################

# Uncomment following line to debug script line by line:
#set -x; trap read debug

echo; echo "Running build.sh script from <$PWD>...";

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
pushd $SCRIPT_DIR/../..
GOCD_WORKSPACE=$PWD
echo "STATUS: Set working directory GOCD_WORKSPACE = <$GOCD_WORKSPACE>"

export OSSIM_BUILD_DIR=$GOCD_WORKSPACE/build
export OSSIM_INSTALL_PREFIX=$GOCD_WORKSPACE/install

ossim/scripts/linux/build.sh
if [ $? -ne 0 ]; then
  echo; echo "Error encountered during build. Check the console log and correct."
  popd
  exit 1
fi

ossim/scripts/linux/install.sh
if [ $? -ne 0 ]; then
  echo; echo "Error encountered during install. Check the console log and correct."
  popd
  exit 1
fi

zip -r install.zip install
if [ $? -ne 0 ]; then
  echo; echo "Error encountered zipping install dir. Check the console log and correct."
  popd
  exit 1
fi

echo; echo "GoCD build/install/zip completed successfully."

popd
exit 0

