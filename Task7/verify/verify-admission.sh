#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

for file in insecure-manifests/*.yaml; do
  echo "Проверка: $file"

  if kubectl create --dry-run=server -f "$file" >/dev/null 2>&1; then
    echo "FAIL: небезопасный Pod разрешён"
    exit 1
  else
    echo "PASS: небезопасный Pod отклонён"
  fi
done

echo "Все небезопасные Pod отклонены"
