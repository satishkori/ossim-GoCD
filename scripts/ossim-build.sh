#!/bin/bash 
# Set GoCD-specific environment:
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export OSSIM_DEV_HOME=$PWD
popd > /dev/null
popd >/dev/null

source $SCRIPT_DIR/ossim-env.sh

pushd $OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux
./setup.sh
popd

pushd $OSSIM_DEV_HOME/ossim/scripts
./build.sh
popd

pushd $OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux
./build.sh
popd

if [ -d $OSSIM_DEV_HOME/oldomar ]; then
   pushd $OSSIM_DEV_HOME/oldomar/build_scripts/linux
   ./build.sh
   popd
fi

