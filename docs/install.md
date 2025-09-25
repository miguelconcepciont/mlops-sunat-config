# Instructivo de Instalación – Plataforma MLOps SUNAT (v3.3.0)

## 1. Instalación del Servidor NFS

### 1.1 Solicitar creación de Servidor NFS
<Agregar ticket de creación de NFS server (detallado) Aprobado con control de cambios>

### 1.2 Crear estructura de carpetas por clúster
En el servidor NFS crear las siguientes carpetas (si no existen):

```bash
# Clúster deploy-Mlops-prod01
mkdir -p /bitnami/deploy-Mlops-prod01/hubdb/data
mkdir -p /bitnami/deploy-Mlops-prod01/jenkins/home
mkdir -p /bitnami/deploy-Mlops-prod01/minio/data
mkdir -p /bitnami/deploy-Mlops-prod01/postgresql-jupyterhub/data
mkdir -p /bitnami/deploy-Mlops-prod01/postgresql/data
mkdir -p /bitnami/deploy-Mlops-prod01/userdata/data
mkdir -p /bitnami/deploy-Mlops-prod01/jupyterhub/data

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
### 3. Instalación del Stack MLOps SUNAT
#### a. Descargar la versión v3.3.0  (Reemplazar <url-descarga-v3.3.0> por la URL donde está ubicada el archivo v3.3.0.zip):
```bash
wget <url-descarga-v3.3.0>
```
#### b. Descomprimir:
```bash
unzip v3.3.0.zip
cd mlops-sunat-config-3.3.0
```
#### c. Asignar permisos:
```bash
chmod -R 777 .
```
#### d. Ejecutar instalación:
```bash
bash instalador.sh
```

