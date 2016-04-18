#!/bin/bash

###   These will need to be passed in by the environment ####
#
# example: rpmbuild-binary.sh dev 1.9.0 1 el6
#
# Usage rpmbuild.sh <git_branch> <spec> 
#
GIT_BRANCH=$1
OSSIM_SPEC=$2 
############################################################
pushd `dirname $0` >/dev/null
SCRIPT_DIR=$PWD
popd > /dev/null

pushd $SCRIPT_DIR/../.. >/dev/null
ROOT_DIR=$PWD
popd

. $SCRIPT_DIR/functions.sh

pushd $ROOT_DIR >/dev/null

if [ ! -d $ROOT_DIR/rpmbuild ] ; then
        mkdir -p $ROOT_DIR/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
fi

cp $ROOT_DIR/ossim-GoCD/support/linux/rpm_specs/*.spec $ROOT_DIR/rpmbuild/SPECS
mv $ROOT_DIR/install.zip $ROOT_DIR/rpmbuild/BUILD

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/ossim-all-${OSSIM_SPEC}.spec
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for rpm binary build."
  popd >/dev/null
  exit 1
fi

popd >/dev/null
