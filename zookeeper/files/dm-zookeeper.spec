Name:    dm-zookeeper
Version: %{_version}
Release: %{_release}%{?dist}

Summary: DM Group Apache ZooKeeper package
License: ASL 2.0
URL:     http://zookeeper.apache.org
Source:	 dm-zookeeper-%{version}.tar.gz

BuildArch: noarch

%global _python_bytecompile_errors_terminate_build 0

%description
Data Management Group Apache ZooKeeper package.


%prep
%setup -q

%install
rm -rf %{buildroot}
install -d %{buildroot}/opt/dm_group/zookeeper
install -d %{buildroot}/etc/systemd/system
install -d %{buildroot}/var/opt/dm_group/zookeeper
cp -r zookeeper %{buildroot}/opt/dm_group/
cp files/dm-zookeeper.service %{buildroot}/etc/systemd/system/

%post
id -u zookeeper &>/dev/null || \
    useradd zookeeper --shell /usr/bin/false --no-create-home
systemctl daemon-reload

%preun
systemctl stop dm-zookeeper

%clean
rm -rf %{buildroot}

%files -n %{name}
%defattr(-,zookeeper,zookeeper)
/opt/dm_group/zookeeper/bin
/opt/dm_group/zookeeper/lib
/opt/dm_group/zookeeper/zookeeper-*.jar
%attr(755,zookeeper,zookeeper) /opt/dm_group/zookeeper/start-zookeeper-service.sh
%attr(644,root,root) /etc/systemd/system/dm-zookeeper.service
%config /opt/dm_group/zookeeper/conf
%doc /opt/dm_group/zookeeper/*.txt
%doc /opt/dm_group/zookeeper/docs


%changelog

* Wed Dec 14 2016 Afonso Mukai <afonso.mukai@esss.se> - 3.4.9
- Initial package with dm prefix
