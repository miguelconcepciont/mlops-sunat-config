#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

DAEMONSET_FILE="end-paths-daemonset.yaml"
PV_DIR="pv"
PVC_DIR="pvc"
STORAGECLASS_DIR="storageclass"
LOCAL_PATH_NS="local-path-storage"

echo -e "${GREEN}1. Desinstalando componentes Helm...${NC}"

helm uninstall raycluster || true
helm uninstall kuberay-operator || true
helm uninstall mlflow || true
helm uninstall minio || true
helm uninstall jupyterhub || true
helm uninstall postgresql-jupyterhub || true
helm uninstall postgresql || true

echo -e "${GREEN}2. Eliminando PersistentVolumeClaims (PVC)...${NC}"
kubectl delete -f "$PVC_DIR/" --ignore-not-found
sleep 5

echo -e "${GREEN}3. Eliminando PersistentVolumes (PV)...${NC}"
kubectl delete -f "$PV_DIR/" --ignore-not-found
sleep 5

echo -e "${GREEN}4. Eliminando StorageClass y recursos asociados...${NC}"

# Eliminar StorageClass
kubectl delete storageclass local-path-jupyterhub --ignore-not-found

# Eliminar ConfigMap
kubectl delete configmap local-path-config -n "$LOCAL_PATH_NS" --ignore-not-found

# Eliminar Deployment
kubectl delete deployment local-path-provisioner -n "$LOCAL_PATH_NS" --ignore-not-found

# Eliminar RoleBinding y ClusterRoleBinding
kubectl delete rolebinding local-path-provisioner-bind -n "$LOCAL_PATH_NS" --ignore-not-found
kubectl delete clusterrolebinding local-path-provisioner-bind --ignore-not-found

# Eliminar Role y ClusterRole
kubectl delete role local-path-provisioner-role -n "$LOCAL_PATH_NS" --ignore-not-found
kubectl delete clusterrole local-path-provisioner-role --ignore-not-found

# Eliminar ServiceAccount
kubectl delete serviceaccount local-path-provisioner-service-account -n "$LOCAL_PATH_NS" --ignore-not-found

# Eliminar Namespace (último paso de esta parte)
kubectl delete namespace "$LOCAL_PATH_NS" --ignore-not-found

sleep 3

echo -e "${GREEN}5. Preparando carpetas con DaemonSet...${NC}"
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
sleep 5

echo -e "${GREEN}6. Eliminando crds...${NC}"
kubectl delete crd rayclusters.ray.io rayjobs.ray.io rayservices.ray.io --ignore-not-found

echo -e "${GREEN}✅ Desinstalación completada correctamente.${NC}"
