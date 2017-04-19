Name:    dm-kafka
Version: %{_version}
Release: %{_release}%{?dist}

Summary: DM Group Apache Kafka package
License: ASL 2.0
URL:     http://kafka.apache.org
Source:	 dm-kafka-%{version}.tar.gz

BuildArch: noarch

%description
Data Management Group Apache Kafka package.


%prep
%setup -q

%install
rm -rf %{buildroot}
install -d %{buildroot}/opt/dm_group/kafka
install -d %{buildroot}/etc/opt/dm_group/kafka
install -d %{buildroot}/etc/systemd/system
install -d %{buildroot}/var/opt/dm_group/kafka
install -d %{buildroot}/var/log/dm_group/kafka
cp -r kafka %{buildroot}/opt/dm_group/
cp files/server.properties %{buildroot}/etc/opt/dm_group/kafka/
cp files/dm-kafka.service %{buildroot}/etc/systemd/system/

%pre
id -u kafka &>/dev/null || \
    useradd kafka --shell /usr/bin/false --no-create-home

%post
systemctl daemon-reload

%preun
systemctl stop dm-kafka

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,kafka,kafka)
/opt/dm_group/kafka/bin
/opt/dm_group/kafka/libs
/var/opt/dm_group/kafka
/var/log/dm_group/kafka
%attr(755,kafka,kafka) /opt/dm_group/kafka/start-kafka-service.sh
%attr(644,root,root) /etc/systemd/system/dm-kafka.service
%config(noreplace) /etc/opt/dm_group/kafka/server.properties
%config /opt/dm_group/kafka/config
%doc /opt/dm_group/kafka/LICENSE
%doc /opt/dm_group/kafka/NOTICE
%doc /opt/dm_group/kafka/site-docs


%changelog

* Wed Apr 19 2017 Afonso Mukai <afonso.mukai@esss.se> - 0.10.2.0
- Add server.properties to /etc/opt/dm_group/kafka

* Wed Dec 14 2016 Afonso Mukai <afonso.mukai@esss.se> - 0.10.0.1
- Initial package with dm prefix
