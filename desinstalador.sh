#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

# Configuración de variables
variables_txt="variables.txt"
current_context=$(kubectl config current-context)

echo -e "${GREEN}🔹 Restaurando archivos de configuración de los templates...${NC}"
cp "$variables_txt.template" "$variables_txt"
find pv pvc storageclass values -name "*.yaml.template" | while read template; do
    output_file="${template%.template}"
    cp "$template" "$output_file"
done

echo -e "${GREEN}🔹 Contexto actual: $current_context${NC}"

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

echo -e "${GREEN}3. Procesando variables para entorno $entorno...${NC}"

# Procesar variables
mapfile -t variables < "$variables_txt"

for variable in "${variables[@]}"; do
  IFS='|' read -r parte1 parte2 parte3 <<< "$variable"
  
  variable_name="\${${parte1#*:}}"
  aks_val="${parte2#*:}"
  sunat_val="${parte3#*:}"

  if [[ "$entorno" == "AKS" ]]; then
    valorvariable="$aks_val"
  else
    valorvariable="$sunat_val"
  fi

  echo "Reemplazando $variable_name por $valorvariable"
  find pv pvc storageclass values -type f -name "*.yaml" -exec sed -i "s|$variable_name|$valorvariable|g" {} +
done

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
kubectl delete pod -l component=singleuser-server --grace-period=0 --force || true
sleep 10

echo -e "${GREEN}3. Eliminando todos los PVC...${NC}"
kubectl delete -f pvc/ --ignore-not-found
#kubectl get pvc --all-namespaces --no-headers | awk '{print "kubectl delete pvc", $2, "-n", $1}' | bash
sleep 5

echo -e "${GREEN}4. Eliminando todos los PV...${NC}"
kubectl delete -f pv/ --ignore-not-found
#kubectl get pv --no-headers | awk '{print "kubectl delete pv", $1}' | bash
sleep 5

echo -e "${GREEN}5. Eliminando StorageClass 'nfs-storage-sc' y 'nfs-csi-jupyterhub-sc'...${NC}"
kubectl delete -f storageclass/nfs-storage-sc.yaml --ignore-not-found
kubectl delete -f storageclass/nfs-csi-jupyterhub-sc.yaml --ignore-not-found
sleep 3

echo -e "${GREEN}6. Eliminando CRDs de Ray...${NC}"
kubectl delete crd rayclusters.ray.io rayjobs.ray.io rayservices.ray.io --ignore-not-found

echo -e "${GREEN}🧹 Limpiando archivos de configuración generados ...${NC}"
rm -f "$variables_txt"
find pv pvc storageclass values -name "*.yaml.template" | while read template; do
    output_file="${template%.template}"
    rm -f "$output_file"
done

echo -e "${GREEN}✅ Desinstalación completada correctamente.${NC}"
