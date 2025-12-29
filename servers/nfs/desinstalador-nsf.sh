#!/bin/bash
set -euo pipefail

NAMESPACE="nfs-server-storage"

echo "Eliminando Deployment, Service y PVC de NFS Ganesha en el namespace ${NAMESPACE}…"
kubectl delete deployment nfs-ganesha -n "$NAMESPACE" --ignore-not-found
kubectl delete svc nfs-ganesha -n "$NAMESPACE" --ignore-not-found
kubectl delete pvc nfs-ganesha-data -n "$NAMESPACE" --ignore-not-found

echo "Eliminando namespace ${NAMESPACE} (se eliminarán los recursos que queden dentro)…"
kubectl delete namespace "$NAMESPACE" --ignore-not-found

echo "Desinstalación completada."
