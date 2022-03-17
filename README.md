# Docker operations in Kubernetes

How to...

* Build container images inside a Kubernetes cluster
* Push to a container registry inside the cluster
* Start a pod that pulls an image from the in-cluster registry

## You will need

* [minikube](https://minikube.sigs.k8s.io/docs/)
* [Helm](https://helm.sh/)
* [GnuPG](https://gnupg.org/)

## Caveats

I've only tested this on a Mac so it may not work as well on other OSes. The scripts are all bash so you'll need to have something capable of running them if you're on Windows.
