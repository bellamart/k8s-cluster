# K8s Cluster

This is my second attempt to build a lightweight local Kubernetes cluster for personal use, testing, and learning.

## Currently deployed apps

- cert-manager for managing TLS certificates
- MetalLB for LoadBalancer support
- CNPG for PostgreSQL databases
- Longhorn for distributed block storage
- Pi-hole for network-wide ad blocking
- ExternalDNS for managing DNS records
- Nextcloud for personal cloud storage
- Keycloak for identity and access management
- n8n for workflow automation
- IT Tools for various IT utilities
- Prometheus/Grafana for monitoring and alerting
- Redis for caching
- MinIO for S3-compatible object storage (obsolete)
- Garage for S3-compatible object storage
- Forgejo for code hosting
- FinAdmin for personal finance management
- GPX Viewer for tracking personal trips
- Renovate for automated dependency updates
- Cloudflare for tunneling traffic

## K3s installation

First node:

```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode "0644" --token "$K3S_TOKEN" --cluster-init --disable servicelb --disable local-storage
```

Other nodes:

```bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode "0644" --token "$K3S_TOKEN" --cluster-init --disable servicelb --disable local-storage --server "https://$FIRST_NODE_NAME:6443"
```

## Argo CD

Check the [official documentation](https://argo-cd.readthedocs.io/en/stable/getting_started/) for more details.

This repository uses an "app-of-apps" bootstrap. Apply `bootstrap/argo-root.yaml` once to let Argo CD manage the remaining resources in the repository.

## Pi-hole adjustments

Add the following as a regex deny in the domains section:

```
^.*\.domain\.com$;querytype=HTTPS
```

## Useful commands for Garage S3 storage

Get the Garage status:

```bash
kubectl exec -it garage-0 -n garage -- /garage status
```

Perform layout operations:

```bash
kubectl exec -it garage-0 -n garage -- /garage layout assign -z "$ZONE" -c "$NODE_CAPACITY" "$NODE"
kubectl exec -it garage-0 -n garage -- /garage layout apply --version "$VERSION"
```

Create a bucket:

```bash
kubectl exec -it garage-0 -n garage -- /garage bucket create "$BUCKET_NAME"
```

Create an access key:

```bash
kubectl exec -it garage-0 -n garage -- /garage key create "$KEY_NAME"
```

Allow a key to access a bucket:

```bash
kubectl exec -it garage-0 -n garage -- /garage bucket allow --read --write "$BUCKET_NAME" --key "$KEY_NAME"
```

## Fin-Admin App

FinAdmin helps me generate VAT documents for the Czech Financial Administration. To deploy FinAdmin, follow these steps:

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

## GPX Viewer

Create a Kubernetes pull secret:

```bash
kubectl create secret docker-registry forgejo-registry-secret \
  --docker-server=forgejo.chrobacik.cloud \
  --docker-username=<your-github-username> \
  --docker-password=<your-github-personal-access-token> \
  --namespace=gpxviewer
```

Create a secret for the Mapy.com API key:

```bash
kubectl create secret generic mapy-secret \
  --from-literal=MAPY_COM_API_KEY=<your-api-key> \
  --namespace=gpxviewer
```

Create a secret for the S3 access key:

```bash
kubectl create secret generic s3-credentials \
  --from-literal=S3_ACCESS_KEY=<your-access-key> \
  --from-literal=S3_SECRET_KEY=<your-secret-key> \
  --namespace=gpxviewer
```

## Forgejo

Create a secret to configure the admin user:

```bash
kubectl create secret generic forgejo-admin-secret \
  --from-literal=username=<USERNAME> \
  --from-literal=password=<PASSWORD> \
  -n forgejo
```

Create a secret to configure the Forgejo runner:

```bash
kubectl -n forgejo create secret generic forgejo-runner-secret \
  --from-literal=uuid='<uuid-from-forgejo>' \
  --from-literal=token='<token-from-forgejo>' \
  --dry-run=client -o yaml | kubectl apply -f -
```

## Renovate

Create a Forgejo bot user with a full name and email, then create a Personal Access Token with:

- `repo` — Read and Write
- `user` — Read
- `issue` — Read and Write
- `organization` — Read

Create the Kubernetes secret (create the `renovate` namespace first if needed):

```bash
kubectl create namespace renovate
kubectl create secret generic renovate-env \
  --from-literal=RENOVATE_TOKEN=<your-forgejo-pat> \
  -n renovate
```

## Useful commands

To access the Argo CD console, enable port forwarding:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

To retrieve the initial Argo CD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Cloudflare tunnel:

Create 

```bash
kubectl create namespace cloudflare

kubectl create secret generic cloudflared-credentials \
  --from-literal=RENOVATE_TOKEN=<your-forgejo-pat> \
  -n renovate
```