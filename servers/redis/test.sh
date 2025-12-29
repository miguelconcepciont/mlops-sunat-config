#!/bin/bash
set -e
echo "[INFO] Creando Job temporal de prueba..."
kubectl apply -f test.yaml

echo "[INFO] Esperando a que el Job finalice..."
kubectl wait --for=condition=complete job/redis-client-test --timeout=180s

echo "[INFO] Logs del Job:"
kubectl logs -l job-name=redis-client-test

echo "[INFO] Eliminando Job..."
kubectl delete -f test.yaml
echo "[DONE] Prueba completada correctamente."
