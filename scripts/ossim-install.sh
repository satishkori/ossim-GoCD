#!/bin/bash 
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export OSSIM_DEV_HOME=$PWD
popd > /dev/null
popd >/dev/null

source $SCRIPT_DIR/ossim-env.sh

# Establish CMAKE's install directory:
if [ -z "$OSSIM_INSTALL_PREFIX" ]; then
    export OSSIM_INSTALL_PREFIX=$OSSIM_DEV_HOME/install
fi

echo "STATUS: Checking presence of env var OSSIM_BUILD_DIR = <$OSSIM_BUILD_DIR>...";
if [ -z $OSSIM_BUILD_DIR ]; then
  export OSSIM_BUILD_DIR=$OSSIM_DEV_HOME/build;
  if [ ! -d $OSSIM_BUILD_DIR ] ; then
    echo "ERROR: OSSIM_BUILD_DIR = <$OSSIM_BUILD_DIR> does not exist at this location. Cannot install";
    exit 1;
  fi
fi

echo "STATUS: Performing make install to <$OSSIM_INSTALL_PREFIX>"
pushd $OSSIM_DEV_HOME/ossim/scripts
./install.sh
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Error encountered ossim install. Check the console log and correct."
  popd >/dev/null
  exit 1
fi
popd >/dev/null
echo; echo "STATUS: Install completed successfully. Install located in $OSSIM_INSTALL_PREFIX"
