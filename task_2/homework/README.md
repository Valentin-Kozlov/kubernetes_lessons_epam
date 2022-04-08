# Homework

### 1. Your task is to figure out who creates them, and who makes sure they are running (restores them after deletion)
Run scripts ./info-pods.sh

Result scripts:
```
name-pod: coredns-558bd4d5db-cggdj
Controlled By:  ReplicaSet/coredns-558bd4d5db
name-pod: coredns-558bd4d5db-msw9z
Controlled By:  ReplicaSet/coredns-558bd4d5db
name-pod: etcd-docker-desktop
Controlled By:  Node/docker-desktop
name-pod: kube-apiserver-docker-desktop
Controlled By:  Node/docker-desktop
name-pod: kube-controller-manager-docker-desktop
Controlled By:  Node/docker-desktop
name-pod: kube-proxy-6rgc6
Controlled By:  DaemonSet/kube-proxy
name-pod: kube-scheduler-docker-desktop
Controlled By:  Node/docker-desktop
name-pod: storage-provisioner
name-pod: vpnkit-controller
```

### 2. Implement Canary deployment of an application via Ingress. Traffic to canary deployment should be redirected if you add "canary:always" in the header, otherwise it should go to regular deployment. Set to redirect a percentage of traffic to canary deployment.

ConfigMap
---

Create **nginx-main** ConfigMap:
```
kubectl apply -f configmap-main.yaml
```
Create **_nginx-canary_** ConfigMap:
```
kubectl apply -f configmap-canary.yaml
```

Result:
```
NAME               DATA   AGE
kube-root-ca.crt   1      130m
nginx-canary       1      9s
nginx-main         1      16s
```

Deployment
---

Create **nginx-main** Deployment:
```
kubectl apply -f deployment-main.yaml
```
Create **_nginx-canary_** Deployment:
```
kubectl apply -f deployment-canary.yaml
```

Result:
```
NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment-epam-prod-canary   3/3     3            3           24s
nginx-deployment-epam-prod-main     7/7     7            7           28s
```

Service
---
Create **nginx-main** Service:
```
kubectl apply -f service-main.yaml
```
Create **_nginx-canary_** Service:
```
kubectl apply -f service-canary.yaml
```
Result:
```
NAME                             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes                       ClusterIP   10.96.0.1       <none>        443/TCP   133m
nginx-service-epam-prod-canary   ClusterIP   10.100.24.69    <none>        80/TCP    9s
nginx-service-epam-prod-main     ClusterIP   10.105.163.23   <none>        80/TCP    14s
```

Ingress
---

Create **nginx-main** Ingress-nginx:
```
kubectl apply -f ingress-main.yaml
```
Create **_nginx-canary_** Ingress-nginx:
```
kubectl apply -f ingress-canary.yaml
```
Result:
```
NAME                   CLASS    HOSTS   ADDRESS   PORTS   AGE
ingress-nginx-canary   <none>   *                 80      12s
ingress-nginx-main     <none>   *                 80      19s
```

Test
---
Testing canary deployment, start scripts canary.sh:

With percent:
```
for i in {1..10}; do  test=$(curl --silent http://127.0.0.1 | grep head); echo $test; done
```
Output:
```
<head><font color="green">MAIN</head>
<head><font color="blue">CANARY</head>
<head><font color="green">MAIN</head>
<head><font color="green">MAIN</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="green">MAIN</head>
<head><font color="blue">CANARY</head>
<head><font color="green">MAIN</head>
```

With canary:always:
```
for i in {1..10}; do  test=$(curl -H "canary: always" --silent http://127.0.0.1 | grep head); echo $test; done
```
Output:
```
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
<head><font color="blue">CANARY</head>
```
