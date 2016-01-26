#!/bin/bash
GIT_BRANCH=$1
DEPLOY_SITE=$2

pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
popd >/dev/null

. $SCRIPT_DIR/versions.sh

if [ -z "${OSSIM_DEV_HOME}" ]; then
   pushd $SCRIPT_DIR/../.. >/dev/null
   export OSSIM_DEV_HOME=$PWD
   popd >/dev/null
fi
if [ -z "${OSSIM_INSTALL_PREFIX}" ]; then
   export OSSIM_INSTALL_PREFIX=$OSSIM_DEV_HOME/install
fi

if [ ! -d "${OSSIM_INSTALL_PREFIX}" ]; then
   if [ -f "${OSSIM_DEV_HOME}/install.zip" ]; then
      pushd ${OSSIM_DEV_HOME} >/dev/null
      unzip "${OSSIM_DEV_HOME}/install.zip"
      popd >/dev/null
   fi
fi

if [ -d "${OSSIM_INSTALL_PREFIX}" ]; then
   scp "${OSSIM_INSTALL_PREFIX}/share/omar/omar-app-${O2_APP_VERSION}.jar" omar.ossim.org:/tmp/omar-app-${O2_APP_VERSION}-${GIT_BRANCH}.jar
   ssh $DEPLOY_SITE "~/bin/deploy-o2.sh ${GIT_BRANCH} ${O2_APP_VERSION}"
else
   echo "ERROR: No O2 Application jar found!!!"
   exit 1
fi
