Name:          omar
Version:        %{RPM_OSSIM_VERSION} 
Release:        %{BUILD_RELEASE}%{?dist}
Summary:        OSSIM Server
Group:          System Environment/Libraries
#TODO: Which version?
License:        LGPLv2+
#URL:            http://github
Source0:        http://download.osgeo.org/ossim/source/%{name}-%{version}.tar.gz


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

install -p -m644 -D %{_builddir}/install/share/* %{buildroot}%{_datadir}/omar/omar.war

%files
%{_datadir}/*
