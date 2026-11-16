#!/bin/bash
set -e

kubectl create serviceaccount viewer-user
kubectl create serviceaccount operator-user
kubectl create serviceaccount security-user