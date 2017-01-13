Name:    dm-librdkafka
Version: %{_version}
Release: %{_release}%{?dist}
%define soname 1
%define dm_group_prefix /opt/dm_group/usr

Summary: DM Group librdkafka package
License: BSD-2-Clause
URL:     https://github.com/edenhill/librdkafka
Source:	 dm-librdkafka-%{version}.tar.gz

BuildRequires: zlib-devel libstdc++-devel gcc >= 4.1 gcc-c++ openssl-devel cyrus-sasl-devel python

Requires: zlib libstdc++ cyrus-sasl
# openssl libraries were extract to openssl-libs in RHEL7
%if 0%{?rhel} >= 7
Requires: openssl-libs
%else
Requires: openssl
%endif

%description
Data Management Group librdkafka package

librdkafka is the C/C++ client library implementation of the Apache Kafka
protocol, containing both Producer and Consumer support.


%package -n %{name}-devel
Summary: DM Group librdkafka package (Development Environment)
Requires: %{name} = %{version}

%description -n %{name}-devel
Data Management Group librdkafka development environment package

librdkafka is the C/C++ client library implementation of the Apache Kafka
protocol, containing both Producer and Consumer support.

This package contains headers and libraries required to build applications
using librdkafka.


%prep
%setup -q -n %{name}-%{version}

./configure --prefix=%{dm_group_prefix}

%build
make

%install
rm -rf %{buildroot}
DESTDIR=%{buildroot} make install
install -d %{buildroot}%{dm_group_prefix}/share/librdkafka
cp README.md CONFIGURATION.md INTRODUCTION.md LICENSE LICENSE.pycrc \
    LICENSE.queue LICENSE.snappy LICENSE.tinycthread LICENSE.wingetopt \
    CHANGES %{buildroot}%{dm_group_prefix}/share/librdkafka/

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(444,root,root)
%{dm_group_prefix}/lib/librdkafka.so.%{soname}
%{dm_group_prefix}/lib/librdkafka++.so.%{soname}
%defattr(-,root,root)
%doc %{dm_group_prefix}/share/librdkafka


%files -n %{name}-devel
%defattr(-,root,root)
%{dm_group_prefix}/include/librdkafka
%defattr(444,root,root)
%{dm_group_prefix}/lib/librdkafka.a
%{dm_group_prefix}/lib/librdkafka.so
%{dm_group_prefix}/lib/librdkafka++.a
%{dm_group_prefix}/lib/librdkafka++.so
%{dm_group_prefix}/lib/pkgconfig/rdkafka++.pc
%{dm_group_prefix}/lib/pkgconfig/rdkafka.pc


%changelog

* Fri Jan 13 2017 Afonso Mukai <afonso.mukai@esss.se> 0.9.2
- Change installation prefix to /opt/dm_group/usr

* Fri Dec 16 2016 Afonso Mukai <afonso.mukai@esss.se> 0.9.1
- Initial package with dm prefix
