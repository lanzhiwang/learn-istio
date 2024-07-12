#!/usr/bin/env bash

# kubectl get crd | grep istio | awk -F ' ' '{print($1)}'
# kubectl get crd | grep asm | awk -F ' ' '{print($1)}'

crds=(
	# networking.istio.io
	gateways.networking.istio.io
	virtualservices.networking.istio.io
	destinationrules.networking.istio.io
	serviceentries.networking.istio.io
	envoyfilters.networking.istio.io
	proxyconfigs.networking.istio.io
	sidecars.networking.istio.io
	workloadentries.networking.istio.io
	workloadgroups.networking.istio.io
	# security.istio.io
	authorizationpolicies.security.istio.io
	peerauthentications.security.istio.io
	requestauthentications.security.istio.io
	# telemetry.istio.io
	telemetries.telemetry.istio.io
	# extensions.istio.io
	wasmplugins.extensions.istio.io
	# install.istio.io
	istiooperators.install.istio.io

)

for i in "${!crds[@]}"; do
	printf '%s\n' "${crds[i]}"
	echo "******************** ${crds[i]} ********************"
	kubectl get ${crds[i]} -A
	echo ""

done
