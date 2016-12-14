Name:    dm-kafka-manager
Version: %{_version}
Release: %{_release}%{?dist}

Summary: DM Group Kafka Manager package
License: ASL 2.0
URL:     https://github.com/yahoo/kafka-manager
Source:	 dm-kafka-manager-%{version}.tar.gz

BuildArch: noarch

%description
Data Management Group Kafka Manager package.


%prep
%setup -q

%install
rm -rf %{buildroot}
install -d %{buildroot}/opt/dm_group/kafka-manager
install -d %{buildroot}/etc/systemd/system
install -d %{buildroot}/var/opt/dm_group/kafka-manager
cp -r kafka-manager %{buildroot}/opt/dm_group/
cp files/dm-kafka-manager.service %{buildroot}/etc/systemd/system/

%pre
id -u kafka-manager &>/dev/null || \
    useradd kafka-manager --shell /usr/bin/false --no-create-home

%post
systemctl daemon-reload

%preun
systemctl stop dm-kafka-manager

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,kafka-manager,kafka-manager)
/opt/dm_group/kafka-manager/bin
/opt/dm_group/kafka-manager/lib
/var/opt/dm_group/kafka-manager
%attr(755,kafka-manager,kafka-manager) /opt/dm_group/kafka-manager/start-kafka-manager-service.sh
%attr(644,root,root) /etc/systemd/system/dm-kafka-manager.service
%config /opt/dm_group/kafka-manager/conf
%doc /opt/dm_group/kafka-manager/README.md
%doc /opt/dm_group/kafka-manager/share


%changelog

* Wed Dec 14 2016 Afonso Mukai <afonso.mukai@esss.se> - 1.3.1.8
- Initial package with dm prefix
