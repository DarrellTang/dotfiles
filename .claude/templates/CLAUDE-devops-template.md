# CLAUDE.md - DevOps Project Template

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

[Provide a brief 1-2 sentence description of the DevOps project]

**Project Type:** [Infrastructure as Code / GitOps / Multi-Cloud / Service Mesh / etc.]
**Primary Cloud:** [AWS / Azure / GCP / Multi-cloud]
**Key Technologies:** [e.g., Terraform, Kubernetes, ArgoCD, etc.]

## Architecture Overview

[Provide high-level architecture description. Include:
- How infrastructure is organized
- Multi-cluster or multi-region patterns if applicable
- Key components and their relationships]

**Diagram or structure:**
```
[ASCII diagram or directory structure showing key relationships]
```

## Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Infrastructure as Code | [Terraform/CDK/CloudFormation] | [Purpose] |
| Container Orchestration | [Kubernetes/ECS/etc] | [Purpose] |
| GitOps | [ArgoCD/Flux/etc] | [Purpose] |
| Service Mesh | [LinkerD/Istio/etc] | [Purpose] |
| Secrets Management | [Vault/Azure Key Vault/AWS Secrets Manager] | [Purpose] |

## Terraform Conventions

### Module Structure
- Use layered architecture with separate state files (for blast radius isolation)
- Layer naming: `01-networking/`, `02-kubernetes/`, `03-applications/`, etc.
- Each layer has its own `terraform.tfvars` or `*.auto.tfvars`
- Cross-layer references use `terraform_remote_state` data sources

### Best Practices
- Prefer verified modules:
  - **Azure:** Azure Verified Modules (AVM)
  - **AWS:** terraform-aws-modules
  - **GCP:** terraform-google-modules
- Pin module versions with pessimistic constraints (`~> X.Y`)
- Include clear comments explaining each resource
- Always test with `terraform validate` and `terraform fmt`

### Common Commands
```bash
terraform init
terraform validate
terraform fmt -recursive
terraform plan -out=tfplan
terraform apply tfplan
```

## Kubernetes Patterns

### Manifest Organization
- [Describe how K8s manifests are organized: by namespace, by feature, etc.]
- [Specify naming conventions for resources]

### Common Commands
```bash
kubectl get nodes
kubectl get pods -A
kubectl logs -f deployment/[name] -n [namespace]
kubectl apply -f [manifest]
```

## ArgoCD / GitOps Practices (if applicable)

### GitOps Workflow
- Source of truth: this repository (specific branch/path)
- ArgoCD automatically syncs declared state
- Enable automated sync with prune and selfHeal

### Common Commands
```bash
argocd app list
argocd app sync [app-name]
argocd app wait [app-name]
```

## Security & Secrets Management

### Secrets Strategy
- [Describe how secrets are managed: Vault, AWS Secrets Manager, etc.]
- [Describe how K8s ExternalSecrets or Sealed Secrets are configured]

## File Structure Reference

```
.
├── terraform/              # IaC root
│   ├── 01-networking/
│   ├── 02-kubernetes/
│   └── 03-applications/
├── k8s/                    # Kubernetes manifests
│   ├── bootstrap/
│   └── apps/
├── doc/                    # Documentation
└── CLAUDE.md              # This file
```

## Common DevOps Tasks

### Deploying Infrastructure
```bash
cd terraform/[layer]
terraform init && terraform plan && terraform apply
```

### Troubleshooting
```bash
kubectl describe pod [pod-name] -n [namespace]
kubectl logs [pod-name] -n [namespace]
argocd app get [app-name]
```

## Testing & Validation

### Pre-deployment Checks
- [ ] `terraform validate` passes
- [ ] `terraform plan` reviewed
- [ ] Kubernetes manifests valid: `kubectl apply --dry-run=client -f [file]`

### Post-deployment Validation
- [ ] All infrastructure resources created
- [ ] All Kubernetes nodes Ready
- [ ] All pods Running
- [ ] GitOps synced and healthy

## Naming Conventions

- Resources: `[project]-[component]-[identifier]`
- Kubernetes namespaces: `[tenant]`, `[feature]`, `system`

## Troubleshooting Guide

| Issue | Symptom | Resolution |
|-------|---------|-----------|
| [Common Issue 1] | [What it looks like] | [How to fix] |
| [Common Issue 2] | [What it looks like] | [How to fix] |

---

**Note:** See global `~/.claude/CLAUDE.md` for git commit and PR conventions.
