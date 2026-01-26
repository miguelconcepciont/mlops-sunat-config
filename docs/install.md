# Instructivo de Instalación - Plataforma MLOps SUNAT

## 1. Instalación del Servidor NFS

### 1.1 Solicitar creación de Servidor NFS
<Agregar ticket de creación de NFS server (detallado) Aprobado con control de cambios>

### 1.2 Crear estructura de carpetas por clúster
En el servidor NFS crear las siguientes carpetas (si no existen):

```bash
# Clúster deploy-Mlops-produccion01
mkdir -p /bitnami/deploy-Mlops-produccion01/hubdb/data
mkdir -p /bitnami/deploy-Mlops-produccion01/jenkins/home
mkdir -p /bitnami/deploy-Mlops-produccion01/minio/data
mkdir -p /bitnami/deploy-Mlops-produccion01/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-produccion01/postgresql/data
mkdir -p /bitnami/deploy-Mlops-produccion01/userdata/data
mkdir -p /bitnami/deploy-Mlops-produccion01/jupyterhub/data

# Clúster deploy-Mlops-prod02
mkdir -p /bitnami/deploy-Mlops-prod02/hubdb/data
mkdir -p /bitnami/deploy-Mlops-prod02/jenkins/home
mkdir -p /bitnami/deploy-Mlops-prod02/minio/data
mkdir -p /bitnami/deploy-Mlops-prod02/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-prod02/postgresql/data
mkdir -p /bitnami/deploy-Mlops-prod02/userdata/data
mkdir -p /bitnami/deploy-Mlops-prod02/jupyterhub/data

# Clúster deploy-Mlops-Test01
mkdir -p /bitnami/deploy-Mlops-Test01/hubdb/data
mkdir -p /bitnami/deploy-Mlops-Test01/jenkins/home
mkdir -p /bitnami/deploy-Mlops-Test01/minio/data
mkdir -p /bitnami/deploy-Mlops-Test01/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-Test01/postgresql/data
mkdir -p /bitnami/deploy-Mlops-Test01/userdata/data
mkdir -p /bitnami/deploy-Mlops-Test01/jupyterhub/data

# Clúster deploy-Mlops-Test02
mkdir -p /bitnami/deploy-Mlops-Test02/hubdb/data
mkdir -p /bitnami/deploy-Mlops-Test02/jenkins/home
mkdir -p /bitnami/deploy-Mlops-Test02/minio/data
mkdir -p /bitnami/deploy-Mlops-Test02/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-Test02/postgresql/data
mkdir -p /bitnami/deploy-Mlops-Test02/userdata/data
mkdir -p /bitnami/deploy-Mlops-Test02/jupyterhub/data

# Clúster deploy-Mlops-User01
mkdir -p /bitnami/deploy-Mlops-User01/hubdb/data
mkdir -p /bitnami/deploy-Mlops-User01/jenkins/home
mkdir -p /bitnami/deploy-Mlops-User01/minio/data
mkdir -p /bitnami/deploy-Mlops-User01/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-User01/postgresql/data
mkdir -p /bitnami/deploy-Mlops-User01/userdata/data
mkdir -p /bitnami/deploy-Mlops-User01/jupyterhub/data

# Clúster deploy-Mlops-User02
mkdir -p /bitnami/deploy-Mlops-User02/hubdb/data
mkdir -p /bitnami/deploy-Mlops-User02/jenkins/home
mkdir -p /bitnami/deploy-Mlops-User02/minio/data
mkdir -p /bitnami/deploy-Mlops-User02/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-User02/postgresql/data
mkdir -p /bitnami/deploy-Mlops-User02/userdata/data
mkdir -p /bitnami/deploy-Mlops-User02/jupyterhub/data

# Clúster deploy-Mlops-User03
mkdir -p /bitnami/deploy-Mlops-User03/hubdb/data
mkdir -p /bitnami/deploy-Mlops-User03/jenkins/home
mkdir -p /bitnami/deploy-Mlops-User03/minio/data
mkdir -p /bitnami/deploy-Mlops-User03/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-User03/postgresql/data
mkdir -p /bitnami/deploy-Mlops-User03/userdata/data
mkdir -p /bitnami/deploy-Mlops-User03/jupyterhub/data

# Asignar permisos
cd /bitnami
chmod -R 777 .
```

### 1.3 Verificación y montaje NFS en Kubernetes (Tanzu)
#### a. Desde el clúster, desplegar contenedor de prueba:
```bash
kubectl run nfs-test --rm -it --restart=Never \
  --image=vcf-np-w2-harbor-az1.sunat.peru/rayserve/busybox:latest \
  --overrides='{
    "apiVersion": "v1",
    "spec": {
      "containers": [{
        "name": "sh",
        "image": "vcf-np-w2-harbor-az1.sunat.peru/rayserve/busybox:latest",
        "stdin": true,
        "tty": true,
        "securityContext": { "privileged": true }
      }]
    }
  }' -- sh
```
#### b. Verificar soporte NFS:
```bash
cat /proc/filesystems | grep -E 'nfs|nfs4'
```
#### c. Probar conectividad al puerto 2049 (Reemplazar <ip-servidor-nfs> por la IP del Servidor NFS):
```bash
nc -vz <ip-servidor-nfs> 2049
```
#### d. Montar el NFS (Reemplazar <ip-servidor-nfs> por la IP del Servidor NFS):
```bash
mkdir -p /mnt

mount -t nfs -o vers=4.1,timeo=600,retrans=2 \
  <ip-servidor-nfs>:/bitnami /mnt || \
mount -t nfs -o vers=3,nolock \
  <ip-servidor-nfs>:/bitnami /mnt
```
#### e. Validar acceso:
```bash
df -h /mnt
chmod -R 777 /mnt
ls -la /mnt
```
## 2. Instalación de Servidores Redis
⚠️ La siguiente configuración y verificación debe ejecutarse en cada uno de los 3 servidores Redis destinados al entorno MLOps de SUNAT.

### 2.1 Solicitar creación de servidores Redis
<Agregar ticket de creación de los servidores Redis (detallado) Aprobado con control de cambios>

### 2.2 Configuración de Redis
#### a. Ingresar al servidor Redis según los procedimientos internos de la SUNAT
#### b. Localizar archivo de configuración:
```bash
ps aux | grep redis
find /etc -name "redis.conf" 2>/dev/null
```
#### c. Editar redis.conf y agregar (Reemplazar <contraseña-redis> por la contraseña de Redis):
```bash
conf requirepass <contraseña-redis>
```
#### d. Verificar servicio:
```bash
sudo monit status redis
```
#### e. Reiniciar Redis:
```bash
sudo monit restart redis
```
### 2.3 Verificación de conexión
#### a. Desde el clúster:
```bash
kubectl run redis-client --rm -it \
  --image=vcf-np-w2-harbor-az1.sunat.peru/mlops/bitnami/redis:8.0.2 \
  --restart=Never -- bash
```
#### b. Dentro del contenedor (Reemplazar <contraseña-redis> por la contraseña de Redis):
```bash
redis-cli -h <ip-servidor-redis> -p 6379 -a <contraseña-redis>
```
## 3. Construccion de imagenes Docker

Las imagenes Docker personalizadas de la plataforma deben construirse en un servidor con sistema operativo Linux RedHat que disponga de Docker Engine instalado y acceso a internet para la descarga de dependencias.

### 3.1. Prerequisitos

```bash
# Verificar instalacion de Docker
docker --version

# Verificar que el servicio Docker este activo
sudo systemctl status docker

# Iniciar sesion en Docker Hub (requerido para descargar imagenes base)
docker login
```

### 3.2. Imagen Ray Cluster

Imagen del motor de computo distribuido Ray basada en `rayproject/ray:2.41.0-py311`. Incluye PyTorch 2.9.0, TensorFlow 2.20.0, scikit-learn, XGBoost, LightGBM, ecosistema LangChain/LangGraph, Qdrant Client y librerias de procesamiento de lenguaje natural.

El script `build-push.sh` ubicado en el directorio de la imagen contiene las variables de configuracion para la construccion y publicacion:

```bash
REGISTRY=miguelsff
IMAGE_NAME=ray
TAG=2.41.0-py311-sunat-v8
```

Para construir y publicar la imagen:

```bash
# 1. Ubicarse en el directorio de la imagen Ray
cd images/miguelsff/ray-2.41.0-sunat/

# 2. Verificar o modificar las variables REGISTRY, IMAGE_NAME y TAG en build-push.sh
vi build-push.sh

# 3. Asignar permisos de ejecucion al script
chmod +x build-push.sh

# 4. Ejecutar el script de construccion y publicacion
bash build-push.sh
```

### 3.3. Imagen JupyterHub Single User - Scipy Notebook

Imagen de los notebooks individuales de JupyterHub basada en `jupyter/scipy-notebook:python-3.11`. Incluye JupyterLab con Elyra (editor visual de pipelines ML), Apache Toree (kernel Spark), OpenJDK 17, PyTorch 2.9.0, ecosistema LangChain/LangGraph, Qdrant Client y el stack completo de ciencia de datos.

El script `build-push.sh` ubicado en el directorio de la imagen contiene las variables de configuracion para la construccion y publicacion:

```bash
REGISTRY=miguelsff
IMAGE_NAME=scipy-notebook
TAG=python-3.11-sunat-v9
```

Para construir y publicar la imagen:

```bash
# 1. Ubicarse en el directorio de la imagen Scipy Notebook
cd images/miguelsff/scipy-notebook-python-3.11-sunat/

# 2. Verificar o modificar las variables REGISTRY, IMAGE_NAME y TAG en build-push.sh
vi build-push.sh

# 3. Asignar permisos de ejecucion al script
chmod +x build-push.sh

# 4. Ejecutar el script de construccion y publicacion
bash build-push.sh
```

### 3.4. Transferencia de imagenes al registro Harbor SUNAT

Una vez construidas y publicadas en Docker Hub, las imagenes deben transferirse al registro privado Harbor de SUNAT para su disponibilidad en la red corporativa.

#### a. Imagen Ray Cluster

```bash
# 1. Descargar imagen desde Docker Hub
docker pull miguelsff/ray:2.41.0-py311-sunat-v8

# 2. Guardar imagen como archivo tar para transferencia offline
docker save -o miguelsff-ray-2.41.0-py311-sunat-v8.tar miguelsff/ray:2.41.0-py311-sunat-v8

# 3. Cargar imagen en el entorno local de destino
docker load -i miguelsff-ray-2.41.0-py311-sunat-v8.tar

# 4. Etiquetar con destino al repositorio Harbor SUNAT
docker tag miguelsff/ray:2.41.0-py311-sunat-v8 vcf-np-w2-harbor-az1.sunat.peru/mlops/miguelsff/ray:2.41.0-py311-sunat-v8

# 5. Subir imagen al repositorio Harbor SUNAT
docker push vcf-np-w2-harbor-az1.sunat.peru/mlops/miguelsff/ray:2.41.0-py311-sunat-v8
```

#### b. Imagen Scipy Notebook

```bash
# 1. Descargar imagen desde Docker Hub
docker pull miguelsff/scipy-notebook:python-3.11-sunat-v9

# 2. Guardar imagen como archivo tar para transferencia offline
docker save -o miguelsff-scipy-notebook-python-3.11-sunat-v9.tar miguelsff/scipy-notebook:python-3.11-sunat-v9

# 3. Cargar imagen en el entorno local de destino
docker load -i miguelsff-scipy-notebook-python-3.11-sunat-v9.tar

# 4. Etiquetar con destino al repositorio Harbor SUNAT
docker tag miguelsff/scipy-notebook:python-3.11-sunat-v9 vcf-np-w2-harbor-az1.sunat.peru/mlops/miguelsff/scipy-notebook:python-3.11-sunat-v9

# 5. Subir imagen al repositorio Harbor SUNAT
docker push vcf-np-w2-harbor-az1.sunat.peru/mlops/miguelsff/scipy-notebook:python-3.11-sunat-v9
```

---

## 4. Instalacion del Stack MLOps SUNAT

Ejecute los siguientes comandos para instalar la plataforma MLOps en el cluster de destino.

```bash
# 1. Seleccionar el contexto del cluster de destino
kubectl config use-context <contexto-cluster>

# 2. Descarga del codigo fuente v3.5.0
wget 'https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/tags/v3.5.0.zip' -O mlops-sunat-config-v3.5.0.zip

# 3. Descompresion del paquete
unzip mlops-sunat-config-v3.5.0.zip

# 4. Ingreso al directorio
cd mlops-sunat-config-3.5.0/

# 5. Asignacion de permisos
chmod -R 777 .

# 6. Ejecucion del script de instalacion
bash instalador.sh

# 7. Verificar estados de pods
kubectl get pods
```