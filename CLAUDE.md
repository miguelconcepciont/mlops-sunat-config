# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SUNAT MLOps Platform is a production-grade Kubernetes-based machine learning infrastructure supporting distributed computing, experiment tracking, multi-user collaboration, and model deployment. The platform is designed for both development (AKS) and production (SUNAT infrastructure) environments with comprehensive data validation and fault tolerance.

## Common Development Commands
  
### Deployment & Installation

```bash
# Full platform deployment (interactive setup)
./instalador.sh

# Update/upgrade existing deployment
./actualizador.sh

# Uninstall and clean up
./desinstalador.sh
```

### Configuration

```bash
# Copy templates to create editable config files
cp variables.txt.template variables.txt
find pv pvc storageclass values -name "*.yaml.template" -exec sh -c 'cp "$1" "${1%.template}"' _ {} \;

# List available Kubernetes contexts
kubectl config get-contexts

# Switch to target deployment context
kubectl config use-context <context-name>
```

### Kubernetes Operations

```bash
# Check overall platform status
kubectl get all -n jupyterhub
kubectl get all -n ray

# Monitor Ray cluster
kubectl get raycluster -n ray
kubectl get rayjob -n ray

# Port forwarding for local development
kubectl port-forward -n jupyterhub svc/jupyterhub 8000:80
kubectl port-forward -n mlflow svc/mlflow 5000:5000
kubectl port-forward -n minio svc/minio 9000:9000

# View pod logs
kubectl logs -n jupyterhub -l app=hub
kubectl logs -n ray -l ray.io/node-type=head
```

### Custom Library Development

```bash
# Build and install smartdeploymiguel library
cd libs/smartdeploymiguel
pip install -e .

# Run library tests
python -m pytest tests/

# Build distribution packages
python -m build
```

## Architecture Overview

### Core Components (Helm Charts)

**Compute & Experimentation:**
- **JupyterHub (3.3.8)**: Multi-user notebook gateway with configurable authentication
- **Ray Cluster (KubeRay 1.3.0)**: Distributed compute framework with head node + worker pool, Redis fault tolerance
- **MLflow (2.22.1)**: Experiment tracking, model registry, and artifact management

**Storage & Persistence:**
- **NFS Server (SUNAT: 172.26.60.13)**: Network filesystem backing all persistent volumes
  - Cluster-specific paths: `/bitnami/{clusterName}/hubdb`, `/bitnami/{clusterName}/postgresql`, etc.
- **PostgreSQL**: Two instances for JupyterHub metadata and MLflow tracking
- **MinIO**: S3-compatible object storage for artifacts and ML models

**Infrastructure Services:**
- **Traefik (v2.11.0)**: HTTP ingress controller routing to JupyterHub, MLflow, Ray
- **Jenkins (2.401.1)**: CI/CD orchestration for training and deployment pipelines
- **Redis**: Distributed state backend for Ray fault tolerance (environment-specific endpoints)

### Environment-Specific Configuration

**SUNAT Production/Test Environments:**
- Kubernetes contexts: `deploy-Mlops-prod01`, `deploy-Mlops-Test01`, `deploy-Mlops-User01-03`, etc.
- Central NFS server: 172.26.60.13
- Redis clusters per environment:
  - Production: 172.26.59.5
  - Test/Development: 172.26.59.7
  - User environments: 172.26.59.6
- Custom Docker images in Harbor registry: `vcf-np-w2-harbor-az1.sunat.peru/mlops/`

**AKS Development (Azure Kubernetes Service):**
- Dynamic provisioning using CSI NFS driver
- Local NFS server (10.99.208.199)
- Container images from public registries (quay.io, docker.io, registry.k8s.io)

### Storage Architecture

```
PersistentVolume → NFS Server → /bitnami/{clusterName}/{component}/data
     ↓
PersistentVolumeClaim → StorageClass → Pod mounts
```

**Static PVs (Manual allocation):** Hub database, PostgreSQL, MinIO, Jenkins, User data
**Dynamic PVs (CSI NFS Provisioning):** JupyterHub user notebooks, additional storage

### Configuration Management

**variables.txt** (80+ variables):
- Image registries and versions for all components
- NFS server endpoints and data paths per environment
- Redis connection details (host, password)
- Memory/CPU allocations (Ray head/workers: 6G in SUNAT, 4G in AKS)

**Helm Values Templates** (values/*.yaml.template):
- `config-ray.yaml`: Ray cluster specs, fault tolerance, scheduling
- `config-jupyterhub.yaml`: User spawner config, authenticators, admin users
- `config-mlflow.yaml`: Tracking server, artifact backend (PostgreSQL + MinIO)
- `config-postgresql.yaml` (×2): Database initialization, persistence
- `config-minio.yaml`: Bucket setup, access credentials
- Others: KubeRay operator, CSI driver, network policies

### Custom Libraries

**smartdeploymiguel** (libs/smartdeploymiguel/):
- Data validation gates using Deepchecks (integrity, drift detection)
- Decorator patterns for enforcing validation before deployment
- MLflow integration for logging validation results
- Located: `libs/smartdeploymiguel/smartdeploymiguel.py`

### Custom Docker Images

**Ray Image** (images/miguelsff/ray-2.41.0-sunat/):
- Based on Ray 2.41.0 with Python 3.11
- Includes: PyTorch 2.9.0, TensorFlow 2.20.0, scikit-learn, XGBoost, LightGBM
- Advanced: Transformers 4.57.1, LangChain 1.0.2, SHAP, LIME
- Build: `docker build -t miguelsff/ray:2.41.0-py311-sunat-v8 .`

**Scipy-Notebook Image** (images/miguelsff/scipy-notebook-python-3.11-sunat/):
- JupyterLab with Elyra (visual ML pipeline editor), Apache Toree (Spark kernel)
- Complete data science stack: Pandas 2.2.3, Polars 1.34.0, Dask 2025.10.0
- Visualization: Matplotlib, Seaborn, WordCloud, SHAP plots
- Build: `docker build -t miguelsff/scipy-notebook:python-3.11-sunat-v9 .`

## Deployment Flow

1. **Template Restoration**: Copy `.template` files and substitute environment variables
2. **Context Detection**: Identify Kubernetes context (AKS vs SUNAT deployment)
3. **Storage Setup**: Install CSI NFS driver → Create StorageClass → Allocate PVs/PVCs
4. **Database Layer**: Deploy PostgreSQL (×2) with persistent volumes
5. **JupyterHub**: Deploy hub with user spawner configuration
6. **Object Storage**: Deploy MinIO with S3 bucket initialization
7. **ML Tracking**: Deploy MLflow server linked to PostgreSQL + MinIO
8. **Compute**: Deploy KubeRay Operator → Deploy Ray cluster with Redis
9. **Port Forwarding**: Setup local access for development (minikube/AKS)

## Key File Locations

| Component | Location |
|-----------|----------|
| Deployment Scripts | `/instalador.sh`, `/actualizador.sh`, `/desinstalador.sh` |
| Configuration Templates | `/variables.txt.template`, `/values/*.yaml.template` |
| Helm Charts | `/charts/` (ray-cluster-1.3.0/, jupyterhub, mlflow, etc.) |
| Custom Library | `/libs/smartdeploymiguel/` |
| Custom Images | `/images/miguelsff/` (ray-*, scipy-notebook-*) |
| Kubernetes Resources | `/pv/`, `/pvc/`, `/storageclass/`, `/crds/` |
| Infrastructure Services | `/servers/nfs/`, `/servers/redis/` |
| Documentation | `/docs/` (install, features, production, recovery) |
| Examples | `/examples/` (iris, custom-v1/v2, simple pipelines) |

## Important Implementation Details

### Environment Variables & Substitution

The `instalador.sh` script uses sed to substitute template variables:
- `${clusterName}`: Auto-detected from kubectl context
- `${redisHost}` and `${redisPassword}`: Environment-specific (hardcoded per context)
- All 80 variables in `variables.txt` are substituted into YAML templates

### Ray Cluster Fault Tolerance

Ray uses Redis as a distributed state backend:
- Head node writes job metadata to Redis
- Worker nodes read/update state from Redis
- Pod eviction doesn't cause job loss (state persists in Redis)
- Configuration: `gcsFaultToleranceOptions` in RayCluster resource

### JupyterHub User Isolation

Each user gets:
- Isolated notebook pod in `jupyterhub` namespace
- Home directory mounted from NFS at `/home/{username}`
- Environment variables for Ray cluster address and MLflow tracking URI
- Automatic cleanup on session termination

### Storage Initialization

**PersistentVolumes** use:
- Static provisioning (manual allocation on NFS server)
- WaitForFirstConsumer binding mode (volume allocated on first pod request)
- Node affinity to NFS-connected nodes

**StorageClass** options:
- `nfs-storage`: General-purpose NFS provisioning (CSI driver)
- `nfs-csi-jupyterhub-sc`: JupyterHub notebook-specific dynamic provisioning
- `local-path-jupyterhub-sc`: Fallback local storage option

## Troubleshooting Reference

### Debugging NFS Mounting Issues

```bash
# Check NFS export on SUNAT server
showmount -e 172.26.60.13

# Test NFS mount from pod
kubectl run nfs-test --image=busybox --overrides='{"spec":{"containers":[{"name":"busybox","command":["sleep","3600"]}]}}'
kubectl exec nfs-test -- mount | grep nfs
```

### Monitoring Ray Cluster

```bash
# Ray dashboard (if exposed)
kubectl port-forward -n ray svc/ray-head 8265:8265

# Ray job submission
kubectl apply -f examples/iris/ray-job.yaml
kubectl get rayjob -n ray -w
```

### MLflow Artifact Issues

```bash
# Verify MinIO connectivity
kubectl run minio-test --image=minio/mc --command -- /bin/sh -c "sleep 3600"
kubectl exec minio-test -- mc ls minio/mlflow-artifacts
```

## Version Pinning

Critical versions are pinned for reproducibility:
- Ray: 2.41.0-py311-sunat-v8
- JupyterHub: 3.3.8
- MLflow: 2.22.1
- PostgreSQL: latest (via Harbor registry tag)
- KubeRay Operator: v1.3.0

Image version updates require:
1. Modifying `variables.txt` version variables
2. Regenerating config files from templates
3. Re-running `instalador.sh` or `actualizador.sh`

## Testing & Validation Examples

See `/examples/` directory:
- **iris/**: Classic dataset with train → deploy → test workflow
- **custom-v1/**: Code-based model deployment pattern
- **custom-v2/**: Serialized model deployment pattern
- Each example includes: `.ipynb` notebooks, deployment configs, test harnesses

