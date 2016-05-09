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
export APP_NAME=omar-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd


%post wfs-app
export APP_NAME=wfs-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd


%post wms-app
echo "POST INSTALLATION SETUP WMS-APP"
export APP_NAME=wms-app
export USER_NAME=omar

echo "Checking if user:group omar:omar exists"
if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

echo "Linking the jar"
pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

echo "CREATING THE SERVICE WRAPPERS"
if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

echo "SETTING PERMISSIONS"
if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post stager-app
export APP_NAME=stager-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post swipe-app
export APP_NAME=swipe-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post superoverlay-app
export APP_NAME=superoverlay-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post jpip-app
export APP_NAME=jpip-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd
else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
fi

popd

%post wmts-app
export APP_NAME=wmts-app
export USER_NAME=omar

if ! id -u omar > /dev/null 2>&1; then 
  adduser --no-create-home -s /usr/sbin/nologin --user-group ${USER_NAME}
fi

pushd %{_datadir}/omar/${APP_NAME}
if [ -L ${APP_NAME}.jar ]; then
 unlink ${APP_NAME}.jar
fi
if [ ! -f ${APP_NAME}.jar ]; then
  ln -s ${APP_NAME}-*.jar ${APP_NAME}.jar
fi

if [ -d /etc/systemd ] ; then
  install -p -m755 ./service-templates/${APP_NAME}.service /usr/lib/systemd/system/${APP_NAME}.service
  pushd /etc/systemd/system
    ln -s  /usr/lib/systemd/system/${APP_NAME}.service
  popd

else
  install -p -m755 ./service-templates/${APP_NAME} /etc/init.d/${APP_NAME}
fi

if id -u ${USER_NAME} > /dev/null 2>&1; then 
  chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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
