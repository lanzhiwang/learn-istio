```bash

##########################################################################################

$ ./istioctl --help
Istio configuration command line utility for service operators to
debug and diagnose their Istio mesh.
Istio 配置命令行实用程序，供服务运营商调试和诊断其 Istio 网格。

Usage:
  istioctl [command]

Available Commands:
  # done
  admin                Manage control plane (istiod) configuration
                       istiod 就是镜像 docker.io/istio/pilot 运行出来的

  # done
  analyze              Analyze Istio configuration and print validation messages

  authz                (authz is experimental. Use `istioctl experimental authz`)
                       authz 是实验性的。使用“istioctl experiments authz”

  bug-report           Cluster information and log capture support tool.

  completion           Generate the autocompletion script for the specified shell

  create-remote-secret Create a secret with credentials to allow Istio to access remote Kubernetes apiservers

  dashboard            Access to Istio web UIs

  # done
  experimental         Experimental commands that may be modified or deprecated
                       可能被修改或弃用的实验性命令

  # done
  help                 Help about any command

  # done
  install              Applies an Istio manifest, installing or reconfiguring Istio on a cluster.

  kube-inject          Inject Istio sidecar into Kubernetes pod resources

  # done
  manifest             Commands related to Istio manifests

  # done
  operator             Commands related to Istio operator controller.

  # done
  profile              Commands related to Istio configuration profiles # done

  # done
  proxy-config         Retrieve information about proxy configuration from Envoy [kube only]
                       从 Envoy 检索有关代理配置的信息 [仅限 kube]

  # done
  proxy-status         Retrieves the synchronization status of each Envoy in the mesh [kube only]
                       检索网格中每个 Envoy 的同步状态[仅限 kube]

  # done
  remote-clusters      Lists the remote clusters each istiod instance is connected to.

  tag                  Command group used to interact with revision tags
                       用于与修订标签交互的命令组

  uninstall            Uninstall Istio from a cluster

  upgrade              Upgrade Istio control plane in-place

  validate             Validate Istio policy and rules files

  verify-install       Verifies Istio Installation Status

  # done
  version              Prints out build version information

Flags:
      --context string          The name of the kubeconfig context to use
  -h, --help                    help for istioctl
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Config namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Additional help topics:
  istioctl options                           Displays istioctl global options

Use "istioctl [command] --help" for more information about a command.
$

##########################################################################################

$ ./istioctl options
The following options can be passed to any command:

      --log_as_json: Whether to format output as JSON or in plain console-friendly format

      --log_caller: Comma-separated list of scopes for which to include caller information, scopes can be any of [ads, adsc, all, analysis, authn, authorization, ca, cli, controllers, default, delta, file, gateway, grpcgen, installer, klog, kube, model, patch, processing, proxyconfig, retry, security, serviceentry, spiffe, status, telemetry, tpath, translator, trustBundle, util, validation, wasm, wle]
      包含调用者信息的范围的逗号分隔列表，范围可以是以下任意一项：

      --log_output_level: Comma-separated minimum per-scope logging level of messages to output, in the form of <scope>:<level>,<scope>:<level>,... where scope can be one of [ads, adsc, all, analysis, authn, authorization, ca, cli, controllers, default, delta, file, gateway, grpcgen, installer, klog, kube, model, patch, processing, proxyconfig, retry, security, serviceentry, spiffe, status, telemetry, tpath, translator, trustBundle, util, validation, wasm, wle] and level can be one of [debug, info, warn, error, fatal, none]
      要输出的每个范围的最小日志记录级别消息以逗号分隔，格式为 <scope>:<level>,<scope>:<level>,...，其中 scope 可以是 [ads、adsc、...、wle] 之一，level 可以是 [debug、info、warn、error、fatal、none] 之一

      --log_stacktrace_level: Comma-separated minimum per-scope logging level at which stack traces are captured, in the form of <scope>:<level>,<scope:level>,... where scope can be one of [ads, adsc, all, analysis, authn, authorization, ca, cli, controllers, default, delta, file, gateway, grpcgen, installer, klog, kube, model, patch, processing, proxyconfig, retry, security, serviceentry, spiffe, status, telemetry, tpath, translator, trustBundle, util, validation, wasm, wle] and level can be one of [debug, info, warn, error, fatal, none]

      --log_target: The set of paths where to output the log. This can be any path as well as the special values stdout and stderr
      输出日志的路径集。这可以是任何路径，也可以是特殊值 stdout 和 stderr

$

##########################################################################################

$ ./istioctl profile --help
The profile command lists, dumps or diffs Istio configuration profiles.

Usage:
  istioctl profile [command]

Examples:
istioctl profile list
istioctl install --set profile=demo  # Use a profile from the list

Available Commands:
  diff        Diffs two Istio configuration profiles
  dump        Dumps an Istio configuration profile
  list        Lists available Istio configuration profiles

Flags:
      --dry-run   Console/log output only, make no changes.
  -h, --help      help for profile

Global Flags:
      --context string      The name of the kubeconfig context to use
  -c, --kubeconfig string   Kubernetes configuration file
      --vklog Level         number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl profile [command] --help" for more information about a command.
$

##########################################################################################

$ ./istioctl manifest --help
The manifest command generates and diffs Istio manifests.

Usage:
  istioctl manifest [command]

Available Commands:
  diff        Compare manifests and generate diff
  generate    Generates an Istio install manifest
  install     Applies an Istio manifest, installing or reconfiguring Istio on a cluster.

Flags:
      --dry-run   Console/log output only, make no changes.
  -h, --help      help for manifest

Global Flags:
      --context string      The name of the kubeconfig context to use
  -c, --kubeconfig string   Kubernetes configuration file
      --vklog Level         number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl manifest [command] --help" for more information about a command.
$

##########################################################################################

$ ./istioctl install --help
The install command generates an Istio install manifest and applies it to a cluster.

Usage:
  istioctl install [flags]

Aliases:
  install, apply

Examples:
  # Apply a default Istio installation
  istioctl install

  # Enable Tracing
  istioctl install --set meshConfig.enableTracing=true

  # Generate the demo profile and don't wait for confirmation
  istioctl install --set profile=demo --skip-confirmation

  # To override a setting that includes dots, escape them with a backslash (\).  Your shell may require enclosing quotes.
  istioctl install --set "values.sidecarInjectorWebhook.injectedAnnotations.container\.apparmor\.security\.beta\.kubernetes\.io/istio-proxy=runtime/default"

  # For setting boolean-string option, it should be enclosed quotes and escaped with a backslash (\).
  istioctl install --set meshConfig.defaultConfig.proxyMetadata.PROXY_XDS_VIA_AGENT=\"false\"


Flags:
      --dry-run                      Console/log output only, make no changes.
  -f, --filename strings             Path to file containing IstioOperator custom resource
                                     This flag can be specified multiple times to overlay multiple files. Multiple files are overlaid in left to right order.
      --force                        Proceed even with validation errors.
  -h, --help                         help for install
  -d, --manifests string             Specify a path to a directory of charts and profiles
                                     (e.g. ~/Downloads/istio-1.16.0/manifests)
                                     or release tar URL (e.g. https://github.com/istio/istio/releases/download/1.16.0/istio-1.16.0-linux-amd64.tar.gz).

      --readiness-timeout duration   Maximum time to wait for Istio resources in each component to be ready. (default 5m0s)
  -r, --revision string              Target control plane revision for the command.
  -s, --set stringArray              Override an IstioOperator value, e.g. to choose a profile
                                     (--set profile=demo), enable or disable components (--set components.cni.enabled=true), or override Istio
                                     settings (--set meshConfig.enableTracing=true). See documentation for more info:https://istio.io/v1.16/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec
  -y, --skip-confirmation            The skipConfirmation determines whether the user is prompted for confirmation.
                                     If set to true, the user is not prompted and a Yes response is assumed in all cases.
      --verify                       Verify the Istio control plane after installation/in-place upgrade

Global Flags:
      --context string      The name of the kubeconfig context to use
  -c, --kubeconfig string   Kubernetes configuration file
      --vklog Level         number for the log level verbosity. Like -v flag. ex: --vklog=9
$

##########################################################################################

$ ./istioctl operator --help
The operator command installs, dumps, removes and shows the status of the operator controller.

Usage:
  istioctl operator [command]

Available Commands:
  dump        Dumps the Istio operator controller manifest.
  init        Installs the Istio operator controller in the cluster.
  remove      Removes the Istio operator controller from the cluster.

Flags:
  -h, --help   help for operator

Global Flags:
      --context string      The name of the kubeconfig context to use
  -c, --kubeconfig string   Kubernetes configuration file
      --vklog Level         number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl operator [command] --help" for more information about a command.
$

##########################################################################################

$ ./istioctl remote-clusters --help
Lists the remote clusters each istiod instance is connected to.

Usage:
  istioctl experimental remote-clusters [flags]

Flags:
  -h, --help              help for remote-clusters
  -r, --revision string   Control plane revision

Global Flags:
      --context string          The name of the kubeconfig context to use
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Config namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

$ ./istioctl remote-clusters
NAME     SECRET     STATUS     ISTIOD

$ ./istioctl experimental remote-clusters --vklog=9
NAME     SECRET     STATUS     ISTIOD
$

##########################################################################################

$ ./istioctl admin --help
A group of commands used to manage istiod configuration

Usage:
  istioctl admin [flags]
  istioctl admin [command]

Aliases:
  admin, istiod

Examples:
  # Retrieve information about istiod configuration.
  istioctl admin log

Available Commands:
  log         Manage istiod logging.

Flags:
  -h, --help              help for admin
  -l, --selector string   label selector (default "app=istiod")

Global Flags:
      --context string          The name of the kubeconfig context to use
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Config namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl admin [command] --help" for more information about a command.

$ ./istioctl admin log
$ ./istioctl admin log --vklog=9
$

##########################################################################################

$ ./istioctl proxy-status --help

Retrieves last sent and last acknowledged xDS sync from Istiod to each Envoy in the mesh

Usage:
  istioctl proxy-status [<type>/]<name>[.<namespace>] [flags]

Aliases:
  proxy-status, ps

Examples:
  # Retrieve sync status for all Envoys in a mesh
  istioctl proxy-status

  # Retrieve sync diff for a single Envoy and Istiod
  istioctl proxy-status istio-egressgateway-59585c5b9c-ndc59.istio-system

  # Retrieve sync diff between Istiod and one pod under a deployment
  istioctl proxy-status deployment/productpage-v1

  # Write proxy config-dump to file, and compare to Istio control plane
  kubectl port-forward -n istio-system istio-egressgateway-59585c5b9c-ndc59 15000 &
  curl localhost:15000/config_dump > cd.json
  istioctl proxy-status istio-egressgateway-59585c5b9c-ndc59.istio-system --file cd.json


Flags:
  -f, --file string       Envoy config dump JSON file
  -h, --help              help for proxy-status
  -r, --revision string   Control plane revision

Global Flags:
      --context string          The name of the kubeconfig context to use
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Config namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9
$

$ ./istioctl proxy-status
NAME
CLUSTER
CDS
LDS
EDS
RDS
ECDS
ISTIOD
VERSION

cache-server-7bcfbd6b44-4j8dx.kubeflow
mlops-dev
STALE
STALE
STALE
STALE
NOT SENT
istiod-1-16-6fb598dcc5-98n6j
1.16.1-v3.14.14

cluster-local-gateway-6c874c595d-7wmql.istio-system
mlops-dev
SYNCED
STALE
STALE
STALE
NOT SENT
istiod-1-16-6fb598dcc5-98n6j
1.16.1-v3.14.14

mlops-ingress-rpcbn-7cb766b45d-d85fz.istio-gateway
mlops-dev
SYNCED
SYNCED
SYNCED
SYNCED
NOT SENT
istiod-1-16-6fb598dcc5-98n6j
1.16.1-v3.14.14
$

$ kubectl -n kubeflow get pods cache-server-7bcfbd6b44-4j8dx
NAME                            READY   STATUS             RESTARTS      AGE
cache-server-7bcfbd6b44-4j8dx   1/2     ImagePullBackOff   8 (50d ago)   203d

$ kubectl -n istio-system get pods cluster-local-gateway-6c874c595d-7wmql
NAME                                     READY   STATUS    RESTARTS   AGE
cluster-local-gateway-6c874c595d-7wmql   1/1     Running   0          9d

$ kubectl -n istio-gateway get pods mlops-ingress-rpcbn-7cb766b45d-d85fz
NAME                                   READY   STATUS    RESTARTS      AGE
mlops-ingress-rpcbn-7cb766b45d-d85fz   1/1     Running   1 (28h ago)   2d2h
$

$ ./istioctl proxy-status centraldashboard-599b8f9856-x7g2w.kubeflow
Clusters Match
Listeners Match
Routes Match (RDS last loaded at Thu, 11 Jul 2024 11:23:04 CST)

$ ./istioctl proxy-status mlops-ingress-rpcbn-7cb766b45d-d85fz.istio-gateway
Clusters Match
Listeners Match
Routes Match (RDS last loaded at Wed, 10 Jul 2024 08:57:45 CST)
$

##########################################################################################

$ ./istioctl proxy-config --help
A group of commands used to retrieve information about proxy configuration from the Envoy config dump

Usage:
  istioctl proxy-config [command]

Aliases:
  proxy-config, pc

Examples:
  # Retrieve information about proxy configuration from an Envoy instance.
  istioctl proxy-config <clusters|listeners|routes|endpoints|bootstrap|log|secret> <pod-name[.namespace]>

Available Commands:
  all            Retrieves all configuration for the Envoy in the specified pod
  bootstrap      Retrieves bootstrap configuration for the Envoy in the specified pod
  cluster        Retrieves cluster configuration for the Envoy in the specified pod
  endpoint       Retrieves endpoint configuration for the Envoy in the specified pod
  listener       Retrieves listener configuration for the Envoy in the specified pod
  log            (experimental) Retrieves logging levels of the Envoy in the specified pod
  rootca-compare Compare ROOTCA values for the two given pods
  route          Retrieves route configuration for the Envoy in the specified pod
  secret         Retrieves secret configuration for the Envoy in the specified pod

Flags:
  -h, --help            help for proxy-config
  -o, --output string   Output format: one of json|yaml|short (default "short")

Global Flags:
      --context string          The name of the kubeconfig context to use
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Config namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl proxy-config [command] --help" for more information about a command.
$

##########################################################################################

$ ./istioctl experimental --help
Experimental commands that may be modified or deprecated

Usage:
  istioctl experimental [command]

Aliases:
  experimental, x, exp

Available Commands:
  add-to-mesh          Add workloads into Istio service mesh
  authz                Inspect Istio AuthorizationPolicy
  check-inject         Check the injection status or inject-ability of a given resource, explains why it is (or will be) injected or not
  config               Configure istioctl defaults
  create-remote-secret Create a secret with credentials to allow Istio to access remote Kubernetes apiservers
  describe             Describe resource and related Istio configuration
  envoy-stats          Retrieves Envoy metrics in the specified pod
  injector             List sidecar injector and sidecar versions
  internal-debug       Retrieves the debug information of istio
  kube-uninject        Uninject Envoy sidecar from Kubernetes pod resources
  metrics              Prints the metrics for the specified workload(s) when running in Kubernetes.
  precheck             Check whether Istio can safely be installed or upgrade
  proxy-status         Retrieves the synchronization status of each Envoy in the mesh
  remote-clusters      Lists the remote clusters each istiod instance is connected to.
  remove-from-mesh     Remove workloads from Istio service mesh
  revision             Provide insight into various revisions (istiod, gateways) installed in the cluster
  uninstall            Uninstall Istio from a cluster (uninstall has graduated. Use `istioctl uninstall`)
  version              Prints out build version information
  wait                 Wait for an Istio resource
  waypoint             Manage waypoint configuration
  workload             Commands to assist in configuring and deploying workloads running on VMs and other non-Kubernetes environments

Flags:
  -h, --help   help for experimental

Global Flags:
      --context string                The name of the kubeconfig context to use
  -i, --istioNamespace string         Istio system namespace (default "istio-system")
  -c, --kubeconfig string             Kubernetes configuration file
  -n, --namespace string              Config namespace
      --s2a_enable_appengine_dialer   If true, opportunistically use AppEngine-specific dialer to call S2A.
      --s2a_timeout duration          Timeout enforced on the connection to the S2A service for handshake. (default 3s)
      --vklog Level                   number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl experimental [command] --help" for more information about a command.
$

$ ./istioctl experimental describe --help
Describe resource and related Istio configuration

Usage:
  istioctl experimental describe [flags]
  istioctl experimental describe [command]

Aliases:
  describe, des

Available Commands:
  pod         Describe pods and their Istio configuration [kube-only]
  service     Describe services and their Istio configuration [kube-only]

Flags:
  -h, --help   help for describe

Global Flags:
      --context string                The name of the kubeconfig context to use
  -i, --istioNamespace string         Istio system namespace (default "istio-system")
  -c, --kubeconfig string             Kubernetes configuration file
  -n, --namespace string              Config namespace
      --s2a_enable_appengine_dialer   If true, opportunistically use AppEngine-specific dialer to call S2A.
      --s2a_timeout duration          Timeout enforced on the connection to the S2A service for handshake. (default 3s)
      --vklog Level                   number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl experimental describe [command] --help" for more information about a command.
$

$ ./istioctl experimental check-inject --help

Checks associated resources of the given resource, and running webhooks to examine whether the pod can be or will be injected or not.

Usage:
  istioctl experimental check-inject [<type>/]<name>[.<namespace>] [flags]

Examples:
	# Check the injection status of a pod
  istioctl experimental check-inject details-v1-fcff6c49c-kqnfk.test

  # Check the injection status of a pod under a deployment
  istioctl x check-inject deployment/details-v1

  # Check the injection status of a pod under a deployment in namespace test
  istioctl x check-inject deployment/details-v1 -n test

  # Check the injection status of label pairs in a specific namespace before actual injection
  istioctl x check-inject -n test -l app=helloworld,version=v1


Flags:
  -h, --help            help for check-inject
  -l, --labels string   Check namespace and label pairs injection status, split multiple labels by commas

Global Flags:
      --context string                The name of the kubeconfig context to use
  -i, --istioNamespace string         Istio system namespace (default "istio-system")
  -c, --kubeconfig string             Kubernetes configuration file
  -n, --namespace string              Config namespace
      --s2a_enable_appengine_dialer   If true, opportunistically use AppEngine-specific dialer to call S2A.
      --s2a_timeout duration          Timeout enforced on the connection to the S2A service for handshake. (default 3s)
      --vklog Level                   number for the log level verbosity. Like -v flag. ex: --vklog=9
$

##########################################################################################

$ ./istioctl analyze --help
Analyze Istio configuration and print validation messages

Usage:
  istioctl analyze <file>... [flags]

Examples:
  # Analyze the current live cluster
  istioctl analyze

  # Analyze the current live cluster for a specific revision
  istioctl analyze --revision 1-16

  # Analyze the current live cluster, simulating the effect of applying additional yaml files
  istioctl analyze a.yaml b.yaml my-app-config/

  # Analyze the current live cluster, simulating the effect of applying a directory of config recursively
  istioctl analyze --recursive my-istio-config/

  # Analyze yaml files without connecting to a live cluster
  istioctl analyze --use-kube=false a.yaml b.yaml my-app-config/

  # Analyze the current live cluster and suppress PodMissingProxy for pod mypod in namespace 'testing'.
  istioctl analyze -S "IST0103=Pod mypod.testing"

  # Analyze the current live cluster and suppress PodMissingProxy for all pods in namespace 'testing',
  # and suppress MisplacedAnnotation on deployment foobar in namespace default.
  istioctl analyze -S "IST0103=Pod *.testing" -S "IST0107=Deployment foobar.default"

  # List available analyzers
  istioctl analyze -L

Flags:
  -A, --all-namespaces            Analyze all namespaces
      --color                     Default true.  Disable with '=false' or set $TERM to dumb (default true)
      --failure-threshold Level   The severity level of analysis at which to set a non-zero exit code. Valid values: [Info Warning Error] (default Error)
  -h, --help                      help for analyze
      --ignore-unknown            Don't complain about un-parseable input documents, for cases where analyze should run only on k8s compliant inputs.
  -L, --list-analyzers            List the analyzers available to run. Suppresses normal execution.
      --meshConfigFile string     Overrides the mesh config values to use for analysis.
  -o, --output string             Output format: one of [log json yaml] (default "log")
      --output-threshold Level    The severity level of analysis at which to display messages. Valid values: [Info Warning Error] (default Info)
  -R, --recursive                 Process directory arguments recursively. Useful when you want to analyze related manifests organized within the same directory.
      --revision string           analyze a specific revision deployed. (default "default")
  -S, --suppress stringArray      Suppress reporting a message code on a specific resource. Values are supplied in the form <code>=<resource> (e.g. '--suppress "IST0102=DestinationRule primary-dr.default"'). Can be repeated. You can include the wildcard character '*' to support a partial match (e.g. '--suppress "IST0102=DestinationRule *.default" ).
      --timeout duration          The duration to wait before failing (default 30s)
  -k, --use-kube                  Use live Kubernetes cluster for analysis. Set --use-kube=false to analyze files only. (default true)
  -v, --verbose                   Enable verbose output

Global Flags:
      --context string                The name of the kubeconfig context to use
  -c, --kubeconfig string             Kubernetes configuration file
  -n, --namespace string              Config namespace
      --s2a_enable_appengine_dialer   If true, opportunistically use AppEngine-specific dialer to call S2A.
      --s2a_timeout duration          Timeout enforced on the connection to the S2A service for handshake. (default 3s)
      --vklog Level                   number for the log level verbosity. Like -v flag. ex: --vklog=9

$ ./istioctl analyze -A

##########################################################################################

##########################################################################################

##########################################################################################

##########################################################################################


##########################################################################################

##########################################################################################

##########################################################################################

##########################################################################################

##########################################################################################

##########################################################################################


##########################################################################################

##########################################################################################




```
