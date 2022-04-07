#!/bin/bash
for pod in $(kubectl get pods -n kube-system | grep -v NAME | awk '{print $1}')
do
echo name-pod: $pod
kubectl describe pods/$pod --namespace kube-system | grep "Controlled By:"
done