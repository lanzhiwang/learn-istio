```bash


$ kubectl -n istio-system get pods
NAME                                    READY   STATUS    RESTARTS   AGE
istio-egressgateway-65d58fdb4-7tvwg     1/1     Running   0          112s
istio-ingressgateway-54c559f4b8-jjvv8   1/1     Running   0          112s
istiod-56c9cfc96b-xfrr4                 1/1     Running   0          2m18s
$

##############################################################################################################

$ kubectl -n istio-system exec -ti istiod-56c9cfc96b-xfrr4 -- bash

$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
istio-p+     1     0  0 10:53 ?        00:00:02 /usr/local/bin/pilot-discovery discovery --monitoringAddr=:15014 --log_output_level=debug --domain cluster.local

$ ps -ef | grep discovery
/usr/local/bin/pilot-discovery discovery --monitoringAddr=:15014 --log_output_level=debug --domain cluster.local --keepaliveMaxServerConnectionAge 30m


docker-mirrors.alauda.cn/istio/pilot:1.19.0-debug

$ pilot-discovery --help

$ pilot-discovery discovery --help

##############################################################################################################

$ kubectl -n istio-system exec -ti istio-ingressgateway-54c559f4b8-jjvv8 -- bash


$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
istio-p+     1     0  0 10:53 ?        00:00:00 /usr/local/bin/pilot-agent proxy router --domain istio-system.svc.cluster.local --proxyLogLevel=trace --proxyComp
istio-p+    18     1  0 10:53 ?        00:00:05 /usr/local/bin/envoy -c etc/istio/proxy/envoy-rev.json --drain-time-s 45 --drain-strategy immediate --local-addre


$ ps -ef | grep proxy
/usr/local/bin/pilot-agent proxy router --domain istio-system.svc.cluster.local --proxyLogLevel=trace --proxyComponentLogLevel=misc:error --log_output_level=debug


$ ps -ef | grep envoy
/usr/local/bin/envoy -c etc/istio/proxy/envoy-rev.json --drain-time-s 45 --drain-strategy immediate --local-address-ip-version v4 --file-flush-interval-msec 1000 --disable-hot-restart --allow-unknown-static-fields --log-format %Y-%m-%dT%T.%fZ.%l.envoy %n %g:%#.%v.thread=%t -l trace --component-log-level misc:error --concurrency 2

docker-mirrors.alauda.cn/istio/proxyv2:1.19.0-debug


##############################################################################################################


$ kubectl -n istio-system exec -ti istio-egressgateway-65d58fdb4-7tvwg -- bash


$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
istio-p+     1     0  0 10:53 ?        00:00:00 /usr/local/bin/pilot-agent proxy router --domain istio-system.svc.cluster.local --proxyLogLevel=trace --proxyComp
istio-p+    20     1  0 10:53 ?        00:00:04 /usr/local/bin/envoy -c etc/istio/proxy/envoy-rev.json --drain-time-s 45 --drain-strategy immediate --local-addre


$ ps -ef | grep router
/usr/local/bin/pilot-agent proxy router --domain istio-system.svc.cluster.local --proxyLogLevel=trace --proxyComponentLogLevel=misc:error --log_output_level=debug

$ ps -ef | grep enovy
/usr/local/bin/envoy -c etc/istio/proxy/envoy-rev.json --drain-time-s 45 --drain-strategy immediate --local-address-ip-version v4 --file-flush-interval-msec 1000 --disable-hot-restart --allow-unknown-static-fields --log-format %Y-%m-%dT%T.%fZ.%l.envoy %n %g:%#.%v.thread=%t -l trace --component-log-level misc:error --concurrency 2



################################################################################



```
