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
install -d %{buildroot}/opt/dm_group/usr/bin
install -d %{buildroot}/opt/dm_group/usr/include
install -d %{buildroot}/opt/dm_group/usr/lib
install -d %{buildroot}/opt/dm_group/usr/share/hdf5
cp -r bin/* %{buildroot}/opt/dm_group/usr/bin/
cp -r include/* %{buildroot}/opt/dm_group/usr/include/
cp -r lib/* %{buildroot}/opt/dm_group/usr/lib/
cp -r share/* %{buildroot}/opt/dm_group/usr/share/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,root,root)
/opt/dm_group/usr/bin
/opt/dm_group/usr/lib
%doc /opt/dm_group/usr/share/hdf5/CHANGES
%doc /opt/dm_group/usr/share/hdf5/COPYING
%doc /opt/dm_group/usr/share/hdf5/README
%doc /opt/dm_group/usr/share/hdf5/RELEASE.txt


%files -n %{name}-devel
%defattr(-,root,root)
/opt/dm_group/usr/include
%doc /opt/dm_group/usr/share/hdf5_examples


%changelog

* Fri Jan 13 2017 Afonso Mukai <afonso.mukai@esss.se> 1.8.18
- Change installation prefix to /opt/dm_group/usr

* Wed Dec 21 2016 Afonso Mukai <afonso.mukai@esss.se> 1.8.18
- Add library path script to /etc/profile.d

* Thu Dec 15 2016 Afonso Mukai <afonso.mukai@esss.se> 1.8.18
- Initial package with dm prefix
