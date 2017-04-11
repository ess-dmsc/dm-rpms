Name:    dm-flatbuffers
Version: %{_version}
Release: %{_release}%{?dist}
%define dm_group_prefix /opt/dm_group/usr

Summary: DM Group FlatBuffers package
License: ASL 2.0
URL:     http://google.github.io/flatbuffers/
Source:	 dm-flatbuffers-%{version}.tar.gz

BuildRequires: cmake gcc gcc-c++

%description
Data Management Group FlatBuffers package

FlatBuffers is an efficient cross platform serialization library for C++, C#,
C, Go, Java, JavaScript, PHP, and Python. It was originally created at Google
for game development and other performance-critical applications.


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
install -d %{buildroot}%{dm_group_prefix}/share/doc/flatbuffers
cp LICENSE.txt %{buildroot}%{dm_group_prefix}/share/doc/flatbuffers/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,root,root)
%{dm_group_prefix}/bin/flatc
%{dm_group_prefix}/include/flatbuffers
%{dm_group_prefix}/lib/libflatbuffers.a
%doc %{dm_group_prefix}/share/doc/flatbuffers/


%changelog

* Tue Apr 11 2017 Afonso Mukai <afonso.mukai@esss.se> 1.5.0
- Remove requires

* Fri Feb 3 2017 Afonso Mukai <afonso.mukai@esss.se> 1.5.0
- Initial package
