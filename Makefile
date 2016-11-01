include */CONFIG

.PHONY: all hdf5 kafka librdkafka zookeeper clean

all: hdf5 kafka librdkafka zookeeper


hdf5: rpms/hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).x86_64.rpm

rpms/hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).x86_64.rpm: hdf5/CONFIG hdf5/package_hdf5.sh | rpms
	cd hdf5; ./package_hdf5.sh
	mv hdf5/rpm/*.rpm rpms


kafka: rpms/kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).x86_64.rpm

rpms/kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).x86_64.rpm: kafka/CONFIG kafka/package_kafka.sh | rpms
	cd kafka; ./package_kafka.sh
	mv kafka/rpm/*.rpm rpms


librdkafka: rpms/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm

rpms/librdkafka1-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm: librdkafka/CONFIG librdkafka/package_librdkafka.sh | rpms
	cd librdkafka; ./package_librdkafka.sh
	mv librdkafka/rpm/*.rpm rpms


zookeeper: rpms/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm

rpms/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh | rpms
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/rpm/*.rpm rpms/


rpms:
	mkdir -p rpms


clean:
	rm -rf rpms
