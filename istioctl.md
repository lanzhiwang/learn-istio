# istioctl

```bash
#######################################################################################################
$ ./istio-1.26.1/bin/istioctl help
Istio configuration command line utility for service operators to
debug and diagnose their Istio mesh.

Usage:
  istioctl [command]

Available Commands:
  admin                Manage control plane (istiod) configuration
  analyze              Analyze Istio configuration and print validation messages
  authz                (authz is experimental. Use `istioctl experimental authz`)
  bug-report           Cluster information and log capture support tool.
  completion           Generate the autocompletion script for the specified shell
  create-remote-secret Create a secret with credentials to allow Istio to access remote Kubernetes apiservers
  dashboard            Access to Istio web UIs
  experimental         Experimental commands that may be modified or deprecated
  help                 Help about any command
  install              Applies an Istio manifest, installing or reconfiguring Istio on a cluster.
  kube-inject          Inject Istio sidecar into Kubernetes pod resources
  manifest             Commands related to Istio manifests
  proxy-config         Retrieve information about proxy configuration from Envoy [kube only]
  proxy-status         Retrieves the synchronization status of each Envoy in the mesh
  remote-clusters      Lists the remote clusters each istiod instance is connected to.
  tag                  Command group used to interact with revision tags
  uninstall            Uninstall Istio from a cluster
  upgrade              Upgrade Istio control plane in-place
  validate             Validate Istio policy and rules files
  version              Prints out build version information
  waypoint             Manage waypoint configuration
  ztunnel-config       Update or retrieve current Ztunnel configuration.

Flags:
      --as string               Username to impersonate for the operation. User could be a regular user or a service account in a namespace
      --as-group stringArray    Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string           UID to impersonate for the operation.
      --context string          Kubernetes configuration context
  -h, --help                    help for istioctl
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Kubernetes namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Additional help topcis:
  istioctl options              Displays istioctl global options

Use "istioctl [command] --help" for more information about a command.
$
```

## istioctl proxy-config

```bash
#######################################################################################################
$ ./istio-1.26.1/bin/istioctl proxy-config --help
A group of commands used to retrieve information about proxy configuration from the Envoy config dump

Usage:
  istioctl proxy-config [command]

Aliases:
  proxy-config, pc

Examples:
  # Retrieve information about proxy configuration from an Envoy instance.
  istioctl proxy-config <clusters|listeners|routes|endpoints|ecds|bootstrap|log|secret> <pod-name[.namespace]>

Available Commands:
  all            Retrieves all configuration for the Envoy in the specified pod
  bootstrap      Retrieves bootstrap configuration for the Envoy in the specified pod
  cluster        Retrieves cluster configuration for the Envoy in the specified pod
  ecds           Retrieves typed extension configuration for the Envoy in the specified pod
  endpoint       Retrieves endpoint configuration for the Envoy in the specified pod
  listener       Retrieves listener configuration for the Envoy in the specified pod
  log            Retrieves logging levels of the Envoy in the specified pod
  rootca-compare Compare ROOTCA values for the two given pods
  route          Retrieves route configuration for the Envoy in the specified pod
  secret         Retrieves secret configuration for the Envoy in the specified pod

Flags:
  -h, --help                   help for proxy-config
  -o, --output string          Output format: one of json|yaml|short (default "short")
      --proxy-admin-port int   Envoy proxy admin port (default 15000)

Global Flags:
      --as string               Username to impersonate for the operation. User could be a regular user or a service account in a namespace
      --as-group stringArray    Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string           UID to impersonate for the operation.
      --context string          Kubernetes configuration context
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Kubernetes namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl proxy-config [command] --help" for more information about a command.
$
```

## istioctl proxy-status

```bash
#######################################################################################################
$ ./istio-1.26.1/bin/istioctl proxy-status --help

Retrieves last sent and last acknowledged xDS sync from Istiod to each Envoy in the mesh

Usage:
  istioctl proxy-status [<type>/]<name>[.<namespace>] [flags]

Aliases:
  proxy-status, ps

Examples:
  # Retrieve sync status for all Envoys in a mesh
  istioctl proxy-status

  # Retrieve sync status for Envoys in a specific namespace
  istioctl proxy-status --namespace foo

  # Retrieve sync diff for a single Envoy and Istiod
  istioctl proxy-status istio-egressgateway-59585c5b9c-ndc59.istio-system

  # SECURITY OPTIONS

  # Retrieve proxy status information directly from the control plane, using token security
  # (This is the usual way to get the proxy-status with an out-of-cluster control plane.)
  istioctl ps --xds-address istio.cloudprovider.example.com:15012

  # Retrieve proxy status information via Kubernetes config, using token security
  # (This is the usual way to get the proxy-status with an in-cluster control plane.)
  istioctl proxy-status

  # Retrieve proxy status information directly from the control plane, using RSA certificate security
  # (Certificates must be obtained before this step.  The --cert-dir flag lets istioctl bypass the Kubernetes API server.)
  istioctl ps --xds-address istio.example.com:15012 --cert-dir ~/.istio-certs

  # Retrieve proxy status information via XDS from specific control plane in multi-control plane in-cluster configuration
  # (Select a specific control plane in an in-cluster canary Istio configuration.)
  istioctl ps --xds-label istio.io/rev=default


Flags:
      --authority string     XDS Subject Alternative Name (for example istiod.istio-system.svc)
      --cert-dir string      XDS Endpoint certificate directory
  -f, --file string          Envoy config dump JSON file
  -h, --help                 help for proxy-status
      --insecure             Skip server certificate and domain verification. (NOT SECURE!)
      --plaintext            Use plain-text HTTP/2 when connecting to server (no TLS).
  -r, --revision string      Control plane revision
      --timeout duration     The duration to wait before failing (default 30s)
      --xds-address string   XDS Endpoint
      --xds-label string     Istiod pod label selector
      --xds-port int         Istiod pod port (default 15012)

Global Flags:
      --as string               Username to impersonate for the operation. User could be a regular user or a service account in a namespace
      --as-group stringArray    Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string           UID to impersonate for the operation.
      --context string          Kubernetes configuration context
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Kubernetes namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9
$
```

## istioctl admin

```bash
#######################################################################################################
$ ./istio-1.26.1/bin/istioctl admin --help
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
      --as string               Username to impersonate for the operation. User could be a regular user or a service account in a namespace
      --as-group stringArray    Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string           UID to impersonate for the operation.
      --context string          Kubernetes configuration context
  -i, --istioNamespace string   Istio system namespace (default "istio-system")
  -c, --kubeconfig string       Kubernetes configuration file
  -n, --namespace string        Kubernetes namespace
      --vklog Level             number for the log level verbosity. Like -v flag. ex: --vklog=9

Use "istioctl admin [command] --help" for more information about a command.
$
```
