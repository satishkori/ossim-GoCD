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

%package    sqs-app
Summary:        OMAR/O2 SQS application.
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    avro-app
Summary:        OMAR/O2 SQS application.
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    download-app
Summary:        OMAR/O2 download application.
Version:        %{O2_VERSION}
Group:          System Environment/Libraries


%package    wfs-app
Summary:        OMAR/O2 WFS Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%package    wms-app
Summary:        OMAR/O2 WMS Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries
Requires: ossim-oms

%package    mensa-app
Summary:        OMAR/O2 Mensuration Service
Version:        %{O2_VERSION}
Group:          System Environment/Libraries
Requires: ossim-oms

%package    wcs-app
Summary:        OMAR/O2 WCS Service
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
Requires: ossim-oms

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
Requires: ossim-oms

%package    wmts-app
Summary:        WMTS Services
Version:        %{O2_VERSION}
Group:          System Environment/Libraries

%description  omar-app
OMAR/O2 UI

%description  sqs-app
OMAR/O2 SQS service

%description  avro-app
OMAR/O2 AVRO service.  At the momonet it only parses the payload of an AVRO file.  So one record at a time can be sent to this app

%description  download-app
Allows one to download files

%description  wms-app
WMS Micro service

%description  mensa-app
Mensuration Micro service

%description  wcs-app
WCS Micro service

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
export O2_APPS=( "omar-app" "sqs-app" "avro-app" "download-app" "wfs-app" "wms-app" "mensa-app" "wcs-app" "stager-app" "swipe-app" "superoverlay-app" "jpip-app wmts-app" )

pushd %{_builddir}/install
  # Install all files with default permissions
  for x in `find share`; do
    if [ -f $x ] ; then
      install -p -m644 -D $x %{buildroot}/usr/$x;
    fi
  done
  # Loop through each app and sym link to the versioned app
  for app in ${O2_APPS[@]} ; do 
    if [ -d %{buildroot}%{_datadir}/omar/${app} ]; then
      pushd %{buildroot}%{_datadir}/omar/${app}
        if [ -L ${app}.jar ]; then
         unlink ${app}.jar
        fi
        if [ ! -f ${app}.jar ]; then
          ln -s ${app}-*.jar ${app}.jar
        fi
        chmod 755 *.sh
      popd
    fi  
  done
  chmod 755 `find %{buildroot}%{_datadir}/omar -type d`

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

%pre omar-app
export USER_NAME=omar
export APP_NAME=omar-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre sqs-app
export USER_NAME=omar
export APP_NAME=sqs-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -s /bin/false -m --user-group ${USER_NAME}
fi

%pre avro-app
export USER_NAME=omar
export APP_NAME=avro-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -s /bin/false -m --user-group ${USER_NAME}
fi

%pre download-app
export USER_NAME=omar
export APP_NAME=download-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -s /bin/false -m --user-group ${USER_NAME}
fi

%pre wfs-app
export USER_NAME=omar
export APP_NAME=wfs-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre wms-app
export USER_NAME=omar
export APP_NAME=wms-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre mensa-app
export USER_NAME=omar
export APP_NAME=mensa-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre wcs-app
export USER_NAME=omar
export APP_NAME=wcs-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi


%pre stager-app
export USER_NAME=omar
export APP_NAME=stager-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre swipe-app
export USER_NAME=omar
export APP_NAME=swipe-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre superoverlay-app
export USER_NAME=omar
export APP_NAME=superoverlay-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre jpip-app
export USER_NAME=omar
export APP_NAME=jpip-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%pre wmts-app
export USER_NAME=omar
export APP_NAME=wmts-app
if ! id -u omar > /dev/null 2>&1; then 
  adduser -r -d /usr/share/omar -s /bin/false --no-create-home --user-group ${USER_NAME}
fi

%post omar-app
export USER_NAME=omar
export APP_NAME=omar-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post sqs-app
export USER_NAME=omar
export APP_NAME=sqs-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post avro-app
export USER_NAME=omar
export APP_NAME=avro-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post download-app
export USER_NAME=omar
export APP_NAME=download-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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


%post wfs-app
export USER_NAME=omar
export APP_NAME=wfs-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post wms-app
export USER_NAME=omar
export APP_NAME=wms-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post mensa-app
export USER_NAME=omar
export APP_NAME=mensa-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post wcs-app
export USER_NAME=omar
export APP_NAME=wcs-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post stager-app
export USER_NAME=omar
export APP_NAME=stager-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post swipe-app
export USER_NAME=omar
export APP_NAME=swipe-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post superoverlay-app
export USER_NAME=omar
export APP_NAME=superoverlay-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post jpip-app
export USER_NAME=omar
export APP_NAME=jpip-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%post wmts-app
export USER_NAME=omar
export APP_NAME=wmts-app

chown -R ${USER_NAME}:${USER_NAME} %{_datadir}/omar
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

%preun omar-app
export APP_NAME=omar-app
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

%preun sqs-app
export APP_NAME=sqs-app
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

%preun avro-app
export APP_NAME=avro-app
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

%preun download-app
export APP_NAME=download-app
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


%preun wfs-app
export APP_NAME=wfs-app
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

%preun wms-app
export APP_NAME=wms-app
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

%preun mensa-app
export APP_NAME=mensa-app
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

%preun wcs-app
export APP_NAME=wcs-app
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

%preun stager-app
export APP_NAME=stager-app
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

%preun swipe-app
export APP_NAME=swipe-app
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

%preun superoverlay-app
export APP_NAME=superoverlay-app
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

%preun jpip-app
export APP_NAME=jpip-app
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

%preun wmts-app
export APP_NAME=wmts-app
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

%postun omar-app
export APP_NAME=omar-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun sqs-app
export APP_NAME=sqs-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun avro-app
export APP_NAME=avro-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun download-app
export APP_NAME=download-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun wfs-app
export APP_NAME=wfs-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun wms-app
export APP_NAME=wms-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun mensa-app
export APP_NAME=mensa-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun wcs-app
export APP_NAME=wcs-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun stager-app
export APP_NAME=stager-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun swipe-app
export APP_NAME=swipe-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun superoverlay-app
export APP_NAME=superoverlay-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}


%postun jpip-app
export APP_NAME=jpip-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%postun wmts-app
export APP_NAME=wmts-app
rm -rf /var/log/${APP_NAME}
rm -rf /var/run/${APP_NAME}
rm -rf /usr/share/omar/${APP_NAME}

%files omar-app
%{_datadir}/omar/omar-app
%if %{is_systemd}
/usr/lib/systemd/system/omar-app.service
%else
%{_sysconfdir}/init.d/omar-app
%endif

%files sqs-app
%{_datadir}/omar/sqs-app
%if %{is_systemd}
/usr/lib/systemd/system/sqs-app.service
%else
%{_sysconfdir}/init.d/sqs-app
%endif

%files avro-app
%{_datadir}/omar/avro-app
%if %{is_systemd}
/usr/lib/systemd/system/avro-app.service
%else
%{_sysconfdir}/init.d/avro-app
%endif

%files download-app
%{_datadir}/omar/download-app
%if %{is_systemd}
/usr/lib/systemd/system/download-app.service
%else
%{_sysconfdir}/init.d/download-app
%endif


%files wfs-app
%{_datadir}/omar/wfs-app
%if %{is_systemd}
/usr/lib/systemd/system/wfs-app.service
%else
%{_sysconfdir}/init.d/wfs-app
%endif

%files wms-app
%{_datadir}/omar/wms-app
%if %{is_systemd}
/usr/lib/systemd/system/wms-app.service
%else
%{_sysconfdir}/init.d/wms-app
%endif

%files mensa-app
%{_datadir}/omar/mensa-app
%if %{is_systemd}
/usr/lib/systemd/system/mensa-app.service
%else
%{_sysconfdir}/init.d/mensa-app
%endif

%files wcs-app
%{_datadir}/omar/wcs-app
%if %{is_systemd}
/usr/lib/systemd/system/wcs-app.service
%else
%{_sysconfdir}/init.d/wcs-app
%endif


%files stager-app
%{_datadir}/omar/stager-app
%if %{is_systemd}
/usr/lib/systemd/system/stager-app.service
%else
%{_sysconfdir}/init.d/stager-app
%endif

%files swipe-app
%{_datadir}/omar/swipe-app
%if %{is_systemd}
/usr/lib/systemd/system/swipe-app.service
%else
%{_sysconfdir}/init.d/swipe-app
%endif

%files superoverlay-app
%{_datadir}/omar/superoverlay-app
%if %{is_systemd}
/usr/lib/systemd/system/superoverlay-app.service
%else
%{_sysconfdir}/init.d/superoverlay-app
%endif

%files jpip-app
%{_datadir}/omar/jpip-app
%if %{is_systemd}
/usr/lib/systemd/system/jpip-app.service
%else
%{_sysconfdir}/init.d/jpip-app
%endif

%files wmts-app
%{_datadir}/omar/wmts-app
%if %{is_systemd}
/usr/lib/systemd/system/wmts-app.service
%else
%{_sysconfdir}/init.d/wmts-app
%endif
