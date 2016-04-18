#!/bin/bash
# Set GoCD-specific environment:
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export OSSIM_DEV_HOME=$PWD
export ROOT_DIR=$PWD
popd > /dev/null
popd >/dev/null

source $SCRIPT_DIR/ossim-env.sh

# make sure the joms jar is in the local maven repo
mvn install:install-file -Dfile=$OSSIM_DEV_HOME/install/share/java/joms-$OSSIM_VERSION.jar -DgroupId=org.ossim -DartifactId=joms -Dversion=$OSSIM_VERSION -Dpackaging=jar
$ROOT_DIR/omar/build_scripts/linux/build.sh

