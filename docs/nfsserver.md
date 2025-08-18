# 📦 Configuración y Pruebas de Conectividad con NFS Server

---

## 🔍 1. Verificación y Montaje NFS – Entorno AKS

### a. Desplegar contenedor de prueba
```bash
kubectl run nfs-test --rm -it --restart=Never \
  --image=busybox:latest \
  --overrides='{
    "apiVersion": "v1",
    "spec": {
      "containers": [{
        "name": "sh",
        "image": "busybox:latest",
        "stdin": true,
        "tty": true,
        "securityContext": { "privileged": true }
      }]
    }
  }' -- sh
```

### b. Verificar soporte NFS en el contenedor
```bash
cat /proc/filesystems | grep -E 'nfs|nfs4'
```

### c. Verificar conectividad con el NFS server (puerto 2049)
```bash
nc -vz storagenfsmlops.privatelink.file.core.windows.net 2049
```

### d. Montar el NFS
```bash
mkdir -p /mnt

mount -t nfs -o vers=4.1,timeo=600,retrans=2 \
  storagenfsmlops.privatelink.file.core.windows.net:/storagenfsmlops/nfs-share/bitnami \
  /mnt || \
mount -t nfs -o vers=3,nolock \
  storagenfsmlops.privatelink.file.core.windows.net:/storagenfsmlops/nfs-share/bitnami \
  /mnt
```

### e. Validar acceso y permisos
```bash
df -h /mnt
chmod -R 777 /mnt
ls -la /mnt
```

---

## 🔍 2. Verificación y Montaje NFS – Entorno TANZU

### a. Desplegar contenedor de prueba
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

### b. Verificar soporte NFS en el contenedor
```bash
cat /proc/filesystems | grep -E 'nfs|nfs4'
```

### c. Verificar conectividad con el NFS server (puerto 2049)
```bash
nc -vz 172.26.60.13 2049
```

### d. Montar el NFS
```bash
mkdir -p /mnt

mount -t nfs -o vers=4.1,timeo=600,retrans=2 \
  172.26.60.13:/bitnami \
  /mnt || \
mount -t nfs -o vers=3,nolock \
  172.26.60.13:/bitnami \
  /mnt
```

### e. Validar acceso y permisos
```bash
df -h /mnt
chmod -R 777 /mnt
ls -la /mnt
```

---

**📝 Nota:** Asegúrate de tener permisos de red y configuración de seguridad adecuados en tu entorno para acceder al servidor NFS.
