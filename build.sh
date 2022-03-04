spinner()
{
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

delay=0.75
spinstr='|/-\'

PROFILE_NAME=test
PROFILE_EXISTS=$(minikube profile list | grep $PROFILE_NAME)
if [ $? -eq 0 ]; then
    echo "$PROFILE_NAME profile exists, deleting"
    minikube delete --profile $PROFILE_NAME
fi

minikube start --profile $PROFILE_NAME
kubectl apply -f registry.yaml
echo "waiting for registry to be ready"
while [ $(kubectl get pods -l='app=registry' -o json | jq '.items[0].status.containerStatuses[0].ready') != "true" ]
do
    temp=${spinstr#?}
    printf "\r\033[K [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
done
printf "\r\033[K"
kubectl apply -f configmap.yaml
kubectl port-forward service/registry 30007:443 &
PORTFORWARD_PID=$!
sleep 1
echo "curling https://localhost:30007/v2/_catalog"
curl https://localhost:30007/v2/_catalog -k
kubectl apply -f build.yaml
echo "waiting for job to finish"
while [ $(kubectl get job/docker-build -o json | jq '.status.succeeded') != "1" ]
do
    temp=${spinstr#?}
    printf "\r\033[K [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
done
printf "\r\033[K"
echo "curling https://localhost:30007/v2/_catalog"
curl https://localhost:30007/v2/_catalog -k
kill $PORTFORWARD_PID