#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PROFILE_EXISTS=$(minikube profile list | grep test)
if [ $? -eq 0 ]; then
    echo "test profile exists, deleting"
    minikube delete --profile test
fi

minikube start --profile test

export KUBEFLEDGED_NAMESPACE=kube-fledged
kubectl create namespace ${KUBEFLEDGED_NAMESPACE}
helm repo add kubefledged-charts https://senthilrch.github.io/kubefledged-charts/
helm repo update
gpg --keyserver keyserver.ubuntu.com --recv-keys 92D793FA3A6460ED #(or) gpg --keyserver pgp.mit.edu --recv-keys 92D793FA3A6460ED
gpg --export >~/.gnupg/pubring.gpg
helm install --verify kube-fledged kubefledged-charts/kube-fledged -n ${KUBEFLEDGED_NAMESPACE} --wait
kubectl apply -f $SCRIPT_DIR/../yaml/imagecache.yaml