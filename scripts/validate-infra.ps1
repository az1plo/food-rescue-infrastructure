$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

function Require-Command {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found in PATH."
    }
}

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Label,
        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Write-Host ""
    Write-Host "==> $Label"
    & $Action
}

Require-Command terraform
Require-Command helm
Require-Command kubeconform
Require-Command pre-commit

Push-Location $repoRoot
try {
    Invoke-Step "Terraform fmt" {
        & terraform fmt -check -recursive terraform
    }

    $terraformProjects = Get-ChildItem "$repoRoot/terraform" -Directory | Sort-Object Name
    foreach ($project in $terraformProjects) {
        Invoke-Step "Terraform validate [$($project.Name)]" {
            & terraform "-chdir=$($project.FullName)" init -backend=false -input=false -no-color
            & terraform "-chdir=$($project.FullName)" validate -no-color
        }
    }

    Invoke-Step "YAML syntax validation" {
        & pre-commit run check-yaml --all-files
    }

    $workloadManifests = Get-ChildItem "$repoRoot/kubernetes/workload" -Recurse -File |
        Where-Object { $_.Extension -in ".yaml", ".yml" } |
        Sort-Object FullName

    foreach ($manifest in $workloadManifests) {
        Invoke-Step "kubeconform [$($manifest.FullName.Replace($repoRoot + '\', ''))]" {
            & kubeconform -strict -summary -ignore-missing-schemas $manifest.FullName
        }
    }

    Invoke-Step "Helm lint [gitlab local chart]" {
        & helm lint "$repoRoot/kubernetes/helm/helm-charts/gitlab/1.0.0"
    }

    Write-Host ""
    Write-Host "Infrastructure validation completed successfully."
}
finally {
    Pop-Location
}
