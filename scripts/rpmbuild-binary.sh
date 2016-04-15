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

if [ ! -d rpmbuild ] ; then
        mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
fi

mv install.zip rpmbuild/BUILD


