.PHONY: all kafka librdkafka zookeeper clean

include */CONFIG

all: kafka librdkafka zookeeper

kafka: | rpms
	cd kafka; ./package_kafka.sh
	mv kafka/rpm/*.rpm rpms

librdkafka: | rpms
	cd librdkafka; ./package_librdkafka.sh
	mv librdkafka/rpm/*.rpm rpms

zookeeper: rpms/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm

rpms/zookeeper-$(ZOOKEEPER_VERSION)-$(ZOOKEEPER_RELEASE).x86_64.rpm: | rpms
	cd zookeeper; ./package_zookeeper.sh
	mv zookeeper/rpm/*.rpm rpms/

rpms:
	mkdir -p rpms
