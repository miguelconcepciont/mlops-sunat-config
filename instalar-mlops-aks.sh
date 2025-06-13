#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

DAEMONSET_FILE="init-paths-daemonset.yaml"
PV_DIR="pv"
PVC_DIR="pvc"
CHART_DIR="charts"
VALUES_DIR="values"
STORAGECLASS_DIR="storageclass"
CRDS_DIR="crds"

echo -e "${GREEN}Obteniendo el primer nodo...${NC}"
NODE_NAME=$(kubectl get nodes --no-headers | awk 'NR==1 {print $1}')
echo -e "${YELLOW}Primer nodo detectado: ${NODE_NAME}${NC}"

echo -e "${GREEN}Reemplazando \${nodo1} por ${NODE_NAME} en PV y StorageClass...${NC}"
find "$PV_DIR" "$STORAGECLASS_DIR" -type f -name "*.yaml" -exec sed -i "s/\${nodo1}/$NODE_NAME/g" {} +

echo -e "${GREEN}1. Preparando carpetas con DaemonSet...${NC}"
kubectl delete daemonset init-paths -n kube-system --ignore-not-found
kubectl apply -f "$DAEMONSET_FILE"

echo -e "${YELLOW}Esperando ejecución del DaemonSet...${NC}"
sleep 15

echo -e "${GREEN}Mostrando logs por nodo:${NC}"
for pod in $(kubectl get pods -n kube-system -l name=init-paths -o name); do
  echo -e "\n--- Logs de $pod ---"
  kubectl logs -n kube-system "$pod"
done

echo -e "${GREEN}Eliminando DaemonSet...${NC}"
kubectl delete daemonset init-paths -n kube-system

echo -e "${GREEN}Aplicando StorageClass...${NC}"
kubectl apply -f "$STORAGECLASS_DIR/"
sleep 5

echo -e "${GREEN}2. Creando PersistentVolumes (PV)...${NC}"
kubectl apply -f "$PV_DIR/"
sleep 10

echo -e "${GREEN}3. Creando PersistentVolumeClaims (PVC)...${NC}"
kubectl apply -f "$PVC_DIR/"
sleep 10

echo -e "${GREEN}4. Eliminando CRDS de kuberay-operator${NC}"
kubectl delete crd rayclusters.ray.io rayjobs.ray.io rayservices.ray.io --ignore-not-found
sleep 10

echo -e "${GREEN}5. Instalando componentes con Helm...${NC}"

helm upgrade --install postgresql "$CHART_DIR/postgresql-11.9.11.tgz" --values "$VALUES_DIR/config-postgresql.yaml"
sleep 10 && helm status postgresql

helm upgrade --install postgresql-jupyterhub "$CHART_DIR/postgresql-11.9.11.tgz" --values "$VALUES_DIR/config-postgresql-jupyterhub.yaml"
sleep 10 && helm status postgresql-jupyterhub

helm upgrade --install jupyterhub "$CHART_DIR/jupyterhub-3.3.8.tgz" --values "$VALUES_DIR/config-jupyterhub.yaml"
sleep 10 && helm status jupyterhub

helm upgrade --install minio "$CHART_DIR/minio-11.10.9.tgz" --values "$VALUES_DIR/config-minio.yaml"
sleep 10 && helm status minio

helm upgrade --install mlflow "$CHART_DIR/mlflow-0.18.0.tgz" --values "$VALUES_DIR/config-mlflow.yaml"
sleep 10 && helm status mlflow

helm upgrade --install kuberay-operator "$CHART_DIR/kuberay-operator-1.3.0.tgz" --values "$VALUES_DIR/config-kuberay-operator.yaml"
sleep 5

helm upgrade --install raycluster "$CHART_DIR/ray-cluster-1.3.0.tgz" --values "$VALUES_DIR/config-ray.yaml"
sleep 10 && helm status raycluster

echo -e "${GREEN}✅ Despliegue completo en AKS con PV/PVC separados.${NC}"
