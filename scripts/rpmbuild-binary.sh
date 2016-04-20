#!/bin/bash

###   These will need to be passed in by the environment ####
#
# example: rpmbuild-binary.sh dev 1.9.0 1 el6
#
# Usage rpmbuild.sh <git_branch> <spec> 
#
GIT_BRANCH=$1
OSSIM_SPEC=$2

if [ -z $OSSIM_DPEC ]; then
  export OSSIM_SPEC=`uname -r | grep -o el[0-9]`
fi 
############################################################
pushd `dirname $0` >/dev/null
SCRIPT_DIR=$PWD
popd > /dev/null

pushd $SCRIPT_DIR/../.. >/dev/null
ROOT_DIR=$PWD
popd

source $SCRIPT_DIR/ossim-env.sh
source $SCRIPT_DIR/functions.sh

pushd $ROOT_DIR >/dev/null

#if [ ! -d $ROOT_DIR/rpmbuild ] ; then
mkdir -p $ROOT_DIR/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
#fi

cp $ROOT_DIR/ossim-GoCD/support/linux/rpm_specs/*.spec $ROOT_DIR/rpmbuild/SPECS

pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
unzip -o $ROOT_DIR/ossim-install/install.zip 
popd

#unzip -o $ROOT_DIR/oldmar-install/install.zip 
#unzip -o $ROOT_DIR/o2-install/install.zip 
echo rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/ossim-all.spec

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/ossim-all.spec
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for OSSIM rpm binary build."
  popd >/dev/null
  exit 1
fi


pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
unzip -o $ROOT_DIR/oldmar-install/install.zip 
popd
echo rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/oldmar-all.spec

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/oldmar-all.spec


if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for OLDMAR rpm binary build."
  popd >/dev/null
  exit 1
fi

pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
unzip -o $ROOT_DIR/o2-install/install.zip 
popd
echo rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "O2_VERSION ${OSSIM_VERSION}" --define "O2_BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/o2-all.spec
rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "O2_VERSION ${OSSIM_VERSION}" --define "O2_BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/o2-all.spec
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for O2 rpm binary build."
  popd >/dev/null
  exit 1
fi


popd >/dev/null
