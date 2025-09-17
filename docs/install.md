# Instructivo de Instalación – Plataforma MLOps SUNAT (v3.3.0)

## 1. Instalación del Servidor NFS

### 1.1 Crear estructura de carpetas por clúster
En el servidor NFS crear las siguientes carpetas (si no existen):

```bash
# Clúster deploy-Mlops-prod01
mkdir -p /bitnami/deploy-Mlops-prod01/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-prod02
mkdir -p /bitnami/deploy-Mlops-prod02/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-Test01
mkdir -p /bitnami/deploy-Mlops-Test01/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-Test02
mkdir -p /bitnami/deploy-Mlops-Test02/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-User01
mkdir -p /bitnami/deploy-Mlops-User01/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-User02
mkdir -p /bitnami/deploy-Mlops-User02/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Clúster deploy-Mlops-User03
mkdir -p /bitnami/deploy-Mlops-User03/{hubdb/data,jenkins/home,minio/data,postgresql-jupyterhub/data,postgresql/data,userdata/data,jupyterhub/data}

# Asignar permisos
cd /bitnami
chmod -R 777 .
```

### 1.2 Verificación y montaje NFS en Kubernetes (Tanzu)
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
#### c. Probar conectividad al puerto 2049:
```bash
nc -vz <ip-servidor-nfs> 2049
```
#### d. Montar el NFS:
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

### 2.1 Configuración de Redis
#### a. Ingresar al servidor Redis según los procedimientos internos de la SUNAT
#### b. Localizar archivo de configuración:
```bash
ps aux | grep redis
find /etc -name "redis.conf" 2>/dev/null
```
#### c. Editar redis.conf y agregar:
```bash
conf requirepass Sunat2025
```
#### d. Verificar servicio:
```bash
sudo monit status redis
```
#### e. Reiniciar Redis:
```bash
sudo monit restart redis
```
### 2.2 Verificación de conexión
#### a. Desde el clúster:
```bash
kubectl run redis-client --rm -it \
  --image=vcf-np-w2-harbor-az1.sunat.peru/mlops/bitnami/redis:8.0.2 \
  --restart=Never -- bash
```
#### b. Dentro del contenedor:
```bash
redis-cli -h <ip-servidor-redis> -p 6379 -a Sunat2025
```
### 3. Instalación del Stack MLOps SUNAT
#### a. Descargar la versión v3.3.0:
```bash
wget https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/tags/v3.3.0.zip
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

