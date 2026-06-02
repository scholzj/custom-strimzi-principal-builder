FROM quay.io/strimzi/kafka:0.51.0-kafka-4.2.0
USER root:root

COPY target/custom-principal-builder.jar /opt/kafka/libs/

USER 1001
