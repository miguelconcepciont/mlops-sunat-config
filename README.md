# MLOPS-SUNAT-CONFIG

Repositorio de configuración e instalación de la solución MLOps implementada para SUNAT, desplegada sobre clústeres Kubernetes en la nube privada Tanzu. Este entorno permite el entrenamiento, validación, versionado y despliegue de modelos analíticos utilizando herramientas open source.

## 🧰 Stack Tecnológico

- **PostgreSQL**: Almacena parámetros, métricas y metadatos de MLflow.
- **MinIO**: Repositorio de artefactos de ML como modelos, datasets, imágenes.
- **MLflow**: Seguimiento y gestión del ciclo de vida de modelos.
- **JupyterHub**: Entorno para notebooks personalizados con ElyraAI y SmartDeploy.
- **Ray / RayServe**: Inferencia distribuida y servicio de APIs para modelos online.
- **Jenkins**: CI/CD para pipelines de entrenamiento, validación y despliegue.

## 📁 Estructura del Repositorio

```plaintext
.
├── instalacion.sh                          # Script principal de instalación
├── instalacion_cluster_validacion.sh      # Variante para entorno de validación
├── config-*.yaml                          # Archivos de configuración Helm
├── *.tgz                                  # Helm charts empaquetados
├── *-pvc.yaml, *-volume.yaml              # PVCs y Volúmenes persistentes por componente
├── nodos.txt                              # Lista de nodos donde montar volúmenes (BOSH)
├── service.txt                            # Identificador del deployment BOSH
