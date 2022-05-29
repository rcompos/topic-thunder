#!/usr/bin/env bash
set +x

./bin/spark-submit \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.container.image=bitnami/spark:3 \
    --master k8s://https://lucky-0.blacklab.lan:6443 \
    --conf spark.kubernetes.driverEnv.SPARK_MASTER_URL=spark://spark-lucky.blacklab.lan:7077\
    --deploy-mode cluster \
    ./examples/jars/spark-examples_2.12-3.2.0.jar 1000
