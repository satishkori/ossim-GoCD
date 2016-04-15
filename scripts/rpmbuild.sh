#!/bin/bash

###   These will need to be passed in by the environment ####
#
# example: rpmbuild.sh dev 1.9.0 1 el6
#
# Usage rpmbuild.sh <git_branch> <OSSIM_VERSION> 
#
GIT_BRANCH=$1
OSSIM_SPEC=$2 
############################################################

function getOsInfo {
# Determine OS platform
#        UNAME=$(uname | tr "[:upper:]" "[:lower:]")
        local DISTRO=
        local majorVersion=
        local osArch=`uname -i`
        if [ -f /etc/redhat-release ] ; then
                DISTRO=`cat /etc/redhat-release | cut -d' ' -f1`
                majorVersion=`cat /etc/redhat-release | grep  -o "[0-9]*\.[0-9]*\.*[0-9]*" | cut -d'.' -f1`
        fi
        eval "$1=${DISTRO}"
        eval "$2=${majorVersion}"
        eval "$3=${osArch}"
}


pushd `dirname $0` >/dev/null
SCRIPT_DIR=$PWD
popd > /dev/null

pushd $SCRIPT_DIR/../.. >/dev/null
ROOT_DIR=$PWD
popd

pushd $ROOT_DIR > /dev/null
echo "REMOVING .git directories"
rm -rf `find . -name ".git"`

if [ ! -d rpmbuild ] ; then
        mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
fi

if [ -d "ossim-$OSSIM_VERSION" ] ; then
   # Clean if out...
   rm -rf ossim-$OSSIM_VERSION/*
else
   mkdir ossim-$OSSIM_VERSION
fi
cp ossim-GoCD/support/linux/rpm_specs/*.spec rpmbuild/SPECS

mv ossim $ROOT_DIR/ossim-$OSSIM_VERSION
mv ossim-* $ROOT_DIR/ossim-$OSSIM_VERSION
tar cvfz ossim-$OSSIM_VERSION.tar.gz ossim-$OSSIM_VERSION

mv $ROOT_DIR/ossim-$OSSIM_VERSION.tar.gz $ROOT_DIR/rpmbuild/SOURCES

echo "building ossim rpms..."
echo "rpm spec file: ossim-all-${OSSIM_SPEC}.spec"

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" rpmbuild/SPECS/ossim-all-${OSSIM_SPEC}.spec
if [ $? != 0 ] ; then 
  echo "ERROR: rpmbuild failed for OSSIM core";
  echo; exit 1;
fi


#---
# Build oldmar rpm:
#---
if [ -d "$ROOT_DIR/oldmar" ] ; then
   echo "building oldmar rpms..."
   cp $ROOT_DIR/oldmar/support/linux/rpm_specs/omar.spec rpmbuild/SPECS/oldmar.spec

   # Rename:
   mv $ROOT_DIR/oldmar omar-$OSSIM_VERSION
   if [ $? != 0 ] ; then 
     echo "ERROR: Unable to move the oldmar version";
     echo; exit 1;
   fi

   # copy the joms jar from rpm build of ossim-oms from the maven repo to the plugins.
   # cp ~/.m2/repository/org/ossim/joms/${OSSIM_VERSION}/joms-${OSSIM_VERSION}.jar omar-$OSSIM_VERSION/plugins/omar-oms/lib/joms-${OSSIM_VERSION}.jar

   # Make the source tarball.
   tar cvfz omar-$OSSIM_VERSION.tar.gz omar-$OSSIM_VERSION
   if [ $? != 0 ] ; then 
     echo "ERROR: tar failed for omar source";
     echo; exit 1;
   fi

   # Move to rpmbuild/SOURCES dir.
   mv $ROOT_DIR/omar-$OSSIM_VERSION.tar.gz $ROOT_DIR/rpmbuild/SOURCES/omar-$OSSIM_VERSION.tar.gz
   if [ $? != 0 ] ; then 
     echo "ERROR: move failed for SOURCES";
     echo; exit 1;
   fi

   # Copy the spec file:
   rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" rpmbuild/SPECS/oldmar.spec
   if [ $? != 0 ] ; then 
     echo "ERROR: rpmbuild failed for old omar spec";
     echo; exit 1;
   fi
fi

# build new omar services
#
if [ -d "$ROOT_DIR/omar" ] ; then
   cp $ROOT_DIR/omar/support/linux/rpm_specs/omar.spec rpmbuild/SPECS/omar.spec

   mv omar o2-$O2_VERSION

   tar cvfz o2-$O2_VERSION.tar.gz o2-$O2_VERSION
   if [ $? != 0 ] ; then 
     echo "ERROR: tar failed for omar source";
     echo; exit 1;
   fi
   # Move to rpmbuild/SOURCES dir.
   mv $ROOT_DIR/o2-$O2_VERSION.tar.gz $ROOT_DIR/rpmbuild/SOURCES/o2-$O2_VERSION.tar.gz
   if [ $? != 0 ] ; then 
     echo "ERROR: move failed for SOURCES";
     echo; exit 1;
   fi
   # Copy the spec file:
   rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "O2_VERSION ${O2_VERSION}" --define "O2_BUILD_RELEASE ${O2_BUILD_RELEASE}" rpmbuild/SPECS/omar.spec
   if [ $? != 0 ] ; then 
     echo "ERROR: rpmbuild failed for old omar spec";
     echo; exit 1;
   fi

fi

getOsInfo os major_version os_arch


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
    createrepo .
  popd
tar cvfz rpms.tgz $os
mv rpms.tgz ${ROOT_DIR}/
popd > /dev/null
