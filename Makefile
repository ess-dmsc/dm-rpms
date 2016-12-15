include */CONFIG

.PHONY: all hdf5 kafka librdkafka zookeeper kafka-manager clean mostlyclean

all: hdf5 kafka librdkafka zookeeper kafka-manager


hdf5: rpms/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm: hdf5/CONFIG hdf5/package_hdf5.sh hdf5/files/* | rpms/x86_64
	cd hdf5; ./package_hdf5.sh
	mv hdf5/package/RPMS/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


kafka: rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm: kafka/CONFIG kafka/package_kafka.sh kafka/files/* | rpms/noarch
	cd kafka; ./package_kafka.sh
	mv kafka/package/RPMS/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm rpms/noarch/


librdkafka: rpms/x86_64/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm: librdkafka/CONFIG librdkafka/package_librdkafka.sh | rpms/x86_64
	cd librdkafka; ./package_librdkafka.sh
	mv librdkafka/sources/librdkafka/packaging/rpm/pkgs-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE)-default/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/
	mv librdkafka/sources/librdkafka/packaging/rpm/pkgs-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE)-default/librdkafka-devel-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/
	mv librdkafka/sources/librdkafka/packaging/rpm/pkgs-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE)-default/librdkafka-debuginfo-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


zookeeper: rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh zookeeper/files/* | rpms/noarch
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/package/RPMS/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm rpms/noarch/


kafka-manager: rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm: kafka-manager/CONFIG kafka-manager/package_kafka_manager.sh kafka-manager/files/* | rpms/noarch
	cd kafka-manager; ./package_kafka_manager.sh
	mv kafka-manager/package/RPMS/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm rpms/noarch/


rpms/x86_64:
	mkdir -p rpms/x86_64

rpms/noarch:
	mkdir -p rpms/noarch


clean: mostlyclean
	rm -rf rpms

mostlyclean:
	rm -rf {hdf5,kafka,kafka-manager,zookeeper}/{package,sources,workspace}
	rm -rf librdkafka/sources
