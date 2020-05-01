Name:    dm-cmak
Version: %{_version}
Release: %{_release}%{?dist}

Summary: DM Group CMAK package
License: ASL 2.0
URL:     https://github.com/yahoo/CMAK
Source:	 dm-cmak-%{version}.tar.gz

BuildArch: noarch

%description
Data Management Group CMAK (Cluster Manager for Apache Kafka, previously known as Kafka Manager) package.


%prep
%setup -q

%install
rm -rf %{buildroot}
install -d %{buildroot}/opt/dm_group/cmak
install -d %{buildroot}/etc/systemd/system
install -d %{buildroot}/var/opt/dm_group/cmak
cp -r cmak %{buildroot}/opt/dm_group/
cp files/dm-cmak.service %{buildroot}/etc/systemd/system/

%pre
id -u cmak &>/dev/null || \
    useradd cmak --shell /usr/bin/false --no-create-home

%post
systemctl daemon-reload

%preun
systemctl stop dm-cmak

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,cmak,cmak)
/opt/dm_group/cmak/bin
/opt/dm_group/cmak/lib
/var/opt/dm_group/cmak
%attr(755,cmak,cmak) /opt/dm_group/cmak/start-cmak-service.sh
%attr(644,root,root) /etc/systemd/system/dm-cmak.service
%config /opt/dm_group/cmak/conf
%doc /opt/dm_group/cmak/README.md
%doc /opt/dm_group/cmak/share


%changelog

* Tue Apr 28 2020 Afonso Mukai <afonso.mukai@esss.se> - 3.0.0.4
- Update to version 3.0.0.4

* Wed Dec 14 2016 Afonso Mukai <afonso.mukai@esss.se> - 1.3.1.8
- Initial package with dm prefix
