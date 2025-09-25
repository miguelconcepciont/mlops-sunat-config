# Evolución acumulada: v1.0.0 ➝ v3.3.0 (Stack MLOps)

## Estado inicial (v1.0.0)
- **Almacenamiento**: uso de `hostPath` en pods y volúmenes efímeros, sin almacenamiento centralizado.  
- **MinIO**: sin persistencia, datos borrados al reiniciar pods.  
- **Ray**: sin tolerancia a fallos; caída del head pod interrumpía todo el servicio.  
- **Instalación**: configuraciones manuales, poca parametrización.  
- **Imágenes Docker**: uso de imágenes base genéricas, sin control de dependencias ni compatibilidad entre entornos.  
- **Ejemplos**: no había casos completos de ciclo de vida de modelos.  

---

## Estado actual (v3.3.0)
- **Almacenamiento**:
  - Migración a **NFS con csi-driver-nfs** y `StorageClass` dinámicos.  
  - Persistencia total en MinIO y Ray.  
  - Cada clúster y entorno con su propia carpeta en NFS.   
- **Ray**:
  - Configurado con **`gcsFaultToleranceOptions` y Redis** para tolerancia a fallos.  
  - APIs mantienen estado tras reinicios de pods.  
- **MinIO**:
  - Persistencia activada (`/data` como `mountPath`).  
  - Artefactos de MLflow organizados por clúster y entorno.  
- **Instalación**:
  - Parametrización centralizada mediante `variables.txt`.  
  - Scripts estandarizados (`instalador.sh`, `desinstalador.sh`).  
- **Imágenes Docker**:
  - Imágenes propias optimizadas y alineadas:  
    - `miguelsff/ray:2.41.0-py311-sunat-v5`  
    - `miguelsff/scipy-notebook:python-3.11-sunat-v7`  
  - Librerías actualizadas para compatibilidad (ej. `category-encoders==2.8.1`).  
- **Ejemplos**:
  - Ciclo de vida completo del modelo Iris (entrenamiento ➝ despliegue ➝ test ➝ apagado).  
  - Ejemplos con modelos ML personalizados: `custom-v1` (código en artifactory) y `custom-v2` (serializado).  

---

## Beneficios obtenidos
- Persistencia de artefactos críticos en MinIO y PostgreSQL.  
- APIs de Ray continúan disponibles tras reinicios o fallos de pods.  
- Despliegue de modelos desde notebooks probado y funcional.  
- Tolerancia a fallos en Ray ante caída del head pod.  
- Actualizaciones de Kubernetes/Tanzu sin interrumpir servicios.  
- Datos centralizados, respaldables y administrables de forma programada.  
- Compatibilidad garantizada entre imágenes de entrenamiento (scipy-notebook) y despliegue (Ray).  


---

### Conclusión
La plataforma pasó de un **entorno experimental y efímero** (v1.0.0 con `hostPath` y sin tolerancia a fallos) a una **infraestructura robusta, persistente y tolerante a fallos** en v3.3.0, con:
- **Persistencia total** en NFS/MinIO/PostgreSQL.  
- **Alta disponibilidad** en Ray con Redis.  
- **Automatización y parametrización** completas.  
- **Entornos alineados** gracias a imágenes Docker optimizadas.  
- **Ejemplos prácticos** que cubren desde entrenamientos simples hasta despliegues avanzados.  

### Arquitectura de la Plataforma MLOPS - SUNAT (incluye Servidor NFS)
<img width="1020" height="502" alt="image" src="https://github.com/user-attachments/assets/4db521b6-76e6-42b0-8111-1c8506711659" />

### Arquitectura Individual del Servidor NFS.
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/98cdf53a-926f-41a9-82a9-19fc1e086442" />