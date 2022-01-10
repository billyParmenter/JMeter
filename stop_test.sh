#!/usr/bin/env bash

master_pod=$(kubectl get pod -n "${namespace}" | grep jmeter-master | awk '{print $1}')

kubectl -n "${namespace}" exec -c jmmaster -i "${master_pod}" -- bash //opt/jmeter/apache-jmeter/bin/stoptest.sh
