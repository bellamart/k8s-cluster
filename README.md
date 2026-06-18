# K8S Cluster

This is my second attempt to build a lightweight local Kubernetes cluster for personal, testing and learning purposes.

## Currently deployed apps:

- Cert Manager for managing TLS certificates
- MetalLB for LoadBalancer support
- CNPG for PostgreSQL databases
- Longhorn for distributed block storage
- PiHole for network-wide ad blocking
- External DNS for managing DNS records
- Nextcloud for personal cloud storage
- Keycloak for identity and access management
- N8N for workflow automation
- IT Tools for various IT utilities
- Prometheus/Grafana for monitoring and alerting
- Redis for caching
- MinIO for S3-compatible object storage
- Forgejo for code hosting
- FinAdmin for personal finance management

## K3S installation

First node:

```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode "0644" --token pdZKhWJaqtqB --cluster-init --disable servicelb --disable local-storage
```

Other nodes:

```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode "0644" --token pdZKhWJaqtqB --cluster-init --disable servicelb --disable local-storage --server https://$FIRST_NODE_NAME:6443
```

## ArgoCD

Check the [official documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for more details.

This repo uses an "app-of-apps" bootstrap. Apply `bootstrap/argo-root.yaml` once to let ArgoCD manage the rest of the resources in this repository.

## Pi-hole adjustments

Add the following as a regex deny in the domains section:

```
^.*\.domain\.com$;querytype=HTTPS
```

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
kubectl create secret generic forgejo-admin-secret \
  --from-file=application.yaml=application.yaml \
  -n fin-admin
```

## Forgejo

Create a secret to configure the admin user:

```bash
kubectl create secret generic forgejo-admin-secret \
  --from-literal=username=<USERNAME> \
  --from-literal=password=<PASSWORD> \
  -n forgejo
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