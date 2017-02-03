Name:    dm-fmt
Version: %{_version}
Release: %{_release}%{?dist}
%define dm_group_prefix /opt/dm_group/usr

Summary: DM Group FlatBuffers package
License: BSD
URL:     http://fmtlib.net/latest/index.html
Source:	 dm-fmt-%{version}.tar.gz

BuildRequires: gcc gcc-c++

%description
Data Management Group fmt package

fmt (formerly cppformat) is an open-source formatting library. It can be used
as a safe alternative to printf or as a fast alternative to C++ IOStreams.


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
install -d %{buildroot}%{dm_group_prefix}/share/doc/fmt
cp LICENSE.rst %{buildroot}%{dm_group_prefix}/share/doc/fmt/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,root,root)
%{dm_group_prefix}/include/fmt
%{dm_group_prefix}/lib/cmake/fmt
%{dm_group_prefix}/lib/libfmt.a
%doc %{dm_group_prefix}/share/doc/fmt/


%changelog

* Fri Feb 3 2017 Afonso Mukai <afonso.mukai@esss.se> 3.0.1
- Initial package
