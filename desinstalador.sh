#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}1. Desinstalando componentes Helm...${NC}"
helm uninstall raycluster || true
helm uninstall kuberay-operator || true
helm uninstall mlflow || true
helm uninstall minio || true
helm uninstall jupyterhub || true
helm uninstall postgresql-jupyterhub || true
helm uninstall postgresql || true
helm uninstall csi-driver-nfs -n kube-system || true

echo -e "${GREEN}2. Eliminando pods de usuario JupyterHub..."
kubectl delete pod -l component=singleuser-server || true
sleep 10

echo -e "${GREEN}3. Eliminando todos los PVC...${NC}"
kubectl delete -f pvc/ --ignore-not-found
kubectl get pvc --all-namespaces --no-headers | awk '{print "kubectl delete pvc", $2, "-n", $1}' | bash
sleep 5

echo -e "${GREEN}4. Eliminando todos los PV...${NC}"
kubectl delete -f pv/ --ignore-not-found
kubectl get pv --no-headers | awk '{print "kubectl delete pv", $1}' | bash
sleep 5

echo -e "${GREEN}5. Eliminando StorageClass 'nfs-storage-sc' y 'nfs-csi-jupyterhub-sc'...${NC}"
kubectl delete -f storageclass/nfs-storage-sc.yaml --ignore-not-found
kubectl delete -f storageclass/nfs-csi-jupyterhub-sc.yaml --ignore-not-found
sleep 3

echo -e "${GREEN}6. Eliminando CRDs de Ray...${NC}"
kubectl delete crd rayclusters.ray.io rayjobs.ray.io rayservices.ray.io --ignore-not-found

echo -e "${GREEN}✅ Desinstalación completada correctamente.${NC}"
