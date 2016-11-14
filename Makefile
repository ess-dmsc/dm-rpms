include */CONFIG

.PHONY: all hdf5 kafka librdkafka zookeeper kafka-manager clean

all: hdf5 kafka librdkafka zookeeper kafka-manager


hdf5: rpms/x86_64/hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).x86_64.rpm

rpms/x86_64/hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).x86_64.rpm: hdf5/CONFIG hdf5/package_hdf5.sh | rpms/x86_64
	cd hdf5; ./package_hdf5.sh
	mv hdf5/rpm/*.rpm rpms/x86_64


kafka: rpms/x86_64/kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).x86_64.rpm

rpms/x86_64/kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).x86_64.rpm: kafka/CONFIG kafka/package_kafka.sh kafka/files/* | rpms/x86_64
	cd kafka; ./package_kafka.sh
	mv kafka/rpm/*.rpm rpms/x86_64


librdkafka: rpms/x86_64/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm: librdkafka/CONFIG librdkafka/package_librdkafka.sh | rpms/x86_64
	cd librdkafka; ./package_librdkafka.sh
	mv librdkafka/rpm/*.rpm rpms/x86_64


zookeeper: rpms/x86_64/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm

rpms/x86_64/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh zookeeper/files/* | rpms/x86_64
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/rpm/*.rpm rpms/x86_64/


kafka-manager: rpms/noarch/kafka-manager-$(KAFKA_MANAGER_VERSION)-1.noarch.rpm

rpms/noarch/kafka-manager-$(KAFKA_MANAGER_VERSION)-1.noarch.rpm: kafka-manager/CONFIG kafka-manager/package_kafka_manager.sh | rpms/noarch
	cd kafka-manager; ./package_kafka_manager.sh
	mv kafka-manager/rpm/*.rpm rpms/noarch


rpms/x86_64:
	mkdir -p rpms/x86_64

rpms/noarch:
	mkdir -p rpms/noarch


clean:
	rm -rf rpms
