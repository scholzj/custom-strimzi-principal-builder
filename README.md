[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

# Custom Principal Builder

This repository contains an example of how you can build and use a custom principal builder class in [Strimzi-powered Apache Kafka clusters](https://strimzi.io).
It provides a custom principal builder that:
* It keeps the default mapping rules for mTLS users for the replication and control plane listeners used by internal Strimzi components such as the operators, Kafka nodes etc.. 
  That is important to keep Strimzi working.
* But it allows to customize the mapping rules for the other listeners.
  In the example in this repository, the users will be mapped to `<Certificate-CN>@my-cluster`.

## How to use the custom principal builder?

1. Customize the mapping rules anyway you want and build the projectwith Maven:
   ```
   mvn clean package
   ```
2. Edit the `Dockerfile` file and update the `FROM` defintion to match the Strimzi and Kafka version you want to use.
3. Build a new custom container image with the JAR and push it into your container repository.
   For example:
   ```
   docker build -t quay.io/scholzj/kafka:0.38.0-kafka-3.6.0 .
   docker push quay.io/scholzj/kafka:0.38.0-kafka-3.6.0
   ```
4. Use the image in your Kafka cluster and configure the custom principal builder class:
   ```yaml
   apiVersion: kafka.strimzi.io/v1beta2
   kind: Kafka
   metadata:
     name: my-cluster
   spec:
     # ...
     kafka:
       image: quay.io/scholzj/kafka:0.38.0-kafka-3.6.0
       config:
         principal.builder.class: cz.scholz.customprincipalbuilder.CustomPrincipalBuilder
       # ...  
   ```