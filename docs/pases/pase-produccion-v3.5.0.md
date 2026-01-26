# Documento de Pase a Produccion: Plataforma MLOps SUNAT v3.5.0

**Solicitante:** Alvarez Landeo Luis Alberto (lalvarez@sunat.gob.pe)
**Version Actual:** v3.4.0
**Version a Desplegar:** v3.5.0
**Fecha:** 26 de enero de 2026

---

## 1. Descripcion

Actualizacion de la plataforma MLOps SUNAT a la version 3.5.0. Se incorpora el ecosistema LangChain/LangGraph para desarrollo con LLMs, soporte de base de datos vectorial con Qdrant, actualizacion de librerias core (pandas, requests, gensim, pydantic) y mejoras en el script de actualizacion para incluir la reinstalacion de JupyterHub.

## 2. Sustento

- **Capacidades de IA Generativa:** Incorporacion del ecosistema LangChain 1.0.2, LangGraph 1.0.1, LangChain Community 0.4.1 y tiktoken 0.12.0 en ambas imagenes Docker (ray:2.41.0-py311-sunat-v8 y scipy-notebook:python-3.11-sunat-v9) para habilitar el desarrollo de aplicaciones con modelos de lenguaje (LLMs), cadenas de procesamiento y agentes inteligentes.
- **Base de Datos Vectorial:** Integracion de Qdrant Client 1.15.1 para busqueda por similitud semantica, requerida para implementaciones de RAG (Retrieval-Augmented Generation) y sistemas de recomendacion basados en embeddings.
- **Actualizacion de Librerias Core:** Actualizacion de pandas (2.1.1 a 2.2.3), requests (2.32.4 a 2.32.5), gensim (4.3.3 a 4.4.0) y pydantic (2.5.0 a 2.12.5) para correccion de vulnerabilidades, mejoras de rendimiento y compatibilidad con las nuevas dependencias.
- **Adicion de Librerias Numericas:** Incorporacion explicita de numpy 2.0.2 y matplotlib 3.9.4 en ambas imagenes para garantizar versiones consistentes en el entorno de computo distribuido (Ray) y notebooks (JupyterHub).
- **Mejora del Script de Actualizacion:** El script `actualizador.sh` ahora gestiona la reinstalacion completa de JupyterHub (desinstalacion, eliminacion de pods singleuser, reinstalacion), ademas del Ray Cluster, permitiendo actualizaciones mas completas de la plataforma.

---

## 3. Registro de imagenes Docker en Harbor

Previo al despliegue en cualquier entorno, las nuevas imagenes Docker deben transferirse al registro privado Harbor de la institucion. Este procedimiento garantiza la disponibilidad de las imagenes dentro de la red corporativa sin dependencia de registros externos.

### 3.1. Imagen Ray Cluster (ray:2.41.0-py311-sunat-v8)

Imagen base del motor de computo distribuido Ray, actualizada con el ecosistema LangChain/LangGraph, Qdrant Client y librerias core actualizadas.

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

### 3.2. Imagen JupyterHub Single User - Scipy Notebook (scipy-notebook:python-3.11-sunat-v9)

Imagen base de los notebooks individuales de JupyterHub, actualizada con las mismas librerias de IA generativa y base de datos vectorial.

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

## 4. Instrucciones para despliegue en cluster de pruebas

Una vez registradas las imagenes en Harbor, ejecutar el despliegue en el cluster de pruebas designado para validacion funcional previa al pase a produccion.

```bash
# 1. Seleccionar el contexto del cluster de pruebas indicado
kubectl config use-context <contexto-cluster-pruebas>

# 2. Descargar codigo fuente desde la rama feature/add-libraries
wget 'https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/heads/feature/add-libraries.zip' -O mlops-sunat-config-feature-add-libraries.zip

# 3. Descomprimir el paquete
unzip mlops-sunat-config-feature-add-libraries.zip

# 4. Ingresar al directorio
cd mlops-sunat-config-feature-add-libraries/

# 5. Asignar permisos de ejecucion
chmod -R 777 .

# 6. Ejecutar el script de actualizacion
bash actualizador.sh
```

> **Nota:** El script `actualizador.sh` ejecuta la desinstalacion y reinstalacion de JupyterHub y Ray Cluster de forma automatizada, incluyendo la eliminacion de pods singleuser previo a la reinstalacion.

---

## 5. Instrucciones para pase a clúster deploy-Mlops-test01

Ejecute los siguientes comandos para aplicar la nueva version:

```bash
# 1. Seleccionar el contexto de test01
kubectl config use-context deploy-Mlops-test01

# 2. Descarga del codigo fuente v3.5.0
wget 'https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/tags/v3.5.0.zip' -O mlops-sunat-config-v3.5.0.zip

# 3. Descompresion del paquete
unzip mlops-sunat-config-v3.5.0.zip

# 4. Ingreso al directorio (GitHub extrae como mlops-sunat-config-3.5.0)
cd mlops-sunat-config-3.5.0/

# 5. Asignacion de permisos
chmod -R 777 .

# 6. Ejecucion de scripts de desinstalacion e instalacion
bash actualizador.sh
```

---

## 6. Instrucciones para pase a produccion en clúster deploy-Mlops-produccion01

Ejecute los siguientes comandos para aplicar la nueva version:

```bash
# 1. Seleccionar el contexto de produccion
kubectl config use-context deploy-Mlops-produccion01

# 2. Descarga del codigo fuente v3.5.0
wget 'https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/tags/v3.5.0.zip' -O mlops-sunat-config-v3.5.0.zip

# 3. Descompresion del paquete
unzip mlops-sunat-config-v3.5.0.zip

# 4. Ingreso al directorio (GitHub extrae como mlops-sunat-config-3.5.0)
cd mlops-sunat-config-3.5.0/

# 5. Asignacion de permisos
chmod -R 777 .

# 6. Ejecucion de scripts de desinstalacion e instalacion
bash actualizador.sh
```

---

## 7. Instrucciones para reversion (Rollback)

En caso de fallos criticos, proceda con el retorno a la version v3.4.0:

```bash
# 1. Asegurar el contexto de produccion
kubectl config use-context <contexto-cluster-pruebas-o-test-o-produccion>

# 2. Descarga de la version estable anterior v3.4.0
wget 'https://github.com/miguelconcepciont/mlops-sunat-config/archive/refs/tags/v3.4.0.zip' -O mlops-sunat-config-v3.4.0.zip

# 3. Descompresion del paquete
unzip mlops-sunat-config-v3.4.0.zip

# 4. Ingreso al directorio
cd mlops-sunat-config-3.4.0/

# 5. Asignacion de permisos
chmod -R 777 .

# 6. Ejecucion del instalador para restaurar el estado anterior
bash desinstalador.sh
bash instalador.sh
```
