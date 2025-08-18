# 🔧 Configuración y Verificación de Redis

## 🛠️ 1. Configurar `requirepass` en Redis

### a. Ingresar al servidor Redis
```bash
ssh usuario@servidor-redis
```

### b. Buscar el archivo de configuración `redis.conf`
```bash
ps aux | grep redis
# o
find /etc -name "redis.conf" 2>/dev/null
```

### c. Editar `redis.conf` y agregar la contraseña
Buscar la línea correspondiente y agregar/modificar:

```conf
requirepass Sunat2025
```

### d. Verificar el estado del servicio Redis
```bash
sudo monit status redis
```

### e. Reiniciar Redis
```bash
sudo monit restart redis
```

---

## ✅ 2. Probar conexión a Redis – Entorno SUNAT

```bash
kubectl run redis-client --rm -it \
  --image=vcf-np-w2-harbor-az1.sunat.peru/mlops/bitnami/redis:8.0.2 \
  --restart=Never -- bash
```

Una vez dentro del contenedor:
```bash
redis-cli -h 172.26.59.6 -p 6379 -a Sunat2025
```

---

## ✅ 3. Probar conexión a Redis – Entorno AKS

```bash
kubectl run redis-client --rm -it \
  --image=bitnami/redis \
  --restart=Never -- bash
```

---

**📝 Nota:** Asegúrate de que el puerto, la IP y la contraseña coincidan con tu configuración actual de Redis.
