## 1. PodSecurity Admission

Создан namespace `audit-zone` с уровнем `restricted`.

Проверены три нарушения:

- `privileged: true`
- `hostPath`
- `runAsUser: 0`

Все три Pod отклонены.

## 2. Безопасные Pod

Созданы три исправленных манифеста с настройками безопасности `restricted`.

## 3. OPA Gatekeeper

Подготовлены 3 `ConstraintTemplate` и 3 `Constraint` для проверки `privileged`, `hostPath`, `runAsNonRoot` и `readOnlyRootFilesystem`.

## 4. Проверка

```bash
./Task7/verify/verify-admission.sh
./Task7/verify/validate-security.sh
```
