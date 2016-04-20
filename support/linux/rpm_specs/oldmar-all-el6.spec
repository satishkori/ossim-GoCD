Name:          omar
Version:        %{RPM_OSSIM_VERSION} 
Release:        %{BUILD_RELEASE}%{?dist}
Summary:        OSSIM Server
Group:          System Environment/Libraries
#TODO: Which version?
License:        LGPLv2+
#URL:            http://github


Requires: ossim
Requires: ossim-oms

%description
OMAR

%package -n     omar-server
Summary:        Wrapper library/java bindings for interfacing with ossim.
Group:          System Environment/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description -n omar-server
OMAR Image server


%build

%install

pushd %{_builddir}/install
  for x in `find share`; do
    if [ -f $x ] ; then
      install -p -m644 -D $x %{buildroot}/usr/$x;
    fi
  done
popd

%post
pushd %{_datadir}/omar
if [ -L omar.war ]; then
  unlink omar.war
fi
if [ ! -f omar.war ]; then
  ln -s omar-${version}.war omar.war
fi
popd

%files
%{_datadir}/*
