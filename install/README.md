# istio.io v1.19

* https://istio.io/v1.19/docs/

```bash
$ minikube start \
--image-mirror-country='cn' \
--driver='hyperkit' \
--memory='4g' \
--logtostderr \
--iso-url=https://github.com/kubernetes/minikube/releases/download/v1.32.0/minikube-v1.32.0-amd64.iso


$ ./istioctl version
client version: 1.19.0
control plane version: 1.19.0
data plane version: 1.19.0 (1 proxies)

$ ./istioctl install
This will install the Istio 1.19.0 "default" profile (with components: Istio core, Istiod, and Ingress gateways) into the cluster. Proceed? (y/N) y
✔ Istio core installed
✔ Istiod installed
✔ Ingress gateways installed
✔ Installation complete
  Made this installation the default for injection and validation.

$ ./istioctl install --set profile=demo --set hub=docker-mirrors.alauda.cn/istio --set "values.gateways.istio-ingressgateway.type=NodePort"

$ ./istioctl manifest generate --set profile=demo --set hub=docker-mirrors.alauda.cn/istio --set "values.gateways.istio-ingressgateway.type=NodePort"


HTTPS_PROXY=http://192.168.144.12:7890 nerdctl pull istio/proxyv2:1.19.0
nerdctl run -ti --rm istio/proxyv2:1.19.0 help
nerdctl run -ti --rm istio/proxyv2:1.19.0 proxy --help

HTTPS_PROXY=http://192.168.144.12:7890 nerdctl pull istio/pilot:1.19.0
nerdctl run -ti --rm istio/pilot:1.19.0 help
nerdctl run -ti --rm istio/pilot:1.19.0 discovery --help


```
