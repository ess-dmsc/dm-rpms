include */CONFIG

.PHONY: all flatbuffers hdf5 kafka librdkafka zookeeper kafka-manager rapidjson clean mostlyclean

all: flatbuffers hdf5 kafka librdkafka zookeeper kafka-manager rapidjson


flatbuffers: rpms/x86_64/dm-flatbuffers-$(FLATBUFFERS_VERSION)-$(FLATBUFFERS_RELEASE).el7.centos.x86_64.rpm


rpms/x86_64/dm-flatbuffers-$(FLATBUFFERS_VERSION)-$(FLATBUFFERS_RELEASE).el7.centos.x86_64.rpm: flatbuffers/CONFIG flatbuffers/package_flatbuffers.sh flatbuffers/files/* | rpms/x86_64
	cd flatbuffers; ./package_flatbuffers.sh
	mv flatbuffers/package/RPMS/x86_64/dm-flatbuffers-$(FLATBUFFERS_VERSION)-$(FLATBUFFERS_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


hdf5: rpms/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm: hdf5/CONFIG hdf5/package_hdf5.sh hdf5/files/* | rpms/x86_64
	cd hdf5; ./package_hdf5.sh
	mv hdf5/package/RPMS/x86_64/dm-hdf5-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/
	mv hdf5/package/RPMS/x86_64/dm-hdf5-devel-$(HDF5_VERSION)-$(HDF5_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


kafka: rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm: kafka/CONFIG kafka/package_kafka.sh kafka/files/* | rpms/noarch
	cd kafka; ./package_kafka.sh
	mv kafka/package/RPMS/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.centos.noarch.rpm rpms/noarch/


librdkafka: rpms/x86_64/dm-librdkafka-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/dm-librdkafka-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm: librdkafka/CONFIG librdkafka/package_librdkafka.sh librdkafka/files/* | rpms/x86_64
	cd librdkafka; ./package_librdkafka.sh
	mv librdkafka/package/RPMS/x86_64/dm-librdkafka-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/
	mv librdkafka/package/RPMS/x86_64/dm-librdkafka-devel-$(LIBRDKAFKA_VERSION)-$(LIBRDKAFKA_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


zookeeper: rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh zookeeper/files/* | rpms/noarch
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/package/RPMS/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.centos.noarch.rpm rpms/noarch/


kafka-manager: rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm

rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm: kafka-manager/CONFIG kafka-manager/package_kafka_manager.sh kafka-manager/files/* | rpms/noarch
	cd kafka-manager; ./package_kafka_manager.sh
	mv kafka-manager/package/RPMS/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.centos.noarch.rpm rpms/noarch/

rapidjson: rpms/x86_64/dm-rapidjson-devel-$(RAPIDJSON_VERSION)-$(RAPIDJSON_RELEASE).el7.centos.x86_64.rpm

rpms/x86_64/dm-rapidjson-devel-$(RAPIDJSON_VERSION)-$(RAPIDJSON_RELEASE).el7.centos.x86_64.rpm: rapidjson/CONFIG rapidjson/package_rapidjson.sh rapidjson/files/* | rpms/x86_64
	cd rapidjson; ./package_rapidjson.sh
	mv rapidjson/package/RPMS/x86_64/dm-rapidjson-devel-$(RAPIDJSON_VERSION)-$(RAPIDJSON_RELEASE).el7.centos.x86_64.rpm rpms/x86_64/


rpms/x86_64:
	mkdir -p rpms/x86_64

rpms/noarch:
	mkdir -p rpms/noarch


clean: mostlyclean
	rm -rf rpms

mostlyclean:
	rm -rf {flatbuffers,hdf5,kafka,kafka-manager,librdkafka,rapidjson,zookeeper}/{package,sources,workspace}
