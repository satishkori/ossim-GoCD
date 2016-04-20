#!/bin/bash 
# Set GoCD-specific environment:
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export ROOT_DIR=$PWD
export OSSIM_DEV_HOME=$PWD
popd > /dev/null
popd >/dev/null
source $SCRIPT_DIR/ossim-env.sh

if [ ! -f $OSSIM_DEV_HOME/install/share/java/joms-$OSSIM_VERSION.jar ]; then
   echo "ERROR: joms-$OSSIM_VERSION.jar is not found in the install artifact and OMAR can't be built."
   exit 1
fi
# make sure the joms jar is in the local maven repo
mvn install:install-file -Dfile=$OSSIM_DEV_HOME/install/share/java/joms-$OSSIM_VERSION.jar -DgroupId=org.ossim -DartifactId=joms -Dversion=$OSSIM_VERSION -Dpackaging=jar
mv $OSSIM_DEV_HOME/install ossim-install

if [ $? -ne 0 ]; then
 echo; echo "ERROR: MVN install failed for joms."
 exit 1
fi

$ROOT_DIR/omar/build_scripts/linux/build.sh
if [ $? -ne 0 ]; then
 echo; echo "ERROR: OMAR failed to build."
 exit 1
fi



