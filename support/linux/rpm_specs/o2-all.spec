Name:          o2
Version:        %{O2_VERSION}
Release:        %{O2_BUILD_RELEASE}%{?dist}
Summary:        New OMAR/O2 Services
Group:          System Environment/Libraries
License:        MIT License
#URL:            http://github

%define is_systemd %(test -d /etc/systemd && echo 1 || echo 0)

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

%if %{is_systemd}
  for x in `find usr/lib/systemd/system` ; do
    if [-f $x ] ; then
      install -p -m755 -D $x %{buildroot}/$x;
    fi
  done
%else
  for x in `find etc/init.d` ; do
    if [-f $x ] ; then
      install -p -m755 -D $x %{buildroot}/$x;
    fi
  done
%endif

popd



%pre omar-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre wfs-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre wms-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre stager-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre swipe-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre superoverlay-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre jpip-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%pre wmts-app

export USER_NAME=omar
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

%post omar-app
export APP_NAME=omar-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar

popd


%post wfs-app
export APP_NAME=wfs-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd


%post wms-app
export APP_NAME=wms-app
export USER_NAME=omar

echo "POST INSTALLATION SETUP ${APP_NAME}"

echo "Linking the jar"
pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post stager-app
export APP_NAME=stager-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post swipe-app
export APP_NAME=swipe-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post superoverlay-app
export APP_NAME=superoverlay-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post jpip-app
export APP_NAME=jpip-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post wmts-app
export APP_NAME=wmts-app
export USER_NAME=omar

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd


%files omar-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/omar-app
%attr(755, omar, omar, -) %{_datadir}/omar/jpip-app/omar-app.sh

%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/omar-app
%else
%attr(755, omar, omar, -) /etc/init.d/omar-app
%endif

%files wfs-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/wfs-app
%attr(755, omar, omar, -) %{_datadir}/omar/wfs-app/wfs-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/wfs-app
%else
%attr(755, omar, omar, -) /etc/init.d/wfs-app
%endif

%files wms-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/wms-app
%attr(755, omar, omar, -) %{_datadir}/omar/wms-app/wms-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/wms-app
%else
%attr(755, omar, omar, -) /etc/init.d/wms-app
%endif

%files stager-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/stager-app
%attr(755, omar, omar, -) %{_datadir}/omar/stager-app/stager-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/stager-app
%else
%attr(755, omar, omar, -) /etc/init.d/stager-app
%endif

%files swipe-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/swipe-app
%attr(755, omar, omar, -) %{_datadir}/omar/swipe-app/swipe-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/swipe-app
%else
%attr(755, omar, omar, -) /etc/init.d/swipe-app
%endif

%files superoverlay-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/superoverlay-app
%attr(755, omar, omar, -) %{_datadir}/omar/superoveraly-app/superoverlay-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/superoverlay-app
%else
%attr(755, omar, omar, -) /etc/init.d/superoverlay-app
%endif

%files jpip-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/jpip-app
%attr(755, omar, omar, -) %{_datadir}/omar/jpip-app/jpip-app.sh

%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/jpip-app
%else
%attr(755, omar, omar, -) /etc/init.d/jpip-app
%endif

%files wmts-app
%defattr(644, omar, omar, -)
%attr(755, omar, omar, -) %{_datadir}/omar
%attr(755, omar, omar, -) %{_datadir}/omar/wmts-app
%attr(755, omar, omar, -) %{_datadir}/omar/wmts-app/wmts-app.sh
%if %{is_systemd}
%attr(755, omar, omar, -) /usr/lib/systemd/system/wmts-app
%else
%attr(755, omar, omar, -) /etc/init.d/wmts-app
%endif
