#!/usr/bin/env bash

# kubectl get crd | grep istio | awk -F ' ' '{print($1)}'
# kubectl get crd | grep asm | awk -F ' ' '{print($1)}'

##################### networking.istio.io #####################
# gateways.networking.istio.io 已熟悉
# virtualservices.networking.istio.io 已熟悉
# destinationrules.networking.istio.io 已熟悉
# serviceentries.networking.istio.io 已熟悉
# envoyfilters.networking.istio.io 已熟悉
# proxyconfigs.networking.istio.io 已熟悉
# sidecars.networking.istio.io
# workloadentries.networking.istio.io
# workloadgroups.networking.istio.io
##################### security.istio.io #####################
# authorizationpolicies.security.istio.io 已熟悉
# peerauthentications.security.istio.io 已熟悉
# requestauthentications.security.istio.io 已熟悉
##################### telemetry.istio.io #####################
# telemetries.telemetry.istio.io
##################### extensions.istio.io #####################
# wasmplugins.extensions.istio.io
##################### install.istio.io #####################
# istiooperators.install.istio.io

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
