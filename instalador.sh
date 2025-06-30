#!/bin/bash

variables_txt="variables.txt"
entorno=$(kubectl config current-context)
csiDriverNfs="csi-driver-nfs-4.11.0.tgz"

if [[ "$entorno" == *aks* ]]; then
  entorno="AKS"
else
  entorno="SUNAT"
  csiDriverNfs="csi-driver-nfs-4.11.0-sunat.tgz"
fi

# Leer cada línea del archivo
mapfile -t variables < "$variables_txt"

for variable in "${variables[@]}"; do
  echo "Linea: $variable"

  # Separar en partes por |
  IFS='|' read -r parte1 parte2 parte3 <<< "$variable"

  # Extraer los valores (después del :)
  variable_name="\${${parte1#*:}}"
  aks="${parte2#*:}"
  sunat="${parte3#*:}"

  # Seleccionar valor según entorno
  if [[ "$entorno" == "AKS" ]]; then
    valorvariable="$aks"
  else
    valorvariable="$sunat"
  fi

  echo "Reemplazando $variable_name por $valorvariable..."

  # Buscar y reemplazar en los .yaml de las carpetas indicadas
  find pv pvc storageclass values -type f -name "*.yaml" -exec sed -i "s|$variable_name|$valorvariable|g" {} +

done

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}1. Instalando NFS CSI Driver...${NC}"
helm upgrade --install csi-driver-nfs "charts/$csiDriverNfs" -n kube-system -f values/config-csi-driver-nfs.yaml

echo -e "${GREEN}2. Aplicando StorageClass...${NC}"
kubectl apply -f storageclass/nfs-storage-sc.yaml
kubectl apply -f storageclass/nfs-csi-jupyterhub-sc.yaml
sleep 5

echo -e "${GREEN}3. Creando PersistentVolumes...${NC}"
kubectl apply -f pv/
sleep 10

echo -e "${GREEN}4. Creando PersistentVolumeClaims...${NC}"
kubectl apply -f pvc/
sleep 10

echo -e "${GREEN}5. Eliminando CRDs anteriores de Ray...${NC}"
kubectl delete crd rayclusters.ray.io rayjobs.ray.io rayservices.ray.io --ignore-not-found
sleep 10

echo -e "${GREEN}6. Instalando PostgreSQL...${NC}"

helm upgrade --install postgresql charts/postgresql-11.9.11.tgz -f values/config-postgresql.yaml
sleep 10 && helm status postgresql

helm upgrade --install postgresql-jupyterhub charts/postgresql-11.9.11.tgz -f values/config-postgresql-jupyterhub.yaml
sleep 10 && helm status postgresql-jupyterhub

echo -e "${GREEN}7. Instalando JupyterHub...${NC}"
helm upgrade --install jupyterhub charts/jupyterhub-3.3.8.tgz -f values/config-jupyterhub.yaml
sleep 10 && helm status jupyterhub

echo -e "${GREEN}8. Instalando MinIO...${NC}"
helm upgrade --install minio charts/minio-11.10.9.tgz -f values/config-minio.yaml
sleep 10 && helm status minio

echo -e "${GREEN}9. Instalando MLflow...${NC}"
helm upgrade --install mlflow charts/mlflow-0.18.0.tgz -f values/config-mlflow.yaml
sleep 10 && helm status mlflow

echo -e "${GREEN}10. Instalando KubeRay Operator...${NC}"
helm upgrade --install kuberay-operator charts/kuberay-operator-1.3.0.tgz -f values/config-kuberay-operator.yaml
sleep 5

echo -e "${GREEN}11. Instalando Ray Cluster...${NC}"
helm upgrade --install raycluster charts/ray-cluster-1.3.0.tgz -f values/config-ray.yaml
sleep 10 && helm status raycluster

echo -e "${GREEN}✅ Instalación completa en $entorno.${NC}"
