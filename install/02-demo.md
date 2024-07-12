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

$ ./istioctl profile dump demo
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  components:
    base:
      enabled: true
    cni:
      enabled: false
    egressGateways:
    - enabled: true
      k8s:
        resources:
          requests:
            cpu: 10m
            memory: 40Mi
      name: istio-egressgateway
    ingressGateways:
    - enabled: true
      k8s:
        resources:
          requests:
            cpu: 10m
            memory: 40Mi
        service:
          ports:
          - name: status-port
            port: 15021
            targetPort: 15021
          - name: http2
            port: 80
            targetPort: 8080
          - name: https
            port: 443
            targetPort: 8443
          - name: tcp
            port: 31400
            targetPort: 31400
          - name: tls
            port: 15443
            targetPort: 15443
      name: istio-ingressgateway
    istiodRemote:
      enabled: false
    pilot:
      enabled: true
      k8s:
        env:
        - name: PILOT_TRACE_SAMPLING
          value: "100"
        resources:
          requests:
            cpu: 10m
            memory: 100Mi
  hub: docker.io/istio
  meshConfig:
    accessLogFile: /dev/stdout
    defaultConfig:
      proxyMetadata: {}
    enablePrometheusMerge: true
    extensionProviders:
    - envoyOtelAls:
        port: 4317
        service: opentelemetry-collector.istio-system.svc.cluster.local
      name: otel
    - name: skywalking
      skywalking:
        port: 11800
        service: tracing.istio-system.svc.cluster.local
    - name: otel-tracing
      opentelemetry:
        port: 4317
        service: opentelemetry-collector.otel-collector.svc.cluster.local
  profile: demo
  tag: 1.19.0
  values:
    base:
      enableCRDTemplates: false
      validationURL: ""
    defaultRevision: ""
    gateways:
      istio-egressgateway:
        autoscaleEnabled: false
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
        autoscaleEnabled: false
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
            cpu: 10m
            memory: 40Mi
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
      autoscaleEnabled: false
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

$ ./istioctl manifest generate --set profile=demo > demo.yaml
$ kubectl apply -f demo.yaml

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

serviceaccount/istio-egressgateway-service-account
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

deployment.apps/istio-egressgateway
deployment.apps/istio-ingressgateway
deployment.apps/istiod

poddisruptionbudget.policy/istio-egressgateway
poddisruptionbudget.policy/istio-ingressgateway
poddisruptionbudget.policy/istiod

role.rbac.authorization.k8s.io/istio-egressgateway-sds
role.rbac.authorization.k8s.io/istio-ingressgateway-sds
role.rbac.authorization.k8s.io/istiod

rolebinding.rbac.authorization.k8s.io/istio-egressgateway-sds
rolebinding.rbac.authorization.k8s.io/istio-ingressgateway-sds
rolebinding.rbac.authorization.k8s.io/istiod

service/istio-egressgateway
service/istio-ingressgateway
service/istiod

$


$ kubectl -n istio-system get deploy istiod -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: istiod
  namespace: istio-system
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      istio: pilot
  strategy:
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        ambient.istio.io/redirection: disabled
        prometheus.io/port: "15014"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      creationTimestamp: null
      labels:
        app: istiod
        install.operator.istio.io/owning-resource: unknown
        istio: pilot
        istio.io/rev: default
        operator.istio.io/component: Pilot
        sidecar.istio.io/inject: "false"
    spec:
      containers:
      - args:
        - discovery
        - --monitoringAddr=:15014
        - --log_output_level=default:info
        - --domain
        - cluster.local
        - --keepaliveMaxServerConnectionAge
        - 30m
        env:
        - name: REVISION
          value: default
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.serviceAccountName
        - name: KUBECONFIG
          value: /var/run/secrets/remote/config
        - name: PILOT_TRACE_SAMPLING
          value: "100"
        - name: ISTIOD_ADDR
          value: istiod.istio-system.svc:15012
        - name: PILOT_ENABLE_ANALYSIS
          value: "false"
        - name: CLUSTER_ID
          value: Kubernetes
        - name: GOMEMLIMIT
          valueFrom:
            resourceFieldRef:
              divisor: "0"
              resource: limits.memory
        - name: GOMAXPROCS
          valueFrom:
            resourceFieldRef:
              divisor: "0"
              resource: limits.cpu
        - name: PLATFORM
        image: docker.io/istio/pilot:1.19.0
        imagePullPolicy: IfNotPresent
        name: discovery
        ports:
        - containerPort: 8080
          protocol: TCP
        - containerPort: 15010
          protocol: TCP
        - containerPort: 15017
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /ready
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 1
          periodSeconds: 3
          successThreshold: 1
          timeoutSeconds: 5
        resources:
          requests:
            cpu: 10m
            memory: 100Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsGroup: 1337
          runAsNonRoot: true
          runAsUser: 1337
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/tokens
          name: istio-token
          readOnly: true
        - mountPath: /var/run/secrets/istio-dns
          name: local-certs
        - mountPath: /etc/cacerts
          name: cacerts
          readOnly: true
        - mountPath: /var/run/secrets/remote
          name: istio-kubeconfig
          readOnly: true
        - mountPath: /var/run/secrets/istiod/tls
          name: istio-csr-dns-cert
          readOnly: true
        - mountPath: /var/run/secrets/istiod/ca
          name: istio-csr-ca-configmap
          readOnly: true
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 1337
      serviceAccount: istiod
      serviceAccountName: istiod
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir:
          medium: Memory
        name: local-certs
      - name: istio-token
        projected:
          defaultMode: 420
          sources:
          - serviceAccountToken:
              audience: istio-ca
              expirationSeconds: 43200
              path: istio-token
      - name: cacerts
        secret:
          defaultMode: 420
          optional: true
          secretName: cacerts
      - name: istio-kubeconfig
        secret:
          defaultMode: 420
          optional: true
          secretName: istio-kubeconfig
      - name: istio-csr-dns-cert
        secret:
          defaultMode: 420
          optional: true
          secretName: istiod-tls
      - configMap:
          defaultMode: 420
          name: istio-ca-root-cert
          optional: true
        name: istio-csr-ca-configmap
$

$ kubectl -n istio-system get deploy istio-ingressgateway -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: istio-ingressgateway
  namespace: istio-system
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: istio-ingressgateway
      istio: ingressgateway
  strategy:
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        istio.io/rev: default
        prometheus.io/path: /stats/prometheus
        prometheus.io/port: "15020"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      creationTimestamp: null
      labels:
        app: istio-ingressgateway
        chart: gateways
        heritage: Tiller
        install.operator.istio.io/owning-resource: unknown
        istio: ingressgateway
        istio.io/rev: default
        operator.istio.io/component: IngressGateways
        release: istio
        service.istio.io/canonical-name: istio-ingressgateway
        service.istio.io/canonical-revision: latest
        sidecar.istio.io/inject: "false"
    spec:
      affinity:
        nodeAffinity: {}
      containers:
      - args:
        - proxy
        - router
        - --domain
        - $(POD_NAMESPACE).svc.cluster.local
        - --proxyLogLevel=warning
        - --proxyComponentLogLevel=misc:error
        - --log_output_level=default:info
        env:
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: CA_ADDR
          value: istiod.istio-system.svc:15012
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: INSTANCE_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        - name: HOST_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.hostIP
        - name: ISTIO_CPU_LIMIT
          valueFrom:
            resourceFieldRef:
              divisor: "0"
              resource: limits.cpu
        - name: SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.serviceAccountName
        - name: ISTIO_META_WORKLOAD_NAME
          value: istio-ingressgateway
        - name: ISTIO_META_OWNER
          value: kubernetes://apis/apps/v1/namespaces/istio-system/deployments/istio-ingressgateway
        - name: ISTIO_META_MESH_ID
          value: cluster.local
        - name: TRUST_DOMAIN
          value: cluster.local
        - name: ISTIO_META_UNPRIVILEGED_POD
          value: "true"
        - name: ISTIO_META_CLUSTER_ID
          value: Kubernetes
        - name: ISTIO_META_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        image: docker.io/istio/proxyv2:1.19.0
        imagePullPolicy: IfNotPresent
        name: istio-proxy
        ports:
        - containerPort: 15021
          protocol: TCP
        - containerPort: 8080
          protocol: TCP
        - containerPort: 8443
          protocol: TCP
        - containerPort: 31400
          protocol: TCP
        - containerPort: 15443
          protocol: TCP
        - containerPort: 15090
          name: http-envoy-prom
          protocol: TCP
        readinessProbe:
          failureThreshold: 30
          httpGet:
            path: /healthz/ready
            port: 15021
            scheme: HTTP
          initialDelaySeconds: 1
          periodSeconds: 2
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          limits:
            cpu: "2"
            memory: 1Gi
          requests:
            cpu: 10m
            memory: 40Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          privileged: false
          readOnlyRootFilesystem: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/workload-spiffe-uds
          name: workload-socket
        - mountPath: /var/run/secrets/credential-uds
          name: credential-socket
        - mountPath: /var/run/secrets/workload-spiffe-credentials
          name: workload-certs
        - mountPath: /etc/istio/proxy
          name: istio-envoy
        - mountPath: /etc/istio/config
          name: config-volume
        - mountPath: /var/run/secrets/istio
          name: istiod-ca-cert
        - mountPath: /var/run/secrets/tokens
          name: istio-token
          readOnly: true
        - mountPath: /var/lib/istio/data
          name: istio-data
        - mountPath: /etc/istio/pod
          name: podinfo
        - mountPath: /etc/istio/ingressgateway-certs
          name: ingressgateway-certs
          readOnly: true
        - mountPath: /etc/istio/ingressgateway-ca-certs
          name: ingressgateway-ca-certs
          readOnly: true
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 1337
        runAsGroup: 1337
        runAsNonRoot: true
        runAsUser: 1337
      serviceAccount: istio-ingressgateway-service-account
      serviceAccountName: istio-ingressgateway-service-account
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: workload-socket
      - emptyDir: {}
        name: credential-socket
      - emptyDir: {}
        name: workload-certs
      - configMap:
          defaultMode: 420
          name: istio-ca-root-cert
        name: istiod-ca-cert
      - downwardAPI:
          defaultMode: 420
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.labels
            path: labels
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.annotations
            path: annotations
        name: podinfo
      - emptyDir: {}
        name: istio-envoy
      - emptyDir: {}
        name: istio-data
      - name: istio-token
        projected:
          defaultMode: 420
          sources:
          - serviceAccountToken:
              audience: istio-ca
              expirationSeconds: 43200
              path: istio-token
      - configMap:
          defaultMode: 420
          name: istio
          optional: true
        name: config-volume
      - name: ingressgateway-certs
        secret:
          defaultMode: 420
          optional: true
          secretName: istio-ingressgateway-certs
      - name: ingressgateway-ca-certs
        secret:
          defaultMode: 420
          optional: true
          secretName: istio-ingressgateway-ca-certs
$


$ kubectl -n istio-system get deploy istio-egressgateway -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: istio-egressgateway
  namespace: istio-system
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: istio-egressgateway
      istio: egressgateway
  strategy:
    rollingUpdate:
      maxSurge: 100%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        istio.io/rev: default
        prometheus.io/path: /stats/prometheus
        prometheus.io/port: "15020"
        prometheus.io/scrape: "true"
        sidecar.istio.io/inject: "false"
      creationTimestamp: null
      labels:
        app: istio-egressgateway
        chart: gateways
        heritage: Tiller
        install.operator.istio.io/owning-resource: unknown
        istio: egressgateway
        istio.io/rev: default
        operator.istio.io/component: EgressGateways
        release: istio
        service.istio.io/canonical-name: istio-egressgateway
        service.istio.io/canonical-revision: latest
        sidecar.istio.io/inject: "false"
    spec:
      affinity:
        nodeAffinity: {}
      containers:
      - args:
        - proxy
        - router
        - --domain
        - $(POD_NAMESPACE).svc.cluster.local
        - --proxyLogLevel=warning
        - --proxyComponentLogLevel=misc:error
        - --log_output_level=default:info
        env:
        - name: JWT_POLICY
          value: third-party-jwt
        - name: PILOT_CERT_PROVIDER
          value: istiod
        - name: CA_ADDR
          value: istiod.istio-system.svc:15012
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: INSTANCE_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        - name: HOST_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.hostIP
        - name: ISTIO_CPU_LIMIT
          valueFrom:
            resourceFieldRef:
              divisor: "0"
              resource: limits.cpu
        - name: SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.serviceAccountName
        - name: ISTIO_META_WORKLOAD_NAME
          value: istio-egressgateway
        - name: ISTIO_META_OWNER
          value: kubernetes://apis/apps/v1/namespaces/istio-system/deployments/istio-egressgateway
        - name: ISTIO_META_MESH_ID
          value: cluster.local
        - name: TRUST_DOMAIN
          value: cluster.local
        - name: ISTIO_META_UNPRIVILEGED_POD
          value: "true"
        - name: ISTIO_META_CLUSTER_ID
          value: Kubernetes
        - name: ISTIO_META_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        image: docker.io/istio/proxyv2:1.19.0
        imagePullPolicy: IfNotPresent
        name: istio-proxy
        ports:
        - containerPort: 8080
          protocol: TCP
        - containerPort: 8443
          protocol: TCP
        - containerPort: 15090
          name: http-envoy-prom
          protocol: TCP
        readinessProbe:
          failureThreshold: 30
          httpGet:
            path: /healthz/ready
            port: 15021
            scheme: HTTP
          initialDelaySeconds: 1
          periodSeconds: 2
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          limits:
            cpu: "2"
            memory: 1Gi
          requests:
            cpu: 10m
            memory: 40Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          privileged: false
          readOnlyRootFilesystem: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/workload-spiffe-uds
          name: workload-socket
        - mountPath: /var/run/secrets/credential-uds
          name: credential-socket
        - mountPath: /var/run/secrets/workload-spiffe-credentials
          name: workload-certs
        - mountPath: /etc/istio/proxy
          name: istio-envoy
        - mountPath: /etc/istio/config
          name: config-volume
        - mountPath: /var/run/secrets/istio
          name: istiod-ca-cert
        - mountPath: /var/run/secrets/tokens
          name: istio-token
          readOnly: true
        - mountPath: /var/lib/istio/data
          name: istio-data
        - mountPath: /etc/istio/pod
          name: podinfo
        - mountPath: /etc/istio/egressgateway-certs
          name: egressgateway-certs
          readOnly: true
        - mountPath: /etc/istio/egressgateway-ca-certs
          name: egressgateway-ca-certs
          readOnly: true
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 1337
        runAsGroup: 1337
        runAsNonRoot: true
        runAsUser: 1337
      serviceAccount: istio-egressgateway-service-account
      serviceAccountName: istio-egressgateway-service-account
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: workload-socket
      - emptyDir: {}
        name: credential-socket
      - emptyDir: {}
        name: workload-certs
      - configMap:
          defaultMode: 420
          name: istio-ca-root-cert
        name: istiod-ca-cert
      - downwardAPI:
          defaultMode: 420
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.labels
            path: labels
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.annotations
            path: annotations
        name: podinfo
      - emptyDir: {}
        name: istio-envoy
      - emptyDir: {}
        name: istio-data
      - name: istio-token
        projected:
          defaultMode: 420
          sources:
          - serviceAccountToken:
              audience: istio-ca
              expirationSeconds: 43200
              path: istio-token
      - configMap:
          defaultMode: 420
          name: istio
          optional: true
        name: config-volume
      - name: egressgateway-certs
        secret:
          defaultMode: 420
          optional: true
          secretName: istio-egressgateway-certs
      - name: egressgateway-ca-certs
        secret:
          defaultMode: 420
          optional: true
          secretName: istio-egressgateway-ca-certs
$


$ kubectl -n istio-system get services istio-ingressgateway -o yaml
apiVersion: v1
kind: Service
metadata:
  name: istio-ingressgateway
  namespace: istio-system
spec:
  allocateLoadBalancerNodePorts: true
  clusterIP: 10.99.61.81
  clusterIPs:
  - 10.99.61.81
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: status-port
    nodePort: 31792
    port: 15021
    protocol: TCP
    targetPort: 15021
  - name: http2
    nodePort: 32157
    port: 80
    protocol: TCP
    targetPort: 8080
  - name: https
    nodePort: 32038
    port: 443
    protocol: TCP
    targetPort: 8443
  - name: tcp
    nodePort: 30895
    port: 31400
    protocol: TCP
    targetPort: 31400
  - name: tls
    nodePort: 32618
    port: 15443
    protocol: TCP
    targetPort: 15443
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  sessionAffinity: None
  type: LoadBalancer
$

$ kubectl -n istio-system get services istio-egressgateway -o yaml
apiVersion: v1
kind: Service
metadata:
  name: istio-egressgateway
  namespace: istio-system
spec:
  clusterIP: 10.101.173.22
  clusterIPs:
  - 10.101.173.22
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http2
    port: 80
    protocol: TCP
    targetPort: 8080
  - name: https
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    app: istio-egressgateway
    istio: egressgateway
  sessionAffinity: None
  type: ClusterIP
$

```
