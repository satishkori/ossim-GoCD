#!/bin/bash
# Set GoCD-specific environment:
ZIP_OPTION=$1


pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export ROOT_DIR=$PWD
popd > /dev/null
popd >/dev/null
source $SCRIPT_DIR/ossim-env.sh

$ROOT_DIR/omar/build_scripts/linux/install.sh

if [ $? -ne 0 ]; then
  echo; echo "ERROR: Failed installation for oldmar binaries."
  exit 1
fi

pushd $ROOT_DIR

if [ "$ZIP_OPTION" == "-z" ]; then
   rm -f install.tgz
   tar cvfz install.tgz install
   if [ $? -ne 0 ]; then
      echo; echo "ERROR: Failed zipping the OMAR binaries."
      popd
      exit 1
   fi

fi

popd
