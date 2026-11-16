#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

echo "Проверка PodSecurity Admission"
kubectl get namespace audit-zone \
  -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' \
  | grep -qx restricted

echo "Проверка безопасных Pod"
for file in secure-manifests/*.yaml; do
  kubectl apply --dry-run=server -f "$file"
done

echo "Проверка Gatekeeper"
kubectl rollout status deployment/gatekeeper-controller-manager \
  -n gatekeeper-system --timeout=30s

echo "Проверка ConstraintTemplate"
kubectl get constrainttemplate k8sdenyprivileged
kubectl get constrainttemplate k8sdenyhostpath
kubectl get constrainttemplate k8srequiresecurity

echo "Проверка Constraint"
for constraint in \
  k8sdenyprivileged/deny-privileged \
  k8sdenyhostpath/deny-hostpath \
  k8srequiresecurity/require-security
do
  kubectl get "$constraint" \
    -o jsonpath='{.spec.enforcementAction}' | grep -qx deny
done

echo "Проверки завершены"
