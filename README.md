# istio.io v1.26.1

[istio-1.26.1-osx.tar.gz](https://github.com/istio/istio/releases/download/1.26.1/istio-1.26.1-osx.tar.gz)

```bash
$ https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890 \
minikube start \
--image-mirror-country='' \
--image-repository='auto' \
--driver='docker' \
--memory='4g' \
--logtostderr \
--iso-url=https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-v1.37.0-amd64.iso \
--kubernetes-version='v1.34.0'

$ ./istio-1.26.1/bin/istioctl version
Istio is not present in the cluster: no running Istio pods in namespace "istio-system"
client version: 1.26.1
$
```

## Ambient Mode

```bash
$ kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml
$ kubectl apply -f ./istio-1.26.1/standard-install.yaml
Warning: unrecognized format "int64"
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
Warning: unrecognized format "int32"
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
$
$ kubectl get crd
NAME                                        CREATED AT
gatewayclasses.gateway.networking.k8s.io    2025-09-23T04:58:10Z
gateways.gateway.networking.k8s.io          2025-09-23T04:58:10Z
grpcroutes.gateway.networking.k8s.io        2025-09-23T04:58:10Z
httproutes.gateway.networking.k8s.io        2025-09-23T04:58:10Z
referencegrants.gateway.networking.k8s.io   2025-09-23T04:58:10Z
$

$ ./istio-1.26.1/bin/istioctl manifest generate --set profile=ambient > ./istio-1.26.1/ambient.yaml
$
$ ./istio-1.26.1/bin/istioctl install --set profile=ambient --skip-confirmation
        |\
        | \
        |  \
        |   \
      /||    \
     / ||     \
    /  ||      \
   /   ||       \
  /    ||        \
 /     ||         \
/______||__________\
____________________
  \__       _____/
     \_____/

✔ Istio core installed ⛵️
✔ Istiod installed 🧠
✔ CNI installed 🪢
✔ Ztunnel installed 🔒
✔ Installation complete
The ambient profile has been installed successfully, enjoy Istio without sidecars!
$

```

## Sidecar Mode

```bash
$ ./istio-1.26.1/bin/istioctl manifest generate --set profile=demo > ./istio-1.26.1/demo.yaml

$ ./istio-1.26.1/bin/istioctl install --set profile=demo
        |\
        | \
        |  \
        |   \
      /||    \
     / ||     \
    /  ||      \
   /   ||       \
  /    ||        \
 /     ||         \
/______||__________\
____________________
  \__       _____/
     \_____/

This will install the Istio 1.26.1 profile "demo" into the cluster. Proceed? (y/N) y
✔ Istio core installed ⛵️
✔ Istiod installed 🧠
✔ Ingress gateways installed 🛬
✔ Egress gateways installed 🛫
✔ Installation complete
$

$ ./get-crd.sh
kubectl get authorizationpolicies.security.istio.io -A
No resources found
--------------------------------------------------
kubectl get destinationrules.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get envoyfilters.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get gateways.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get peerauthentications.security.istio.io -A
No resources found
--------------------------------------------------
kubectl get proxyconfigs.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get requestauthentications.security.istio.io -A
No resources found
--------------------------------------------------
kubectl get serviceentries.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get sidecars.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get telemetries.telemetry.istio.io -A
No resources found
--------------------------------------------------
kubectl get virtualservices.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get wasmplugins.extensions.istio.io -A
No resources found
--------------------------------------------------
kubectl get workloadentries.networking.istio.io -A
No resources found
--------------------------------------------------
kubectl get workloadgroups.networking.istio.io -A
No resources found
--------------------------------------------------


$ kubectl -n istio-system get deploy
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
istio-egressgateway    1/1     1            1           4m40s
istio-ingressgateway   1/1     1            1           4m40s
istiod                 1/1     1            1           5m28s


$ kubectl -n istio-system get services
NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                      AGE
istio-egressgateway    ClusterIP      10.108.146.164   <none>        80/TCP,443/TCP                                                               4m42s
istio-ingressgateway   LoadBalancer   10.111.44.138    <pending>     15021:31798/TCP,80:32230/TCP,443:31279/TCP,31400:31891/TCP,15443:30479/TCP   4m42s
istiod                 ClusterIP      10.99.255.93     <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP                                        5m31s
$

docker pull docker.io/istio/proxyv2:1.26.1
docker run -ti --rm docker.io/istio/proxyv2:1.26.1 help
docker run -ti --rm docker.io/istio/proxyv2:1.26.1 proxy --help

docker pull docker.io/istio/pilot:1.26.1
docker run -ti --rm docker.io/istio/pilot:1.26.1 help
docker run -ti --rm docker.io/istio/pilot:1.26.1 discovery --help

```
