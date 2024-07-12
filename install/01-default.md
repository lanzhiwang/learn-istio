```bash
$ ./istioctl profile list
Istio configuration profiles:
    ambient
    default
    demo
    empty
    external
    minimal
    openshift
    preview
    remote
$

$ ./istioctl profile dump default
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  components:
    base:
      enabled: true
    cni:
      enabled: false
    egressGateways:
    - enabled: false
      name: istio-egressgateway
    ingressGateways:
    - enabled: true
      name: istio-ingressgateway
    istiodRemote:
      enabled: false
    pilot:
      enabled: true
  hub: docker.io/istio
  meshConfig:
    defaultConfig:
      proxyMetadata: {}
    enablePrometheusMerge: true
  profile: default
  tag: 1.19.0
  values:
    base:
      enableCRDTemplates: false
      validationURL: ""
    defaultRevision: ""
    gateways:
      istio-egressgateway:
        autoscaleEnabled: true
        env: {}
        name: istio-egressgateway
        secretVolumes:
        - mountPath: /etc/istio/egressgateway-certs
          name: egressgateway-certs
          secretName: istio-egressgateway-certs
        - mountPath: /etc/istio/egressgateway-ca-certs
          name: egressgateway-ca-certs
          secretName: istio-egressgateway-ca-certs
        type: ClusterIP
      istio-ingressgateway:
        autoscaleEnabled: true
        env: {}
        name: istio-ingressgateway
        secretVolumes:
        - mountPath: /etc/istio/ingressgateway-certs
          name: ingressgateway-certs
          secretName: istio-ingressgateway-certs
        - mountPath: /etc/istio/ingressgateway-ca-certs
          name: ingressgateway-ca-certs
          secretName: istio-ingressgateway-ca-certs
        type: LoadBalancer
    global:
      configValidation: true
      defaultNodeSelector: {}
      defaultPodDisruptionBudget:
        enabled: true
      defaultResources:
        requests:
          cpu: 10m
      imagePullPolicy: ""
      imagePullSecrets: []
      istioNamespace: istio-system
      istiod:
        enableAnalysis: false
      jwtPolicy: third-party-jwt
      logAsJson: false
      logging:
        level: default:info
      meshNetworks: {}
      mountMtlsCerts: false
      multiCluster:
        clusterName: ""
        enabled: false
      network: ""
      omitSidecarInjectorConfigMap: false
      oneNamespace: false
      operatorManageWebhooks: false
      pilotCertProvider: istiod
      priorityClassName: ""
      proxy:
        autoInject: enabled
        clusterDomain: cluster.local
        componentLogLevel: misc:error
        enableCoreDump: false
        excludeIPRanges: ""
        excludeInboundPorts: ""
        excludeOutboundPorts: ""
        image: proxyv2
        includeIPRanges: '*'
        logLevel: warning
        privileged: false
        readinessFailureThreshold: 30
        readinessInitialDelaySeconds: 1
        readinessPeriodSeconds: 2
        resources:
          limits:
            cpu: 2000m
            memory: 1024Mi
          requests:
            cpu: 100m
            memory: 128Mi
        statusPort: 15020
        tracer: zipkin
      proxy_init:
        image: proxyv2
      sds:
        token:
          aud: istio-ca
      sts:
        servicePort: 0
      tracer:
        datadog: {}
        lightstep: {}
        stackdriver: {}
        zipkin: {}
      useMCP: false
    istiodRemote:
      injectionURL: ""
    pilot:
      autoscaleEnabled: true
      autoscaleMax: 5
      autoscaleMin: 1
      configMap: true
      cpu:
        targetAverageUtilization: 80
      env: {}
      image: pilot
      keepaliveMaxServerConnectionAge: 30m
      nodeSelector: {}
      podLabels: {}
      replicaCount: 1
      traceSampling: 1
    telemetry:
      enabled: true
      v2:
        enabled: true
        metadataExchange:
          wasmEnabled: false
        prometheus:
          enabled: true
          wasmEnabled: false
        stackdriver:
          configOverride: {}
          enabled: false
          logging: false
          monitoring: false
          topology: false

$

$ $ ./istioctl manifest generate --set profile=default > default.yaml
$ kubectl apply -f default.yaml

customresourcedefinition.apiextensions.k8s.io/authorizationpolicies.security.istio.io
customresourcedefinition.apiextensions.k8s.io/destinationrules.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/envoyfilters.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/gateways.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/istiooperators.install.istio.io
customresourcedefinition.apiextensions.k8s.io/peerauthentications.security.istio.io
customresourcedefinition.apiextensions.k8s.io/proxyconfigs.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/requestauthentications.security.istio.io
customresourcedefinition.apiextensions.k8s.io/serviceentries.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/sidecars.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/telemetries.telemetry.istio.io
customresourcedefinition.apiextensions.k8s.io/virtualservices.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/wasmplugins.extensions.istio.io
customresourcedefinition.apiextensions.k8s.io/workloadentries.networking.istio.io
customresourcedefinition.apiextensions.k8s.io/workloadgroups.networking.istio.io

serviceaccount/istio-ingressgateway-service-account
serviceaccount/istio-reader-service-account
serviceaccount/istiod

clusterrole.rbac.authorization.k8s.io/istio-reader-clusterrole-istio-system
clusterrole.rbac.authorization.k8s.io/istiod-clusterrole-istio-system
clusterrole.rbac.authorization.k8s.io/istiod-gateway-controller-istio-system

clusterrolebinding.rbac.authorization.k8s.io/istio-reader-clusterrole-istio-system
clusterrolebinding.rbac.authorization.k8s.io/istiod-clusterrole-istio-system
clusterrolebinding.rbac.authorization.k8s.io/istiod-gateway-controller-istio-system

validatingwebhookconfiguration.admissionregistration.k8s.io/istio-validator-istio-system

configmap/istio
configmap/istio-sidecar-injector

mutatingwebhookconfiguration.admissionregistration.k8s.io/istio-sidecar-injector

deployment.apps/istio-ingressgateway
deployment.apps/istiod

poddisruptionbudget.policy/istio-ingressgateway
poddisruptionbudget.policy/istiod

role.rbac.authorization.k8s.io/istio-ingressgateway-sds
role.rbac.authorization.k8s.io/istiod

rolebinding.rbac.authorization.k8s.io/istio-ingressgateway-sds
rolebinding.rbac.authorization.k8s.io/istiod

horizontalpodautoscaler.autoscaling/istio-ingressgateway
horizontalpodautoscaler.autoscaling/istiod

service/istio-ingressgateway
service/istiod


$


```