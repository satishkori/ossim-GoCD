#---
# File: ossim-all.spec
#
# Spec file for building ossim rpms with rpmbuild.
#
#
# Example usage:
# rpmbuild -ba --define 'RPM_OSSIM_VERSION 1.9.0' --define 'BUILD_RELEASE 1' ossim-el7.spec
#
# Caveats: 
# 1) Builder/user needs "groovy" in their search path.
# 2) Use "archive.sh" script in ossim/scripts/archive.sh to generate the source
#    tar ball, e.g. ossim-1.9.0.tar.gz, from appropriate git branch.
#---
Name:           ossim
Version:        %{RPM_OSSIM_VERSION} 
Release:        %{BUILD_RELEASE}%{?dist}
Summary:        Open Source Software Image Map library and command line applications
Group:          System Environment/Libraries
#TODO: Which version?
License:        LGPLv2+
URL:            https://github.com/orgs/ossimlabs/dashboard
#Source0:        http://download.osgeo.org/ossim/source/%{name}-%{version}.tar.gz
%define is_systemd %(test -d /etc/systemd && echo 1 || echo 0)


#BuildRequires: ant
#BuildRequires: cmake

#Requires: ffmpeg
#Requires: gdal
#Requires: geos
#BuildRequires: hdf5a-devel
#Requires: java
#BuildRequires: libcurl-devel
#BuildRequires: libgeotiff-devel
#BuildRequires: libjpeg-devel
#BuildRequires: libpng-devel
#BuildRequires: libtiff4-devel
#BuildRequires: minizip-devel
#BuildRequires: opencv-devel
#BuildRequires: OpenSceneGraph-devel
#BuildRequires: OpenThreads-devel
#BuildRequires: podofo-devel
#BuildRequires: qt4-devel
#BuildRequires: sqlite-devel
#BuildRequires: gpstk-devel
#BuildRequires: openjpeg2-devel
#BuildRequires: swig
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}


%description
OSSIM is a powerful suite of geospatial libraries and applications
used to process remote sensing imagery, maps, terrain, and vector data.

%package    devel
Summary:        Development files for ossim
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description devel
Development files for ossim.

%package    libs
Summary:        Development files for ossim
Group:          System Environment/Libraries

%description libs
Libraries for ossim.

%package    geocell
Summary:        Desktop electronic light table
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description geocell
Desktop electronic light table for geospatial image processing. Has 2D, 2 1/2D
and 3D viewer with image chain editing capabilities.

%package        oms
Summary:        Wrapper library/java bindings for interfacing with ossim.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    oms
This sub-package contains the oms wrapper library with java bindings for
interfacing with the ossim library from java.

%package        oms-devel
Summary:        Development files for ossim oms wrapper library.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    oms-devel
This sub-package contains the development files for oms.

%package    planet
Summary:        3D ossim library interface via OpenSceneGraph
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description planet
3D ossim library interface via OpenSceneGraph.

%package    planet-devel
Summary:        Development files for ossim planet.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description planet-devel
This sub-package contains development files for ossim planet.

%package        test-apps
Summary:        Ossim test apps.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    test-apps
A suite of ossim test apps.

%package    video
Summary:        Ossim vedeo library.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    video
Ossim vedeo library.

%package    video-devel
Summary:        Development files for ossim planet.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    video-devel
This sub-package contains development files for ossim planet.

# libwms does not depend on ossim
%package        wms
Summary:        wms ossim library
Group:          System Environment/Libraries

%description    wms
This sub-package contains the web mapping service (wms) library.

%package    wms-devel
Summary:        Development files libwms
Group:          System Environment/Libraries
Requires:       libwms%{?_isa} = %{version}-%{release}

%description    wms-devel
This sub-package contains the development files for libwms.

#---
# ossim plugins:
#---
%package    cnes-plugin
Summary:        Plugin with various sensor models
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description cnes-plugin
This sub-package contains the ossim plugin which has various SAR sensor models,
readers, and support data parsers.  Most of this code was provided by the ORFEO
Toolbox (OTB) group / Centre national d'études spatiales.

%package    gdal-plugin
Summary:        GDAL ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description gdal-plugin
This sub-package contains the Geospatial Data Abstraction Library(gdal) ossim
plugin for reading/writing images supported by the gdal library.

%package    geopdf-plugin
Summary:        geopdf ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description geopdf-plugin
This sub-package contains the geopdf ossim plugin for reading geopdf files via
the podofo library.

#%package    hdf5-plugin
#Summary:        HDF5 ossim plugin
#Group:          System Environment/Libraries
#Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

#%description hdf5-plugin
#This sub-package contains the Hierarchical Data Format(hdf) ossim plugin for
#reading hdf5 images via the hdf5 libraries

%package    jpip-server
Summary:        ossim kakadu jpip server
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}
Requires:       %{name}-kakadu-plugin%{?_isa} = %{version}-%{release}

%description    jpip-server
This sub-package contains the ossim kakadu jpip server for streaming
J2K compressed data to via the Kakadu library.

%package    kml-plugin
Summary:        kml ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    kml-plugin
This sub-package contains the kmlsuperoverlay ossim plugin for reading/writing
kml super overlays.

%package    kakadu-plugin
Summary:        kakadu ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    kakadu-plugin
This sub-package contains the kakadu ossim plugin for reading/writing
J2K compressed data via the Kakadu library.

%package    jpeg12-plugin
Summary:        jpeg12 ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    jpeg12-plugin
This sub-package contains the jpeg12 ossim plugin.

%package    mrsid-plugin
Summary:        mrsid ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    mrsid-plugin
This sub-package contains the mrsid ossim plugin for reading/writing
mrsid compressed data via the MrSID library.

%package    opencv-plugin
Summary:        OSSIM OpenCV plugin, contains registration code.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    opencv-plugin
This sub-package contains the ossim opencv plugin with various pieces of 
image registration code.

%package    openjpeg-plugin
Summary:        OpenJPEG ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    openjpeg-plugin
This sub-package contains the OpenJPEG ossim plugin for
reading/writing J2K compressed images via the OpenJPEG library.

%package    png-plugin
Summary:        PNG ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description png-plugin
This sub-package contains the Portable Network Graphic(png) ossim plugin for
reading/writing png images via the png library.

%package    sqlite-plugin
Summary:        OSSIM sqlite plugin, contains GeoPackage reader/writer.
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description sqlite-plugin
This sub-package contains GeoPackage reader/writer.

%package    web-plugin
Summary:        web ossim plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description web-plugin
This sub-package contains the web ossim plugin for interfacing with http via
curl library. 

%package    potrace-plugin
Summary:        potrace plugin
Group:          System Environment/Libraries
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description potrace-plugin
This sub-package contains the potrace plugin. 

%build
echo "********************** $OSSIM_DEV_HOME ***********************"

%install
echo "************************BUILDDIR: %{_builddir}*************** "
echo "************************BUILDROOT: %{buildroot}*************** "
pushd %{_builddir}/../..
export ROOT_DIR=$PWD
popd > /dev/null

export DESTDIR=%{buildroot}
mkdir -p %{_bindir}
mkdir -p %{_libdir}

pushd %{_builddir}/install
echo off
  for x in `find include`; do
    if [ -f $x ] ; then
      install -p -m644 -D $x %{buildroot}/usr/$x;
    fi
  done
  for x in `find share`; do
    if [ -f $x ] ; then
      install -p -m644 -D $x %{buildroot}/usr/$x;
    fi
  done

  cp -R lib64 %{buildroot}/usr/
  chmod -R 755 %{buildroot}/usr/lib64/*

#  for x in `find lib64`; do
#    if [ -f $x ] ; then
#      install -p -m755 -D $x %{buildroot}/usr/$x;
#    fi
#  done

  cp -R bin %{buildroot}/usr/
  chmod -R 755 %{buildroot}/usr/bin/*
#  for x in `find bin`; do
#    if [ -f $x ] ; then
#      install -p -m755 -D $x %{buildroot}/usr/$x;
#    fi
#  done

  if [ -f ./etc/profile.d/ossim.sh ] ; then
    install -p -m644 -D ./etc/profile.d/ossim.sh %{buildroot}%{_sysconfdir}/profile.d/ossim.sh
  fi

  if [ -f ./etc/profile.d/ossim.csh ] ; then
    install -p -m644 -D ./etc/profile.d/ossim.csh %{buildroot}%{_sysconfdir}/profile.d/ossim.csh
  fi
%if %{is_systemd}
  for x in `find lib/systemd/system` ; do
    if [ -f $x ] ; then
      install -p -m755 -D $x %{buildroot}/usr/$x;
    fi
  done
%else
  for x in `find etc/init.d` ; do
    if [ -f $x ] ; then
      install -p -m755 -D $x %{buildroot}/$x;
    fi
  done
%endif

popd
echo on

# Exports for java builds:
#export JAVA_HOME=/usr/lib/jvm/java
#export OSSIM_INSTALL_PREFIX=%{buildroot}/usr

# mrsid libraries:
# Need to replace /opt/mrsid/latest with variable later
#install -p -m755 -D /opt/mrsid/latest/Lidar_DSDK/lib/liblti_lidar_dsdk.so #%{buildroot}%{_libdir}
#install -p -m755 -D /opt/mrsid/latest/Raster_DSDK/lib/libltidsdk.so %{buildroot}%{_libdir}

# oms "ant" build:
#pushd ossim-oms/joms
#ant dist
#ant install
# Fix bad perms:
#chmod 755 %{buildroot}%{_libdir}/libjoms.so
#popd

%pre jpip-server
export USER_NAME=omar
export APP_NAME=jpip-server
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%preun jpip-server
export APP_NAME=jpip-server
ps -ef | grep $APP_NAME | grep -v grep
if [ $? -eq "0" ] ; then
%if %{is_systemd}
systemctl stop $APP_NAME
%else
service $APP_NAME stop
%endif
  if [ "$?" -eq "0" ]; then
     echo "Service $APP_NAME stopped successfully"
  else
     echo "Problems stopping $APP_NAME.  Ignoring..."
  fi
else
  echo "Service ${APP_NAME} is not running and will not be stopped."
fi

%post libs
/sbin/ldconfig

# First time through create the site preferences.
if [ ! -f %{_datadir}/ossim/ossim-site-preferences ]; then
   cp %{_datadir}/ossim/ossim-preferences-template %{_datadir}/ossim/ossim-site-preferences
fi

%post oms
/sbin/ldconfig
rm -f %{_javadir}/joms.jar
ln -s %{_javadir}/joms-%{version}.jar %{_javadir}/joms.jar

%post planet
/sbin/ldconfig

%post wms
/sbin/ldconfig

%postun
/sbin/ldconfig

%postun oms
/sbin/ldconfig
rm -f %{_javadir}/joms.jar

%postun planet
/sbin/ldconfig

%postun wms
/sbin/ldconfig

%post jpip-server
export USER_NAME=omar
export APP_NAME=jpip-server

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/ossim/${APP_NAME}
if [ ! -d "/var/log/${APP_NAME}" ] ; then
  mkdir /var/log/${APP_NAME}
fi
if [ ! -d "/var/run/${APP_NAME}" ] ; then
  mkdir /var/run/${APP_NAME}
fi

chown -R ${USER_NAME}:${USER_NAME}  /var/log/${APP_NAME}
chmod 755 /var/log/${APP_NAME}
chown -R ${USER_NAME}:${USER_NAME}  /var/run/${APP_NAME}
chmod 755 /var/run/${APP_NAME}

%postun jpip-server
export APP_NAME=jpip-server
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/ossim/${APP_NAME}

%files
%{_bindir}/*

# Weed out apps:
%exclude %{_bindir}/ossim-*-test

%exclude %{_bindir}/ossim-adrg-dump
%exclude %{_bindir}/ossim-btoa
%exclude %{_bindir}/ossim-computeSrtmStats
%exclude %{_bindir}/ossim-correl 
%exclude %{_bindir}/ossim-create-bitmask
%exclude %{_bindir}/ossim-dump-ocg
%exclude %{_bindir}/ossim-image-compare
%exclude %{_bindir}/ossim-modopt
%exclude %{_bindir}/ossimplanetklv
%exclude %{_bindir}/ossimplanet-chip
%exclude %{_bindir}/ossimplanettest
%exclude %{_bindir}/ossim-rejout
%exclude %{_bindir}/ossim-rpf 
%exclude %{_bindir}/ossim-senint
%exclude %{_bindir}/ossim-space-imaging
%exclude %{_bindir}/ossim-src2src
%exclude %{_bindir}/ossim-swapbytes
%exclude %{_bindir}/ossim-ws-cmp

# These are in the geocell package:
%exclude %{_bindir}/ossim-geocell
%exclude %{_bindir}/ossimplanetviewer

# In jpip-server package:
%exclude %{_bindir}/ossim-jpip-server

# ossimGui includes remove
%exclude %{_includedir}/ossimGui
%exclude %{_includedir}/ossimGui/*

%files devel
%{_includedir}/ossim

%files libs
%{_datadir}/ossim/
#%doc ossim/LICENSE.txt
%{_libdir}/libossim.so*
%{_libdir}/pkgconfig/ossim.pc
%{_sysconfdir}/profile.d/ossim.sh
%{_sysconfdir}/profile.d/ossim.csh

%files geocell
%{_bindir}/ossim-geocell
%{_libdir}/libossimGui.so*

%files oms
%{_javadir}/joms-%{version}.jar
%{_libdir}/libjoms.so
%{_libdir}/liboms.so*

%files oms-devel
%{_includedir}/oms/

%files planet
# %{_bindir}/ossimplanet
%{_bindir}/ossimplanetviewer
%{_libdir}/libossim-planet.so*
# %{_libdir}/libossimPlanetQt.so*

%files planet-devel
%{_includedir}/ossimPlanet

%files test-apps
%{_bindir}/ossim-*-test

%files video
%{_libdir}/libossim-video.so*

%files video-devel
%{_includedir}/ossimPredator

%files wms
%{_includedir}/wms/
%{_libdir}/libossim-wms.so*

#---
# ossim plugins
#---
%files cnes-plugin
%{_libdir}/ossim/plugins/libossim_cnes_plugin.so

%files gdal-plugin
%{_libdir}/ossim/plugins/libossim_gdal_plugin.so

%files geopdf-plugin
%{_libdir}/ossim/plugins/libossim_geopdf_plugin.so

%files jpeg12-plugin
%{_libdir}/ossim/plugins/libossim_jpeg12_plugin.so

#%files hdf5-plugin
#%{_libdir}/ossim/plugins/libossim_hdf5_plugin.so

%files jpip-server
%{_bindir}/ossim-jpip-server
%if %{is_systemd}
/usr/lib/systemd/system/jpip-server.service
%else
%{_sysconfdir}/init.d/jpip-server
%endif

%files kml-plugin
%{_libdir}/ossim/plugins/libossim_kml_plugin.so

%files kakadu-plugin
%{_libdir}/ossim/plugins/libossim_kakadu_plugin.so
%{_libdir}/libkdu_*.so

#%files mrsid-plugin
#%{_libdir}/ossim/plugins/libossim_mrsid_plugin.so
#%{_libdir}/liblti_lidar_dsdk.so
#%{_libdir}/libltidsdk.so

%files opencv-plugin
%{_libdir}/ossim/plugins/libossim_opencv_plugin.so

%files openjpeg-plugin
%{_libdir}/ossim/plugins/libossim_openjpeg_plugin.so

%files png-plugin
%{_libdir}/ossim/plugins/libossim_png_plugin.so

%files sqlite-plugin
%{_libdir}/ossim/plugins/libossim_sqlite_plugin.so

%files web-plugin
%{_libdir}/ossim/plugins/libossim_web_plugin.so

%files potrace-plugin
%{_libdir}/ossim/plugins/libossim_potrace_plugin.so


%changelog
