#!/bin/bash 
# Set GoCD-specific environment:

# Version definitions
if [ -z $OSSIM_DEPENDENCY_VERSION ]; then
   export OSSIM_DEPENDENCY_VERSION=1.0.0
fi

# for packaging and general version number 
#
if [ -z $OSSIM_VERSION ] ; then
   export OSSIM_VERSION=1.9.0
fi

# for packaging and general version number 
#
if [ -z $O2_VERSION ] ; then
   export O2_VERSION=1.0.0
fi

# For RPM packaging
#
if [ -z $OSSIM_BUILD_RELEASE ] ; then
   export OSSIM_BUILD_RELEASE=1
fi

# For RPM packaging
#
if [ -z $O2_BUILD_RELEASE ] ; then
   export O2_BUILD_RELEASE=1
fi

if [ -z $JAVA_HOME ]; then
   export JAVA_HOME=/usr/lib/jvm/java
fi

if [ -z $BUILD_OMS ] ; then
   export BUILD_OMS=ON
fi

if [ -z $BUILD_OSSIM_APPS ] ; then
   export BUILD_OSSIM_APPS=ON
fi
if [ -z $BUILD_OSSIM_CURL_APPS ] ; then
   export BUILD_OSSIM_CURL_APPS=ON
fi

if [ -z $BUILD_OSSIM_VIDEO ] ; then
   export BUILD_OSSIM_VIDEO=ON
fi

if [ -z $BUILD_OSSIM_PLANET ] ; then
   export BUILD_OSSIM_PLANET=ON
fi

if [ -z $BUILD_OSSIM_GUI ] ; then
   export BUILD_OSSIM_GUI=ON
fi

if [ -z $BUILD_OSSIM_WMS ] ; then
   export BUILD_OSSIM_WMS=ON
fi

if [ -z $BUILD_CNES_PLUGIN ] ; then
   export BUILD_CNES_PLUGIN=ON
fi

if [ -z $BUILD_WEB_PLUGIN ] ; then
   export BUILD_WEB_PLUGIN=ON
fi

if [ -z $BUILD_SQLITE_PLUGIN ] ; then
   export BUILD_SQLITE_PLUGIN=ON
fi

if [ -z $BUILD_KAKADU_PLUGIN ] ; then
   export BUILD_KAKADU_PLUGIN=ON
fi

if [ -z $BUILD_KML_PLUGIN ] ; then
   export BUILD_KML_PLUGIN=ON
fi

if [ -z $BUILD_GDAL_PLUGIN ] ; then
   export BUILD_GDAL_PLUGIN=ON
fi

if [ -z $BUILD_HDF5_PLUGIN ] ; then
   export BUILD_HDF5_PLUGIN=ON
fi

if [ -z $BUILD_POTRACE_PLUGIN ] ; then
   export BUILD_POTRACE_PLUGIN=ON
fi

if [ -z $BUILD_GEOPDF_PLUGIN ] ; then
export BUILD_GEOPDF_PLUGIN=ON
fi

if [ -z $BUILD_OPENCV_PLUGIN ] ; then
   export BUILD_OPENCV_PLUGIN=ON
fi

if [ -z $BUILD_OPENJPEG_PLUGIN ] ; then
   export BUILD_OPENJPEG_PLUGIN=ON
fi

if [ -z $BUILD_PNG_PLUGIN ] ; then
   export BUILD_PNG_PLUGIN=ON
fi

if [ -z $BUILD_JPEG12_PLUGIN ] ; then
   export BUILD_JPEG12_PLUGIN=ON
fi

if [ -z $BUILD_OSSIM_HDF5_SUPPORT ] ; then
   export BUILD_OSSIM_HDF5_SUPPORT=ON
fi


if [ -z $OSSIM_BUILD_ADDITIONAL_DIRECTORIES ] ; then
   if [ -d $OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server ]; then
     export OSSIM_BUILD_ADDITIONAL_DIRECTORIES=$OSSIM_DEV_HOME/ossim-private/ossim-kakadu-jpip-server
   fi
fi
