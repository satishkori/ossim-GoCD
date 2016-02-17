#!/bin/bash

###   These will need to be passed in by the environment ####
#
# example: rpmbuild.sh dev 1.9.0 1 el6
#
GIT_BRANCH=$1
OSSIM_VERSION=$2
OSSIM_BUILD_RELEASE=$3
OSSIM_SPEC=$4 
############################################################


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
cp ossim/support/linux/rpm_specs/*.spec rpmbuild/SPECS

mv ossim $ROOT_DIR/ossim-$OSSIM_VERSION
mv ossim-* $ROOT_DIR/ossim-$OSSIM_VERSION
tar cvfz ossim-$OSSIM_VERSION.tar.gz ossim-$OSSIM_VERSION

mv $ROOT_DIR/ossim-$OSSIM_VERSION.tar.gz $ROOT_DIR/rpmbuild/SOURCES

echo "building ossim rpms..."
echo "rpm spec file: ossim-all-${OSSIM_SPEC}.spec"

rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" rpmbuild/SPECS/ossim-all-${OSSIM_SPEC}.spec


#---
# Build oldmar rpm:
#---
if [ -d "$ROOT_DIR/oldomar"] ; then
   echo "building oldmar rpms..."

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
   cp $ROOT_DIR/oldmar/support/linux/rpm_specs/omar.spec rpmbuild/SPECS/oldmar.spec
   if [ $? != 0 ] ; then 
     echo "ERROR: cp fialed for omar spec file.";
     echo; exit 1;
   fi

   rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" rpmbuild/SPECS/oldmar.spec
   if [ $? != 0 ] ; then 
     echo "ERROR: rpmbuild failed for old omar spec";
     echo; exit 1;
   fi
fi


# ossim kakadu plugin:

# Requires ossim-lib and ossim-devel rpms.

# if [ ! -d "ossim-kakadu-plugin-$OSSIM_VERSION" ] ; then
#    mkdir ossim-kakadu-plugin-$OSSIM_VERSION
# fi

# cp -r ossim-$OSSIM_VERSION/ossim/cmake/CMakeModules ossim-kakadu-plugin-$OSSIM_VERSION/. > /dev/null
# cp -r ossim-$OSSIM_VERSION/ossim-plugins/kakadu ossim-kakadu-plugin-$OSSIM_VERSION/. > /dev/null
# cp -r /opt/kakadu/kakadu_src ossim-kakadu-plugin-$OSSIM_VERSION/. > /dev/null

# tar cvfz ossim-kakadu-plugin-$OSSIM_VERSION.tar.gz ossim-kakadu-plugin-$OSSIM_VERSION
# mv $ROOT_DIR/ossim-kakadu-plugin-$OSSIM_VERSION.tar.gz $ROOT_DIR/rpmbuild/SOURCES

# rpmbuild -ba --define "_topdir ${ROOT_DIR}/rpmbuild" --define "RPM_OSSIM_VERSION ${OSSIM_VERSION}" --define "BUILD_RELEASE ${OSSIM_BUILD_RELEASE}" rpmbuild/SPECS/ossim-kakadu-plugin-${OSSIM_SPEC}.spec

