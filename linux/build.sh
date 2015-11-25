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
popd

CMAKE_CONFIG_SCRIPT=$GOCD_WORKSPACE/ossim/cmake/scripts/ossim-cmake-config-LINUX.sh
CMAKE_BUILD_TYPE="Release"
export OSSIM_INSTALL_PREFIX=$GOCD_WORKSPACE/install
export OSSIM_BUILD_DIR=$GOCD_WORKSPACE/build

# Try running the CMake config script (sourcing here to capture OSSIM_BUILD_DIR var 
# possibly initialized in cmake config script)
if [ -x $CMAKE_CONFIG_SCRIPT ]; then
  . $CMAKE_CONFIG_SCRIPT $CMAKE_BUILD_TYPE
else
  echo; echo "ERROR: Error: Cannot locate the cmake config script expected at $CMAKE_CONFIG_SCRIPT. Cannot continue."
  exit 1
fi
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered during CMake configuration. Build aborted."
  exit 1
fi

pushd $OSSIM_BUILD_DIR
echo "STATUS: Performing make in <$PWD>"
make -j 8
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered during make. Check the console log and correct."
  popd
  exit 1
fi
echo; echo "STATUS: Build completed successfully. Binaries located in $OSSIM_BUILD_DIR"

echo "STATUS: Performing make install to <$OSSIM_INSTALL_PREFIX>"
make install
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered during make install. Check the console log and correct."
  popd
  exit 1
fi
echo; echo "STATUS: Install completed successfully. Install located in $OSSIM_INSTALL_PREFIX"
exit 0

