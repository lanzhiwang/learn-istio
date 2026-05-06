# istio.io v1.26.1

## istioctl 工具

[istio-1.26.1-osx.tar.gz](https://github.com/istio/istio/releases/download/1.26.1/istio-1.26.1-osx.tar.gz)

```bash
$ tar -zxvf istio-1.26.1-osx.tar.gz
$ tree -a istio-1.26.1
istio-1.26.1
├── LICENSE
├── README.md
├── bin
│   └── istioctl
├── manifest.yaml
├── manifests
│   ├── charts
│   │   ├── README.md
│   │   ├── UPDATING-CHARTS.md
│   │   ├── base
│   │   │   ├── Chart.yaml
│   │   │   ├── README.md
│   │   │   ├── files
│   │   │   │   ├── crd-all.gen.yaml
│   │   │   │   ├── profile-ambient.yaml
│   │   │   │   ├── profile-compatibility-version-1.23.yaml
│   │   │   │   ├── profile-compatibility-version-1.24.yaml
│   │   │   │   ├── profile-compatibility-version-1.25.yaml
│   │   │   │   ├── profile-demo.yaml
│   │   │   │   ├── profile-platform-gke.yaml
│   │   │   │   ├── profile-platform-k3d.yaml
│   │   │   │   ├── profile-platform-k3s.yaml
│   │   │   │   ├── profile-platform-microk8s.yaml
│   │   │   │   ├── profile-platform-minikube.yaml
│   │   │   │   ├── profile-platform-openshift.yaml
│   │   │   │   ├── profile-preview.yaml
│   │   │   │   ├── profile-remote.yaml
│   │   │   │   └── profile-stable.yaml
│   │   │   ├── templates
│   │   │   │   ├── NOTES.txt
│   │   │   │   ├── crds.yaml
│   │   │   │   ├── defaultrevision-validatingadmissionpolicy.yaml
│   │   │   │   ├── defaultrevision-validatingwebhookconfiguration.yaml
│   │   │   │   ├── reader-serviceaccount.yaml
│   │   │   │   └── zzz_profile.yaml
│   │   │   └── values.yaml
│   │   ├── default
│   │   │   ├── Chart.yaml
│   │   │   ├── files
│   │   │   │   ├── profile-ambient.yaml
│   │   │   │   ├── profile-compatibility-version-1.23.yaml
│   │   │   │   ├── profile-compatibility-version-1.24.yaml
│   │   │   │   ├── profile-compatibility-version-1.25.yaml
│   │   │   │   ├── profile-demo.yaml
│   │   │   │   ├── profile-platform-gke.yaml
│   │   │   │   ├── profile-platform-k3d.yaml
│   │   │   │   ├── profile-platform-k3s.yaml
│   │   │   │   ├── profile-platform-microk8s.yaml
│   │   │   │   ├── profile-platform-minikube.yaml
│   │   │   │   ├── profile-platform-openshift.yaml
│   │   │   │   ├── profile-preview.yaml
│   │   │   │   ├── profile-remote.yaml
│   │   │   │   └── profile-stable.yaml
│   │   │   ├── templates
│   │   │   │   ├── mutatingwebhook.yaml
│   │   │   │   ├── validatingwebhook.yaml
│   │   │   │   └── zzz_profile.yaml
│   │   │   └── values.yaml
│   │   ├── gateway
│   │   │   ├── Chart.yaml
│   │   │   ├── README.md
│   │   │   ├── files
│   │   │   │   ├── profile-ambient.yaml
│   │   │   │   ├── profile-compatibility-version-1.23.yaml
│   │   │   │   ├── profile-compatibility-version-1.24.yaml
│   │   │   │   ├── profile-compatibility-version-1.25.yaml
│   │   │   │   ├── profile-demo.yaml
│   │   │   │   ├── profile-platform-gke.yaml
│   │   │   │   ├── profile-platform-k3d.yaml
│   │   │   │   ├── profile-platform-k3s.yaml
│   │   │   │   ├── profile-platform-microk8s.yaml
│   │   │   │   ├── profile-platform-minikube.yaml
│   │   │   │   ├── profile-platform-openshift.yaml
│   │   │   │   ├── profile-preview.yaml
│   │   │   │   ├── profile-remote.yaml
│   │   │   │   └── profile-stable.yaml
│   │   │   ├── templates
│   │   │   │   ├── NOTES.txt
│   │   │   │   ├── _helpers.tpl
│   │   │   │   ├── deployment.yaml
│   │   │   │   ├── hpa.yaml
│   │   │   │   ├── poddisruptionbudget.yaml
│   │   │   │   ├── role.yaml
│   │   │   │   ├── service.yaml
│   │   │   │   ├── serviceaccount.yaml
│   │   │   │   └── zzz_profile.yaml
│   │   │   ├── values.schema.json
│   │   │   └── values.yaml
│   │   ├── gateways
│   │   │   ├── istio-egress
│   │   │   │   ├── Chart.yaml
│   │   │   │   ├── NOTES.txt
│   │   │   │   ├── files
│   │   │   │   │   ├── profile-ambient.yaml
│   │   │   │   │   ├── profile-compatibility-version-1.23.yaml
│   │   │   │   │   ├── profile-compatibility-version-1.24.yaml
│   │   │   │   │   ├── profile-compatibility-version-1.25.yaml
│   │   │   │   │   ├── profile-demo.yaml
│   │   │   │   │   ├── profile-platform-gke.yaml
│   │   │   │   │   ├── profile-platform-k3d.yaml
│   │   │   │   │   ├── profile-platform-k3s.yaml
│   │   │   │   │   ├── profile-platform-microk8s.yaml
│   │   │   │   │   ├── profile-platform-minikube.yaml
│   │   │   │   │   ├── profile-platform-openshift.yaml
│   │   │   │   │   ├── profile-preview.yaml
│   │   │   │   │   ├── profile-remote.yaml
│   │   │   │   │   └── profile-stable.yaml
│   │   │   │   ├── templates
│   │   │   │   │   ├── _affinity.tpl
│   │   │   │   │   ├── autoscale.yaml
│   │   │   │   │   ├── deployment.yaml
│   │   │   │   │   ├── injected-deployment.yaml
│   │   │   │   │   ├── poddisruptionbudget.yaml
│   │   │   │   │   ├── role.yaml
│   │   │   │   │   ├── rolebindings.yaml
│   │   │   │   │   ├── service.yaml
│   │   │   │   │   ├── serviceaccount.yaml
│   │   │   │   │   └── zzz_profile.yaml
│   │   │   │   └── values.yaml
│   │   │   └── istio-ingress
│   │   │       ├── Chart.yaml
│   │   │       ├── NOTES.txt
│   │   │       ├── files
│   │   │       │   ├── profile-ambient.yaml
│   │   │       │   ├── profile-compatibility-version-1.23.yaml
│   │   │       │   ├── profile-compatibility-version-1.24.yaml
│   │   │       │   ├── profile-compatibility-version-1.25.yaml
│   │   │       │   ├── profile-demo.yaml
│   │   │       │   ├── profile-platform-gke.yaml
│   │   │       │   ├── profile-platform-k3d.yaml
│   │   │       │   ├── profile-platform-k3s.yaml
│   │   │       │   ├── profile-platform-microk8s.yaml
│   │   │       │   ├── profile-platform-minikube.yaml
│   │   │       │   ├── profile-platform-openshift.yaml
│   │   │       │   ├── profile-preview.yaml
│   │   │       │   ├── profile-remote.yaml
│   │   │       │   └── profile-stable.yaml
│   │   │       ├── templates
│   │   │       │   ├── _affinity.tpl
│   │   │       │   ├── autoscale.yaml
│   │   │       │   ├── deployment.yaml
│   │   │       │   ├── injected-deployment.yaml
│   │   │       │   ├── poddisruptionbudget.yaml
│   │   │       │   ├── role.yaml
│   │   │       │   ├── rolebindings.yaml
│   │   │       │   ├── service.yaml
│   │   │       │   ├── serviceaccount.yaml
│   │   │       │   └── zzz_profile.yaml
│   │   │       └── values.yaml
│   │   ├── install-OpenShift.md
│   │   ├── istio-cni
│   │   │   ├── Chart.yaml
│   │   │   ├── README.md
│   │   │   ├── files
│   │   │   │   ├── profile-ambient.yaml
│   │   │   │   ├── profile-compatibility-version-1.23.yaml
│   │   │   │   ├── profile-compatibility-version-1.24.yaml
│   │   │   │   ├── profile-compatibility-version-1.25.yaml
│   │   │   │   ├── profile-demo.yaml
│   │   │   │   ├── profile-platform-gke.yaml
│   │   │   │   ├── profile-platform-k3d.yaml
│   │   │   │   ├── profile-platform-k3s.yaml
│   │   │   │   ├── profile-platform-microk8s.yaml
│   │   │   │   ├── profile-platform-minikube.yaml
│   │   │   │   ├── profile-platform-openshift.yaml
│   │   │   │   ├── profile-preview.yaml
│   │   │   │   ├── profile-remote.yaml
│   │   │   │   └── profile-stable.yaml
│   │   │   ├── templates
│   │   │   │   ├── NOTES.txt
│   │   │   │   ├── _helpers.tpl
│   │   │   │   ├── clusterrole.yaml
│   │   │   │   ├── clusterrolebinding.yaml
│   │   │   │   ├── configmap-cni.yaml
│   │   │   │   ├── daemonset.yaml
│   │   │   │   ├── network-attachment-definition.yaml
│   │   │   │   ├── resourcequota.yaml
│   │   │   │   ├── serviceaccount.yaml
│   │   │   │   ├── zzy_descope_legacy.yaml
│   │   │   │   └── zzz_profile.yaml
│   │   │   └── values.yaml
│   │   ├── istio-control
│   │   │   └── istio-discovery
│   │   │       ├── Chart.yaml
│   │   │       ├── README.md
│   │   │       ├── files
│   │   │       │   ├── gateway-injection-template.yaml
│   │   │       │   ├── grpc-agent.yaml
│   │   │       │   ├── grpc-simple.yaml
│   │   │       │   ├── injection-template.yaml
│   │   │       │   ├── kube-gateway.yaml
│   │   │       │   ├── profile-ambient.yaml
│   │   │       │   ├── profile-compatibility-version-1.23.yaml
│   │   │       │   ├── profile-compatibility-version-1.24.yaml
│   │   │       │   ├── profile-compatibility-version-1.25.yaml
│   │   │       │   ├── profile-demo.yaml
│   │   │       │   ├── profile-platform-gke.yaml
│   │   │       │   ├── profile-platform-k3d.yaml
│   │   │       │   ├── profile-platform-k3s.yaml
│   │   │       │   ├── profile-platform-microk8s.yaml
│   │   │       │   ├── profile-platform-minikube.yaml
│   │   │       │   ├── profile-platform-openshift.yaml
│   │   │       │   ├── profile-preview.yaml
│   │   │       │   ├── profile-remote.yaml
│   │   │       │   ├── profile-stable.yaml
│   │   │       │   └── waypoint.yaml
│   │   │       ├── templates
│   │   │       │   ├── NOTES.txt
│   │   │       │   ├── _helpers.tpl
│   │   │       │   ├── autoscale.yaml
│   │   │       │   ├── clusterrole.yaml
│   │   │       │   ├── clusterrolebinding.yaml
│   │   │       │   ├── configmap-jwks.yaml
│   │   │       │   ├── configmap-values.yaml
│   │   │       │   ├── configmap.yaml
│   │   │       │   ├── deployment.yaml
│   │   │       │   ├── gateway-class-configmap.yaml
│   │   │       │   ├── istiod-injector-configmap.yaml
│   │   │       │   ├── mutatingwebhook.yaml
│   │   │       │   ├── poddisruptionbudget.yaml
│   │   │       │   ├── reader-clusterrole.yaml
│   │   │       │   ├── reader-clusterrolebinding.yaml
│   │   │       │   ├── remote-istiod-endpoints.yaml
│   │   │       │   ├── remote-istiod-service.yaml
│   │   │       │   ├── revision-tags.yaml
│   │   │       │   ├── role.yaml
│   │   │       │   ├── rolebinding.yaml
│   │   │       │   ├── service.yaml
│   │   │       │   ├── serviceaccount.yaml
│   │   │       │   ├── validatingadmissionpolicy.yaml
│   │   │       │   ├── validatingwebhookconfiguration.yaml
│   │   │       │   ├── zzy_descope_legacy.yaml
│   │   │       │   └── zzz_profile.yaml
│   │   │       └── values.yaml
│   │   └── ztunnel
│   │       ├── Chart.yaml
│   │       ├── README.md
│   │       ├── files
│   │       │   ├── profile-ambient.yaml
│   │       │   ├── profile-compatibility-version-1.23.yaml
│   │       │   ├── profile-compatibility-version-1.24.yaml
│   │       │   ├── profile-compatibility-version-1.25.yaml
│   │       │   ├── profile-demo.yaml
│   │       │   ├── profile-platform-gke.yaml
│   │       │   ├── profile-platform-k3d.yaml
│   │       │   ├── profile-platform-k3s.yaml
│   │       │   ├── profile-platform-microk8s.yaml
│   │       │   ├── profile-platform-minikube.yaml
│   │       │   ├── profile-platform-openshift.yaml
│   │       │   ├── profile-preview.yaml
│   │       │   ├── profile-remote.yaml
│   │       │   └── profile-stable.yaml
│   │       ├── templates
│   │       │   ├── NOTES.txt
│   │       │   ├── _helpers.tpl
│   │       │   ├── daemonset.yaml
│   │       │   ├── rbac.yaml
│   │       │   ├── resourcequota.yaml
│   │       │   └── zzz_profile.yaml
│   │       └── values.yaml
│   └── profiles
│       ├── ambient.yaml
│       ├── default.yaml
│       ├── demo.yaml
│       ├── empty.yaml
│       ├── minimal.yaml
│       ├── openshift-ambient.yaml
│       ├── openshift.yaml
│       ├── preview.yaml
│       ├── remote.yaml
│       └── stable.yaml
├── samples
│   ├── README.md
│   ├── addons
│   │   ├── README.md
│   │   ├── extras
│   │   │   ├── prometheus-operator.yaml
│   │   │   ├── skywalking.yaml
│   │   │   └── zipkin.yaml
│   │   ├── grafana.yaml
│   │   ├── jaeger.yaml
│   │   ├── kiali.yaml
│   │   ├── loki.yaml
│   │   └── prometheus.yaml
│   ├── ambient-argo
│   │   ├── README.md
│   │   ├── application
│   │   │   ├── application.yaml
│   │   │   ├── bookinfo-versions.yaml
│   │   │   ├── details-waypoint.yaml
│   │   │   ├── details.yaml
│   │   │   ├── ingress-gateway.yaml
│   │   │   ├── namespace.yaml
│   │   │   ├── productpage.yaml
│   │   │   ├── ratings.yaml
│   │   │   ├── reviews-waypoint.yaml
│   │   │   ├── reviews.yaml
│   │   │   └── route-reviews-90-10.yaml
│   │   ├── documentation
│   │   ├── istio
│   │   │   ├── cni.yaml
│   │   │   ├── control-plane-appset.yaml
│   │   │   ├── extras.yaml
│   │   │   ├── tags.yaml
│   │   │   └── ztunnel.yaml
│   │   ├── meta-application.yaml
│   │   └── tag-chart
│   │       ├── Chart.yaml
│   │       ├── templates
│   │       │   ├── mutatingwebhooks.yaml
│   │       │   ├── shimservice.yaml
│   │       │   └── validatingwebhook.yaml
│   │       └── values.yaml
│   ├── bookinfo
│   │   ├── README.md
│   │   ├── demo-profile-no-gateways.yaml
│   │   ├── gateway-api
│   │   │   ├── bookinfo-gateway.yaml
│   │   │   ├── route-all-v1.yaml
│   │   │   ├── route-reviews-50-v3.yaml
│   │   │   ├── route-reviews-90-10.yaml
│   │   │   ├── route-reviews-v1.yaml
│   │   │   └── route-reviews-v3.yaml
│   │   ├── networking
│   │   │   ├── bookinfo-gateway.yaml
│   │   │   ├── certmanager-gateway.yaml
│   │   │   ├── destination-rule-all-mtls.yaml
│   │   │   ├── destination-rule-all.yaml
│   │   │   ├── destination-rule-reviews.yaml
│   │   │   ├── egress-rule-google-apis.yaml
│   │   │   ├── fault-injection-details-v1.yaml
│   │   │   ├── virtual-service-all-v1.yaml
│   │   │   ├── virtual-service-details-v2.yaml
│   │   │   ├── virtual-service-ratings-db.yaml
│   │   │   ├── virtual-service-ratings-mysql-vm.yaml
│   │   │   ├── virtual-service-ratings-mysql.yaml
│   │   │   ├── virtual-service-ratings-test-abort.yaml
│   │   │   ├── virtual-service-ratings-test-delay.yaml
│   │   │   ├── virtual-service-reviews-50-v3.yaml
│   │   │   ├── virtual-service-reviews-80-20.yaml
│   │   │   ├── virtual-service-reviews-90-10.yaml
│   │   │   ├── virtual-service-reviews-jason-v2-v3.yaml
│   │   │   ├── virtual-service-reviews-test-v2.yaml
│   │   │   ├── virtual-service-reviews-v2-v3.yaml
│   │   │   └── virtual-service-reviews-v3.yaml
│   │   ├── platform
│   │   │   └── kube
│   │   │       ├── README.md
│   │   │       ├── bookinfo-certificate.yaml
│   │   │       ├── bookinfo-db.yaml
│   │   │       ├── bookinfo-details-dualstack.yaml
│   │   │       ├── bookinfo-details-v2.yaml
│   │   │       ├── bookinfo-details.yaml
│   │   │       ├── bookinfo-dualstack.yaml
│   │   │       ├── bookinfo-ingress.yaml
│   │   │       ├── bookinfo-mysql.yaml
│   │   │       ├── bookinfo-psa.yaml
│   │   │       ├── bookinfo-ratings-discovery-dualstack.yaml
│   │   │       ├── bookinfo-ratings-discovery.yaml
│   │   │       ├── bookinfo-ratings-dualstack.yaml
│   │   │       ├── bookinfo-ratings-v2-mysql-vm.yaml
│   │   │       ├── bookinfo-ratings-v2-mysql.yaml
│   │   │       ├── bookinfo-ratings-v2.yaml
│   │   │       ├── bookinfo-ratings.yaml
│   │   │       ├── bookinfo-reviews-v2.yaml
│   │   │       ├── bookinfo-versions.yaml
│   │   │       ├── bookinfo.yaml
│   │   │       ├── cleanup.sh
│   │   │       └── productpage-nodeport.yaml
│   │   ├── policy
│   │   │   └── productpage_envoy_ratelimit.yaml
│   │   ├── src
│   │   │   ├── build-services.sh
│   │   │   ├── details
│   │   │   ├── mongodb
│   │   │   │   ├── ratings_data.json
│   │   │   │   └── script.sh
│   │   │   ├── mysql
│   │   │   ├── productpage
│   │   │   │   ├── requirements.txt
│   │   │   │   ├── static
│   │   │   │   │   ├── img
│   │   │   │   │   └── tailwind
│   │   │   │   ├── templates
│   │   │   │   ├── test-requirements.txt
│   │   │   │   └── tests
│   │   │   │       └── unit
│   │   │   ├── ratings
│   │   │   │   └── package.json
│   │   │   └── reviews
│   │   │       ├── reviews-application
│   │   │       │   └── src
│   │   │       │       ├── main
│   │   │       │       │   ├── java
│   │   │       │       │   │   └── application
│   │   │       │       │   │       └── rest
│   │   │       │       │   └── webapp
│   │   │       │       │       └── WEB-INF
│   │   │       │       └── test
│   │   │       │           └── java
│   │   │       │               └── test
│   │   │       └── reviews-wlpcfg
│   │   │           ├── servers
│   │   │           │   └── LibertyProjectServer
│   │   │           ├── shared
│   │   │           └── src
│   │   │               └── test
│   │   │                   └── java
│   │   │                       └── it
│   │   │                           └── rest
│   │   └── swagger.yaml
│   ├── builder
│   │   └── README.md
│   ├── certs
│   │   ├── README.md
│   │   ├── ca-cert-alt-2.pem
│   │   ├── ca-cert-alt.pem
│   │   ├── ca-cert.pem
│   │   ├── ca-key-alt-2.pem
│   │   ├── ca-key-alt.pem
│   │   ├── ca-key.pem
│   │   ├── cert-chain-alt-2.pem
│   │   ├── cert-chain-alt.pem
│   │   ├── cert-chain.pem
│   │   ├── generate-workload.sh
│   │   ├── leaf-workload-bar-cert.pem
│   │   ├── leaf-workload-foo-cert.pem
│   │   ├── root-cert-alt.pem
│   │   ├── root-cert-combined-2.pem
│   │   ├── root-cert-combined.pem
│   │   ├── root-cert.pem
│   │   ├── workload-bar-cert.pem
│   │   ├── workload-bar-key.pem
│   │   ├── workload-bar-root-certs.pem
│   │   ├── workload-foo-cert.pem
│   │   ├── workload-foo-key.pem
│   │   └── workload-foo-root-certs.pem
│   ├── cicd
│   │   └── skaffold
│   │       ├── README.md
│   │       └── skaffold.yaml
│   ├── curl
│   │   ├── README.md
│   │   └── curl.yaml
│   ├── custom-bootstrap
│   │   ├── README.md
│   │   ├── custom-bootstrap.yaml
│   │   └── example-app.yaml
│   ├── extauthz
│   │   ├── README.md
│   │   ├── cmd
│   │   │   └── extauthz
│   │   ├── docker
│   │   ├── ext-authz.yaml
│   │   └── local-ext-authz.yaml
│   ├── external
│   │   ├── README.md
│   │   ├── aptget.yaml
│   │   ├── github.yaml
│   │   └── pypi.yaml
│   ├── grpc-echo
│   │   ├── README.md
│   │   └── grpc-echo.yaml
│   ├── health-check
│   │   ├── liveness-command.yaml
│   │   └── liveness-http-same-port.yaml
│   ├── helloworld
│   │   ├── README.md
│   │   ├── gateway-api
│   │   │   ├── README.md
│   │   │   ├── helloworld-gateway.yaml
│   │   │   ├── helloworld-route.yaml
│   │   │   └── helloworld-versions.yaml
│   │   ├── gen-helloworld.sh
│   │   ├── helloworld-dual-stack.yaml
│   │   ├── helloworld-gateway.yaml
│   │   ├── helloworld.yaml
│   │   ├── loadgen.sh
│   │   └── src
│   │       └── requirements.txt
│   ├── httpbin
│   │   ├── README.md
│   │   ├── gateway-api
│   │   │   └── httpbin-gateway.yaml
│   │   ├── httpbin-gateway.yaml
│   │   ├── httpbin-nodeport.yaml
│   │   ├── httpbin.yaml
│   │   └── sample-client
│   │       └── fortio-deploy.yaml
│   ├── jwt-server
│   │   ├── jwt-server.yaml
│   │   ├── src
│   │   │   └── Makefile
│   │   └── testdata
│   ├── kind-lb
│   │   ├── README.md
│   │   └── setupkind.sh
│   ├── multicluster
│   │   ├── README.md
│   │   ├── expose-istiod-https.yaml
│   │   ├── expose-istiod.yaml
│   │   ├── expose-services.yaml
│   │   └── gen-eastwest-gateway.sh
│   ├── open-telemetry
│   │   ├── als
│   │   │   └── README.md
│   │   ├── loki
│   │   │   ├── REAME.md
│   │   │   ├── iop.yaml
│   │   │   ├── otel.yaml
│   │   │   └── telemetry.yaml
│   │   ├── otel.yaml
│   │   └── tracing
│   │       ├── README.md
│   │       └── telemetry.yaml
│   ├── proxy-coredump
│   │   ├── README.md
│   │   └── daemonset.yaml
│   ├── ratelimit
│   │   ├── local-rate-limit-service.yaml
│   │   └── rate-limit-service.yaml
│   ├── security
│   │   ├── psp
│   │   │   └── sidecar-psp.yaml
│   │   └── spire
│   │       ├── README.md
│   │       ├── clusterspiffeid.yaml
│   │       ├── curl-spire.yaml
│   │       ├── istio-spire-config.yaml
│   │       ├── sleep-spire.yaml
│   │       └── spire-quickstart.yaml
│   ├── sleep
│   │   ├── README.md
│   │   └── sleep.yaml
│   ├── tcp-echo
│   │   ├── README.md
│   │   ├── gateway-api
│   │   │   ├── tcp-echo-20-v2.yaml
│   │   │   └── tcp-echo-all-v1.yaml
│   │   ├── src
│   │   ├── tcp-echo-20-v2.yaml
│   │   ├── tcp-echo-all-v1.yaml
│   │   ├── tcp-echo-dual-stack.yaml
│   │   ├── tcp-echo-ipv4.yaml
│   │   ├── tcp-echo-ipv6.yaml
│   │   ├── tcp-echo-services.yaml
│   │   └── tcp-echo.yaml
│   ├── wasm_modules
│   │   ├── README.md
│   │   └── header_injector
│   │       └── Makefile
│   └── websockets
│       ├── README.md
│       ├── app.yaml
│       └── route.yaml
└── tools
    ├── _istioctl
    ├── certs
    │   ├── Makefile.k8s.mk
    │   ├── Makefile.selfsigned.mk
    │   ├── README.md
    │   └── common.mk
    └── istioctl.bash

121 directories, 443 files
$
```

## minikube

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

## Istio Ambient Mode

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

## Istio Sidecar Mode

```bash
$ ./istio-1.26.1/bin/istioctl manifest generate --set profile=demo > ./istio-1.26.1/demo.yaml

CustomResourceDefinition
  gateways.networking.istio.io
  virtualservices.networking.istio.io
  destinationrules.networking.istio.io
  envoyfilters.networking.istio.io
  proxyconfigs.networking.istio.io
  serviceentries.networking.istio.io
  sidecars.networking.istio.io
  workloadentries.networking.istio.io
  workloadgroups.networking.istio.io
  requestauthentications.security.istio.io
  peerauthentications.security.istio.io
  authorizationpolicies.security.istio.io
  telemetries.telemetry.istio.io
  wasmplugins.extensions.istio.io

ServiceAccount
  istio-egressgateway-service-account
  istio-ingressgateway-service-account
  istio-reader-service-account
  istiod

ClusterRole
  istio-reader-clusterrole-istio-system
  istiod-clusterrole-istio-system
  istiod-gateway-controller-istio-system

ClusterRoleBinding
  istio-reader-clusterrole-istio-system
  istiod-clusterrole-istio-system
  istiod-gateway-controller-istio-system

ValidatingWebhookConfiguration
  istio-validator-istio-system

ConfigMap
  istio
  istio-sidecar-injector
  values

MutatingWebhookConfiguration
  istio-sidecar-injector

Deployment
  istio-egressgateway
  istio-ingressgateway
  istiod

PodDisruptionBudget
  istio-egressgateway
  istio-ingressgateway
  istiod

Role
  istio-egressgateway-sds
  istio-ingressgateway-sds
  istiod

RoleBinding
  istio-egressgateway-sds
  istio-ingressgateway-sds
  istiod

Service
  istio-egressgateway
  istio-ingressgateway
  istiod

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
