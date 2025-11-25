# K8S Cluster

This is my second attempt to build a lightweight local Kubernetes cluster for personal, testing and learning purposes.

## Currently deployed apps:

- Cert Manager for managing TLS certificates
- MetalLB for LoadBalancer support
- Ingress-Nginx for Ingress support
- CNPG for PostgreSQL databases
- Longhorn for distributed block storage
- PiHole for network-wide ad blocking
- External DNS for managing DNS records
- Nextcloud for personal cloud storage
- Docker Registry for private container image storage
- Keycloak for identity and access management
- N8N for workflow automation
- FinAdmin for personal finance management

## ArgoCD

Check the [official documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for more details.

## Fin-Admin App

FinAdmin is designed to help me generate VAT documents for the Czech Financial Administration. To deploy the FinAdmin, follow these steps:

Create a namespace for FinAdmin:

```bash
kubectl create namespace fin-admin
```

Create a GitHub Personal Access Token (PAT) with `read:packages` scope and add it as a Kubernetes secret in the `fin-admin` namespace:

```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<your-github-username> \
  --docker-password=<your-github-personal-access-token> \
  --namespace=fin-admin
```

Create a configuration file named `application.yaml` with the necessary settings for Fin-Admin. Then, create a Kubernetes secret from this configuration file:

```bash
kubectl create secret generic fin-admin-config \
  --from-file=application.yaml=application.yaml \
  -n fin-admin
```

## Useful commands

To enable port forwarding for accessing the ArgoCD console:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

To retrieve the initial ArgoCD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```