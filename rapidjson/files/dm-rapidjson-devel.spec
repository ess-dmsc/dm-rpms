Name:    dm-rapidjson-devel
Version: %{_version}
Release: %{_release}%{?dist}
%define dm_group_prefix /opt/dm_group/usr

Summary: DM Group rapidjson package
License: RapidJSON
URL:     https://github.com/miloyip/rapidjson
Source:	 dm-rapidjson-devel-%{version}.tar.gz

BuildRequires: cmake gcc-c++ doxygen

Requires: libstdc++

%description
Data Management Group RapidJSON package

RapidJSON is a small, self-contained header-only C++ JSON library.


%prep
%setup -q -n %{name}-%{version}

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=%{dm_group_prefix} ..

%build
pwd
ls -la
make -C build

%install
rm -rf %{buildroot}
DESTDIR=%{buildroot} make -C build install
cp license.txt %{buildroot}%{dm_group_prefix}/share/doc/RapidJSON/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,root,root)
%{dm_group_prefix}/include/rapidjson
%{dm_group_prefix}/lib/cmake/RapidJSON
%{dm_group_prefix}/lib/pkgconfig/RapidJSON.pc
%doc %{dm_group_prefix}/share/doc/RapidJSON


%changelog

* Fri Feb 3 2017 Afonso Mukai <afonso.mukai@esss.se> 1.1.0
- Initial package
