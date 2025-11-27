#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

variables_txt="variables.txt"
current_context=$(kubectl config current-context)

echo -e "${GREEN}🔹 Contexto actual: $current_context${NC}"

echo -e "${GREEN}🔹 Restaurando archivos de configuración de los templates...${NC}"
cp "$variables_txt.template" "$variables_txt"
find pv pvc storageclass values -name "*.yaml.template" | while read template; do
    output_file="${template%.template}"
    cp "$template" "$output_file"
done

if [[ "$current_context" == *deploy* ]]; then
  entorno="SUNAT"

  redis_host="172.26.59.6"
  redis_password="Sunat2025"

  case "$current_context" in
    deploy-Mlops-prod01|deploy-Mlops-produccion01|deploy-Mlops-prod02)
      redis_host="172.26.59.5"
      redis_password="Sunat2025"
      ;;
    deploy-Mlops-Test01|deploy-Mlops-desa01)
      redis_host="172.26.59.7"
      redis_password="Sunat2025"
      ;;
    deploy-Mlops-User01|deploy-Mlops-User02|deploy-Mlops-User03)
      redis_host="172.26.59.6"
      redis_password="Sunat2025"
      ;;
  esac

  sed -i "s|\${clusterName}|$current_context|g" "$variables_txt"
  sed -i "s|\${redisHost}|$redis_host|g" "$variables_txt"
  sed -i "s|\${redisPassword}|$redis_password|g" "$variables_txt"
else
  entorno="AKS"
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

echo -e "${GREEN}1. Instalando NFS CSI Driver...${NC}"
helm upgrade --install csi-driver-nfs "charts/csi-driver-nfs-4.11.0.tgz" -n kube-system -f values/config-csi-driver-nfs.yaml

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

echo -e "${GREEN}🧹 Limpiando archivos de configuración generados ...${NC}"
rm -f "$variables_txt"
find pv pvc storageclass values -name "*.yaml.template" | while read template; do
    output_file="${template%.template}"
    rm -f "$output_file"
done

echo -e "${GREEN}✅ Instalación completa en $entorno.${NC}"
echo -e "${GREEN}🔹 Contexto usado: $current_context${NC}"

# Port-forward solo para minikube / local
if [[ "$current_context" == "minikube" ]]; then
  sleep 25
  echo -e "${GREEN}12. Creando port-forward para acceso desde la red local...${NC}"

  # MLflow -> puerto 5000
  kubectl port-forward --address 0.0.0.0 svc/mlflow 5000:5000 >/tmp/pf-mlflow.log 2>&1 &

  # JupyterHub (proxy-public) -> puerto 8080
  kubectl port-forward --address 0.0.0.0 svc/proxy-public 8080:80 >/tmp/pf-jupyterhub.log 2>&1 &

  # Ray Dashboard -> puerto 8265
  kubectl port-forward --address 0.0.0.0 svc/raycluster-kuberay-head-svc 8265:8265 >/tmp/pf-raydash.log 2>&1 &

  echo -e "${GREEN}🔹 Ahora puedes acceder desde tu LAN usando la IP de tu PC:${NC}"
  echo -e "${GREEN}   MLflow:     http://IP_DE_TU_PC:5000${NC}"
  echo -e "${GREEN}   JupyterHub: http://IP_DE_TU_PC:8080${NC}"
  echo -e "${GREEN}   Ray Dash:   http://IP_DE_TU_PC:8265${NC}"
fi