include */CONFIG

.PHONY: all kafka zookeeper cmak clean mostlyclean

all: kafka zookeeper cmak

kafka: rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm

rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm: kafka/CONFIG kafka/package_kafka.sh kafka/files/* | rpms/noarch
	cd kafka; ./package_kafka.sh
	mv kafka/package/RPMS/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm rpms/noarch/


zookeeper: rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm

rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh zookeeper/files/* | rpms/noarch
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/package/RPMS/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm rpms/noarch/


cmak: rpms/noarch/dm-cmak-$(CMAK_VERSION)-$(CMAK_RELEASE).el7.noarch.rpm

rpms/noarch/dm-cmak-$(CMAK_VERSION)-$(CMAK_RELEASE).el7.noarch.rpm: cmak/CONFIG cmak/package_cmak.sh cmak/files/* | rpms/noarch
	cd cmak; ./package_cmak.sh
	mv cmak/package/RPMS/noarch/dm-cmak-$(CMAK_VERSION)-$(CMAK_RELEASE).el7.noarch.rpm rpms/noarch/


rpms/x86_64:
	mkdir -p rpms/x86_64

rpms/noarch:
	mkdir -p rpms/noarch


clean: mostlyclean
	rm -rf rpms

mostlyclean:
	rm -rf {kafka,cmak,zookeeper}/{package,sources,workspace}
