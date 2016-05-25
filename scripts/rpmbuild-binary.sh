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

#if [ ! -d $ROOT_DIR/rpmbuild ] ; then
mkdir -p $ROOT_DIR/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
#fi

cp $ROOT_DIR/ossim-GoCD/support/linux/rpm_specs/*.spec $ROOT_DIR/rpmbuild/SPECS

# Setup the ossim binaries for packaging
#
pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
tar xvfz $ROOT_DIR/ossim-install/install.tgz 
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


# Setup the oldmar for packaging
#
pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
tar xvfz $ROOT_DIR/oldmar-install/install.tgz 
popd
echo rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/oldmar-all.spec

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/oldmar-all.spec


if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for OLDMAR rpm binary build."
  popd >/dev/null
  exit 1
fi

# Setup and package the new O2 distribution
pushd $ROOT_DIR/rpmbuild/BUILD/
rm -rf *
tar  xvfz $ROOT_DIR/o2-install/install.tgz 
popd
echo rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "O2_VERSION ${O2_VERSION}" --define "O2_BUILD_RELEASE ${O2_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/o2-all.spec
rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "O2_VERSION ${O2_VERSION}" --define "O2_BUILD_RELEASE ${O2_BUILD_RELEASE}" ${ROOT_DIR}/rpmbuild/SPECS/o2-all.spec
if [ $? -ne 0 ]; then
  echo; echo "ERROR: Build failed for O2 rpm binary build."
  popd >/dev/null
  exit 1
fi

# now create the yum repo artifact tgz file
#
getOsInfo os major_version os_arch

# create the RPM dir
rpmdir=${ROOT_DIR}/rpmbuild/RPMS/${os}/${major_version}/${GIT_BRANCH}/${os_arch}
if [ -d "$rpmdir" ] ; then
  rm -rf $rpmdir/*
fi
mkdir -p $rpmdir

pushd ${ROOT_DIR}/rpmbuild/RPMS >/dev/null
mv `find ./${os_arch} -name "*.rpm"` $rpmdir/
if [ -d "${OSSIM_DEPS_RPMS}" ] ; then
  cp $OSSIM_DEPS_RPMS/*.rpm $rpmdir/
fi
  pushd $rpmdir >/dev/null
    createrepo --simple-md-filenames .
  popd
tar cvfz rpms.tgz $os
mv rpms.tgz ${ROOT_DIR}/
popd > /dev/null
