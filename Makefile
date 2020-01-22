include */CONFIG

.PHONY: all kafka zookeeper kafka-manager clean mostlyclean

all: kafka zookeeper kafka-manager

kafka: rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm

rpms/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm: kafka/CONFIG kafka/package_kafka.sh kafka/files/* | rpms/noarch
	cd kafka; ./package_kafka.sh
	mv kafka/package/RPMS/noarch/dm-kafka-$(KAFKA_VERSION)-$(KAFKA_RELEASE).el7.noarch.rpm rpms/noarch/


zookeeper: rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm

rpms/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm: zookeeper/CONFIG zookeeper/package_zookeeper.sh zookeeper/files/* | rpms/noarch
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/package/RPMS/noarch/dm-zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).el7.noarch.rpm rpms/noarch/


kafka-manager: rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.noarch.rpm

rpms/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.noarch.rpm: kafka-manager/CONFIG kafka-manager/package_kafka_manager.sh kafka-manager/files/* | rpms/noarch
	cd kafka-manager; ./package_kafka_manager.sh
	mv kafka-manager/package/RPMS/noarch/dm-kafka-manager-$(KAFKA_MANAGER_VERSION)-$(KAFKA_MANAGER_RELEASE).el7.noarch.rpm rpms/noarch/


rpms/x86_64:
	mkdir -p rpms/x86_64

rpms/noarch:
	mkdir -p rpms/noarch


clean: mostlyclean
	rm -rf rpms

mostlyclean:
	rm -rf {kafka,kafka-manager,zookeeper}/{package,sources,workspace}
