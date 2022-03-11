minikube delete --profile test
ps -ef | grep -i port-forward | grep -v grep | awk {'print $2'} | xargs kill