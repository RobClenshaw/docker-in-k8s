#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

kubectl create configmap my-config --from-file=$SCRIPT_DIR/../helloworld -o yaml --dry-run=client > $SCRIPT_DIR/../yaml/configmap.yaml
kubectl apply -f $SCRIPT_DIR/../yaml/configmap.yaml
kubectl apply -f $SCRIPT_DIR/../yaml/build.yaml