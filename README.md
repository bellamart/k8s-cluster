# K8S Cluster

This is my second attempt to build a lightweight local Kubernetes cluster for personal, testing and learning purposes.

## Currently deployed apps:

- ArgoCD
- Cert Manager
- MetalLB
- Ingress-Nginx
- CNPG
- Longhorn
- PiHole
- External DNS
- Nextcloud
- Docker Registry

## Usefull commands

To enable port forwarding for accessing the ArgoCD console:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

To retrieve the initial ArgoCD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```