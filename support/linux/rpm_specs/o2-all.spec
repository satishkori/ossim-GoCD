Name:          o2
Version:        %{O2_VERSION}
Release:        %{O2_BUILD_RELEASE}%{?dist}
Summary:        New OMAR/O2 Services
Group:          System Environment/Libraries
License:        MIT License
#URL:            http://github

# this is to stop it from compressing the jar files so we do not get nested zips because the
# jars are already zipped
%define __os_install_post %{nil}

%description
O2 Packages

%package    omar-app
Summary:        OMAR/O2 UI application.
Version:        %{O2_VERSION}
Group:          System Environment/Libraries
Requires: ossim-oms


%package    wfs-app
Summary:        OMAR/O2 WFS Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    wms-app
Summary:        OMAR/O2 WMS Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries
Requires: ossim-oms

%package    stager-app
Summary:        Stager service for the O2 raster database Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries
Requires: ossim-oms

%package    superoverlay-app
Summary:        KML Superoverlay service for the O2 raster database Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

#%package   ossimtools-app
#Summary:        OSSIM tools service Services
#Version:        %{O2_VERSION}
#Group:          System Environment/Libraries
#Requires: ossim-oms

%package    swipe-app
Summary:        Swipe Services
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    jpip-app
Summary:        JPIP Services
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    wmts-app
Summary:        WMTS Services
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%description  omar-app
OMAR/O2 UI


%description  wms-app
WMS Micro service

%description  wfs-app
WFS Micro Service

%description  stager-app
Stager service for the O2 distribution.  Will support indexing imagery into the shared database

%description  superoverlay-app
Stager service for the O2 distribution.  Will support Google Earth's KML superoverlay

#%description  ossimtools-app
#OSSIM Tools

%description  swipe-app
Swipe application

%description  jpip-app
JPIP application

%description  wmts-app
WMTS application


%build

%install

pushd %{_builddir}/install
  for x in `find share`; do
    if [ -f $x ] ; then
      install -p -m644 -D $x %{buildroot}/usr/$x;
    fi
  done
popd

%post omar-app
pushd %{_datadir}/omar/omar-app
if [ -L omar-app.jar ]; then
 unlink omar-app.jar
fi
if [ ! -f omar-app.jar ]; then
  ln -s omar-app-*.jar omar-app.jar
fi
popd

%post wfs-app
pushd %{_datadir}/omar/wfs-app
if [ -L wfs-app.jar ]; then
 unlink wfs-app.jar
fi
if [ ! -f wfs-app.jar ]; then
  ln -s wfs-app-*.jar wfs-app.jar
fi
popd

%post wms-app
pushd %{_datadir}/omar/wms-app
if [ -L wms-app.jar ]; then
 unlink wms-app.jar
fi
if [ ! -f wms-app.jar ]; then
  ln -s wms-app-*.jar wms-app.jar
fi
popd

%post stager-app
pushd %{_datadir}/omar/stager-app
if [ -L stager-app.jar ]; then
 unlink stager-app.jar
fi
if [ ! -f stager-app.jar ]; then
  ln -s stager-app-*.jar stager-app.jar
fi
popd

%post swipe-app
pushd %{_datadir}/omar/swipe-app
if [ -L swipe-app.jar ]; then
 unlink swipe-app.jar
fi
if [ ! -f swipe-app.jar ]; then
  ln -s swipe-app-*.jar swipe-app.jar
fi
popd

%post superoverlay-app
pushd %{_datadir}/omar/superoverlay-app
if [ -L superoverlay-app.jar ]; then
 unlink superoverlay-app.jar
fi
if [ ! -f superoverlay-app.jar ]; then
  ln -s superoverlay-app-*.jar superoverlay-app.jar
fi
popd

%post jpip-app
pushd %{_datadir}/omar/jpip-app
if [ -L jpip-app.jar ]; then
 unlink jpip-app.jar
fi
if [ ! -f jpip-app.jar ]; then
  ln -s jpip-app-*.jar jpip-app.jar
fi
popd

%post wmts-app
pushd %{_datadir}/omar/wmts-app
if [ -L wmts-app.jar ]; then
 unlink wmts-app.jar
fi
if [ ! -f wmts-app.jar ]; then
  ln -s wmts-app-*.jar wmts-app.jar
fi
popd


%files omar-app
%{_datadir}/omar/omar-app

%files wfs-app
%{_datadir}/omar/wfs-app

%files wms-app
%{_datadir}/omar/wms-app

%files stager-app
%{_datadir}/omar/stager-app

%files swipe-app
%{_datadir}/omar/swipe-app

%files superoverlay-app
%{_datadir}/omar/superoverlay-app

%files jpip-app
%{_datadir}/omar/jpip-app

%files wmts-app
%{_datadir}/omar/wmts-app
