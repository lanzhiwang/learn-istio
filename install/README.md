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

$ ./istioctl install \
--set profile=demo \
--set hub=docker-mirrors.alauda.cn/istio \
--set tag=1.19.0-debug \
--set "values.gateways.istio-ingressgateway.type=NodePort" \
--set "values.global.logging.level=all:debug,default:debug" \
--set "values.global.proxy.logLevel=trace" \
--set "values.global.proxy.componentLogLevel=admin:debug,upstream:debug,config:trace,connection:debug,client:debug,grpc:debug,http:debug,http2:debug,alternate_protocols_cache:debug,aws:debug,assert:debug,backtrace:debug,cache_filter:debug,conn_handler:debug,decompression:debug,dns:debug,dubbo:debug,envoy_bug:debug,ext_authz:debug,ext_proc:debug,rocketmq:debug,file:debug,filter:debug,forward_proxy:debug,happy_eyeballs:debug,hc:debug,health_checker:debug,hystrix:debug,init:debug,io:debug,jwt:debug,kafka:debug,key_value_store:debug,lua:debug,main:debug,matcher:debug,misc:debug,mongo:debug,multi_connection:debug,oauth2:debug,quic:debug,quic_stream:debug,pool:debug,rate_limit_quota:debug,rbac:debug,rds:debug,redis:debug,router:debug,runtime:debug,stats:debug,secret:debug,tap:debug,testing:debug,thrift:debug,tracing:debug,udp:debug,wasm:debug,websocket:debug,golang:debug"

$ ./istioctl manifest generate \
--set profile=demo \
--set hub=docker-mirrors.alauda.cn/istio \
--set tag=1.19.0-debug \
--set "values.gateways.istio-ingressgateway.type=NodePort" \
--set "values.global.logging.level=all:debug,default:debug" \
--set "values.global.proxy.logLevel=trace" \
--set "values.global.proxy.componentLogLevel=admin:debug,upstream:debug,config:trace,connection:debug,client:debug,grpc:debug,http:debug,http2:debug,alternate_protocols_cache:debug,aws:debug,assert:debug,backtrace:debug,cache_filter:debug,conn_handler:debug,decompression:debug,dns:debug,dubbo:debug,envoy_bug:debug,ext_authz:debug,ext_proc:debug,rocketmq:debug,file:debug,filter:debug,forward_proxy:debug,happy_eyeballs:debug,hc:debug,health_checker:debug,hystrix:debug,init:debug,io:debug,jwt:debug,kafka:debug,key_value_store:debug,lua:debug,main:debug,matcher:debug,misc:debug,mongo:debug,multi_connection:debug,oauth2:debug,quic:debug,quic_stream:debug,pool:debug,rate_limit_quota:debug,rbac:debug,rds:debug,redis:debug,router:debug,runtime:debug,stats:debug,secret:debug,tap:debug,testing:debug,thrift:debug,tracing:debug,udp:debug,wasm:debug,websocket:debug,golang:debug"

HTTPS_PROXY=http://192.168.144.12:7890 nerdctl pull istio/proxyv2:1.19.0
nerdctl run -ti --rm istio/proxyv2:1.19.0 help
nerdctl run -ti --rm istio/proxyv2:1.19.0 proxy --help

HTTPS_PROXY=http://192.168.144.12:7890 nerdctl pull istio/pilot:1.19.0
nerdctl run -ti --rm istio/pilot:1.19.0 help
nerdctl run -ti --rm istio/pilot:1.19.0 discovery --help

```
