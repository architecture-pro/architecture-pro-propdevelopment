#!/bin/bash
set -e

kubectl create clusterrolebinding viewer-binding \
  --clusterrole=cluster-viewer \
  --serviceaccount=default:viewer-user

kubectl create rolebinding operator-binding \
  --role=cluster-operator \
  --serviceaccount=default:operator-user \
  --namespace=default

kubectl create rolebinding security-binding \
  --role=secret-manager \
  --serviceaccount=default:security-user \
  --namespace=default