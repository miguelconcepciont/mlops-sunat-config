#!/bin/bash
set -euo pipefail

NAMESPACE="nfs-server-storage"

echo "==> Eliminando recursos en el namespace ${NAMESPACE}..."

# Recursos principales del stack de Ganesha
kubectl delete deployment nfs-ganesha -n "$NAMESPACE" --ignore-not-found
kubectl delete svc nfs-ganesha -n "$NAMESPACE" --ignore-not-found
kubectl delete configmap ganesha-conf -n "$NAMESPACE" --ignore-not-found
kubectl delete pvc nfs-ganesha-data -n "$NAMESPACE" --ignore-not-found

# Esperar a que los Pods controlados por el deployment desaparezcan
echo "==> Esperando la eliminación de Pods del app nfs-ganesha..."
kubectl wait --for=delete pod -l app=nfs-ganesha -n "$NAMESPACE" --timeout=60s 2>/dev/null || true

# Borrar cualquier ReplicaSet residual
kubectl delete rs -l app=nfs-ganesha -n "$NAMESPACE" --ignore-not-found

# (Opcional) eliminar un pod de pruebas si lo levantaste en default
echo "==> Eliminando pod de prueba (namespace default) si existe..."
kubectl delete pod nfs-test --ignore-not-found

# Borrar el namespace
echo "==> Eliminando namespace ${NAMESPACE}..."
kubectl delete namespace "$NAMESPACE" --ignore-not-found

# Esperar a que el namespace termine de eliminarse (manejo de finalizers atascados)
echo "==> Esperando eliminación del namespace (hasta 90s)..."
for i in {1..18}; do
  if ! kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
    echo "==> Namespace ${NAMESPACE} eliminado."
    exit 0
  fi
  sleep 5
done

# Si sigue atascado en Terminating, intentar quitar finalizers (modo best-effort)
echo "==> Namespace ${NAMESPACE} aún presente; intentando quitar finalizers..."
set +e
kubectl get ns "$NAMESPACE" -o json \
  | jq 'del(.spec.finalizers)' \
  | kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f - >/dev/null 2>&1
set -e

# Verificación final
if kubectl get ns "$NAMESPACE" >/dev/null 2>&1; then
  echo ">> Advertencia: el namespace ${NAMESPACE} aún existe. Revisa finalizers o recursos pendientes."
else
  echo "==> Desinstalación completada."
fi
