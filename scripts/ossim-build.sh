#!/bin/bash 
# Set GoCD-specific environment:
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`
pushd $SCRIPT_DIR/../.. >/dev/null
export OSSIM_DEV_HOME=$PWD
popd > /dev/null
popd >/dev/null

if [ -z JAVA_HOME ]; then
   export JAVA_HOME=/usr/lib/jvm/java
fi

if [ -z OSSIM_VERSION ] ; then
   export OSSIM_VERSION=1.9.0
fi

if [ -z BUILD_OMS ] ; then
   export BUILD_OMS=ON
fi

if [ -z BUILD_OSSIM_VIDEO ] ; then
   export BUILD_OSSIM_VIDEO=ON
fi

if [ -z BUILD_OSSIM_PLANET ] ; then
   export BUILD_OSSIM_PLANET=ON
fi

if [ -z BUILD_OSSIM_GUI ] ; then
   export BUILD_OSSIM_GUI=ON
fi

if [ -z BUILD_OSSIM_WMS ] ; then
   export BUILD_OSSIM_WMS=ON
fi

if [ -z BUILD_CNES_PLUGIN ] ; then
   export BUILD_CNES_PLUGIN=ON
fi

if [ -z BUILD_WEB_PLUGIN ] ; then
   export BUILD_WEB_PLUGIN=ON
fi


if [ -z BUILD_SQLITE_PLUGIN ] ; then
   export BUILD_SQLITE_PLUGIN=ON
fi

if [ -z BUILD_KAKADU_PLUGIN ] ; then
   export BUILD_KAKADU_PLUGIN=ON
fi

if [ -z BUILD_KML_PLUGIN ] ; then
   export BUILD_KML_PLUGIN=ON
fi

if [ -z BUILD_GDAL_PLUGIN ] ; then
   export BUILD_GDAL_PLUGIN=ON
fi

if [ -z BUILD_HDF5_PLUGIN ] ; then
   export BUILD_HDF5_PLUGIN=ON
fi

if [ -z BUILD_POTRACE_PLUGIN ] ; then
   export BUILD_POTRACE_PLUGIN=ON
fi

if [ -z BUILD_GEOPDF_PLUGIN ] ; then
   export BUILD_GEOPDF_PLUGIN=ON
fi

if [ -z BUILD_OPENCV_PLUGIN ] ; then
   export BUILD_OPENCV_PLUGIN=ON
fi

if [ -z BUILD_OPENJPEG_PLUGIN ] ; then
   export BUILD_OPENJPEG_PLUGIN=ON
fi


if [ -z OSSIM_BUILD_ADDITIONAL_DIRECTORIES ] ; then
   export OSSIM_BUILD_ADDITIONAL_DIRECTORIES=/var/lib/go-agent/pipelines/ossimlabs-dev/ossim-private/ossim-kakadu-jpip-server
fi


echo "***************BUILD_OPENJPEG_PLUGIN=$BUILD_OPENJPEG_PLUGIN"
pushd $OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux
./setup.sh
popd

pushd $OSSIM_DEV_HOME/ossim/scripts
./build.sh
popd

pushd $OSSIM_DEV_HOME/ossim-oms/joms/build_scripts/linux
./build.sh
popd

pushd $OSSIM_DEV_HOME/omar/build_scripts/linux
