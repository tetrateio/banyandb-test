# Template to create a KUBECONFIG file for a newly created cluster
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${ca_data}
    server: ${endpoint}
  name: ${name}
contexts:
- context:
    cluster: ${name}
    user: ${name}
  name: ${name}
current-context: ${name}
kind: Config
preferences: {}
users:
- name: ${name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1
      interactiveMode: IfAvailable
      args:
      - --region
      - ${region}
      - eks
      - get-token
      - --cluster-name
      - ${name}
      command: aws
