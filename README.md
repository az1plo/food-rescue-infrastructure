# Savr Platform Infrastructure

Infrastructure assets for the current Savr Platform deployment setup.

## Current scope

- Terraform stacks for shared Azure resources, networking, registry, AKS, PostgreSQL, DNS, and automation
- Kubernetes base manifests for backend and frontend workloads
- Helm values for cluster platform services such as ingress, cert-manager, GitLab, monitoring, logging, and Keycloak
- cookiecutter template support for academy-style infrastructure bootstrapping

## Repository structure

- `terraform` - layered Terraform stacks applied in sequence
- `kubernetes/workload` - application workload manifests for backend and frontend
- `kubernetes/helm/helm-values` - values used for platform chart deployments
- `cookiecutter` - reusable infrastructure template derived from the academy setup
- `scripts/validate-infra.ps1` - local validation entry point for Terraform, Kubernetes manifests, and Helm chart checks

## Validation flow

Run the infrastructure checks before deployment:

```powershell
./scripts/validate-infra.ps1
```

The validation flow covers:

- `terraform fmt -check -recursive terraform`
- `terraform init -backend=false` and `terraform validate` for every Terraform stack
- YAML syntax validation through `pre-commit run check-yaml --all-files`
- `kubeconform` schema validation for application workload manifests
- `helm lint` for the local GitLab chart

CI runs the same flow via `.github/workflows/validate-infra.yml`.

## Notes

- The repository still follows the academy-style split between Terraform and Kubernetes assets.
- Frontend and backend workload folders reflect the currently implemented product slice, including admin business approvals only.
- Frontend and backend workloads now use fixed baseline probes and resource profiles for the academy cluster.
