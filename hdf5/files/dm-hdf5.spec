Name:    dm-hdf5
Version: %{_version}
Release: %{_release}%{?dist}

Summary: DM Group HDF5 package
License: BSD-like
URL:     http://hdf5.apache.org
Source:	 dm-hdf5-%{version}.tar.gz

BuildArch: x86_64

%description
Data Management Group HDF5 package.


%package -n %{name}-devel
Summary: DM Group HDF5 development environment package
Requires: %{name} = %{version}

%description -n %{name}-devel
Data Management Group HDF5 development environment package.

This package contains headers and libraries required to build applications
using HDF5.


%prep
%setup -q

%install
rm -rf %{buildroot}
install -d %{buildroot}/opt/dm_group
cp -r hdf5 %{buildroot}/opt/dm_group/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,root,root)
/opt/dm_group/hdf5/bin
/opt/dm_group/hdf5/lib
%doc /opt/dm_group/hdf5/CHANGES
%doc /opt/dm_group/hdf5/COPYING
%doc /opt/dm_group/hdf5/README
%doc /opt/dm_group/hdf5/RELEASE.txt


%files -n %{name}-devel
%defattr(-,root,root)
/opt/dm_group/hdf5/include
%doc /opt/dm_group/hdf5/share


%changelog

* Thu Dec 15 2016 Afonso Mukai <afonso.mukai@esss.se> - 1.8.18
- Initial package with dm prefix
