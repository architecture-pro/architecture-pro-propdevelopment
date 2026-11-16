#!/bin/bash
set -e

kubectl create clusterrole cluster-viewer \
  --verb=get,list,watch \
  --resource=pods,services,deployments.apps,nodes,namespaces

kubectl create role cluster-operator \
  --verb=get,list,watch,create,update,patch,delete \
  --resource=pods,services,deployments.apps \
  --namespace=default

kubectl create role secret-manager \
  --verb=get,list,watch,create,update,patch,delete \
  --resource=secrets \
  --namespace=default