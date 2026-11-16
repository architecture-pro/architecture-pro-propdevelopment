
import json

events = []

with open('audit.log', 'r') as file:
    for line in file:
        events.append(json.loads(line))

suspicious_ids = []

for event in events:
    obj = event.get('objectRef', {})
    resource = obj.get('resource')
    namespace = obj.get('namespace')
    name = obj.get('name')
    user = event.get('impersonatedUser', event.get('user', {})).get('username')

    if resource == 'secrets' and user == 'system:serviceaccount:secure-ops:monitoring':
        suspicious_ids.append(event['auditID'])

    if resource == 'pods' and namespace == 'secure-ops' and event.get('verb') == 'create':
        body = event.get('requestObject', {})
        containers = body.get('spec', {}).get('containers', [])

        for container in containers:
            if container.get('securityContext', {}).get('privileged') == True:
                suspicious_ids.append(event['auditID'])

    if resource == 'rolebindings' and name == 'escalate-binding' and event.get('verb') == 'create':
        suspicious_ids.append(event['auditID'])

    if resource == 'pods' and namespace == 'kube-system' and obj.get('subresource') == 'exec':
        suspicious_ids.append(event['auditID'])

result = []

for event in events:
    if event['auditID'] in suspicious_ids:
        result.append(event)

with open('audit-extract.json', 'w') as file:
    json.dump(result, file, indent=2)

print('Найдено записей:', len(result))
