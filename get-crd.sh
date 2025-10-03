#!/usr/bin/env bash

# set -x

arr=($(kubectl get crd | awk '{ if ($1 != "NAME") print $1 }'))

# Just elements.
for element in "${arr[@]}"; do
    printf 'kubectl get %s -A\n' "$element"
    kubectl get "$element" -A
    printf '%s\n' "--------------------------------------------------"
done
