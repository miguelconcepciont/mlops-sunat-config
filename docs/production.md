# DOCUMENTO DE PASE A PRODUCCION MLOPS- HARDWARE

## 2. Configuración de software
### 2.2  Relación de software de aplicación instalados
La relación de aplicativos instalados para la plataforma MLOPS- SUNAT (Ver arquitectura en Anexo N° 02) es el siguiente:
| Software | Versión de helm chart| Versión de software| Función |
|-------------|---------------------------|---------|---------|
| PostgreSQL | 11.9.11 | latest | Se emplea como componente de base de datos para registrar los metadatos (métricas y parámetros) que se enviarán al gestor del ciclo de vida del modelo. |
| Mlflow | 0.18.0 | 2.22.1 | Gestor de datos/metadata del ciclo de vida del modelo. Rastrea experimentos, asegura reproducibilidad y automatiza tareas de ML como seguimiento, almacenamiento e implementación de modelos. |
| Ray Cluster | 1.3.0 | 2.41.0-py311-sunat-v6 | Sirve modelos de aprendizaje automático mediante una API, permitiendo el despliegue y escalamiento en producción. |
| MinIO | 11.10.9 | latest | Repositorio de artefactos (tablas, imágenes, modelos). Ofrece almacenamiento de objetos seguro, escalable y de alto rendimiento. |
| JupyterHub | 3.3.8 | 3.3.8 | Herramienta para análisis de datos y ML, permite crear y compartir notebooks, gestión de usuarios, autenticación y cifrado. |
| Jenkins | 12.2.2 | latest | Servidor de automatización para tareas de construcción, prueba, entrega o implementación de software. |
| csi-driver-nfs | 4.11.0 | v4.11.0 | Controlador CSI que permite montar volúmenes NFS como almacenamiento persistente en clústeres Kubernetes. |

#### 2.2.1 Librerías instaladas por componente
##### RayCluster
| Lenguaje | Librerías instaladas |
| -------- | --------------------------- |
| Python   | `mlflow==2.22.0`, `boto3==1.39.3`, `scikit-learn==1.7.1`, `category-encoders==2.8.1`, `cloudpickle==3.0.0`, `aiohttp==3.12.15`, `aiohttp-cors==0.8.1`, `aiosignal==1.4.0`, `alembic==1.12.0`, `annotated-types==0.7.0`, `anyio==4.0.0`, `attrs==23.1.0`, `Brotli==1.1.0`, `cachetools==5.5.2`, `certifi==2025.8.3`, `click==8.1.8`, `Cython==3.0.4`, `databricks-sdk==0.63.0`, `filelock==3.19.1`, `frozendict==2.4.6`, `frozenlist==1.7.0`, `fsspec==2023.9.2`, `google-api-core==2.25.1`, `googleapis-common-protos==1.70.0`, `grpcio==1.74.0`, `multidict==6.6.4`, `opencensus==0.11.4`, `packaging==23.2`, `pandas==2.1.1`, `pip==25.1.1`, `pluggy==1.6.0`, `py-spy==0.4.1`, `pyasn1==0.6.1`, `pyasn1_modules==0.4.2`, `python-dotenv==1.1.1`, `pytz==2023.3.post1`, `requests==2.32.4`, `rich==14.0.0`, `rsa==4.9.1`, `ruamel.yaml==0.17.39`, `scipy==1.16.1`, `urllib3==1.26.20`, `uvicorn==0.35.0`, `uvloop==0.21.0`, `virtualenv==20.34.0`, `watchfiles==1.1.0`, `websockets==15.0.1`, `yarl==1.20.1`, `imbalanced-learn==0.14.0` |
##### JupyterHubSingleUser
| Lenguaje | Librerías instaladas |
| -------- | --------------------------- |
| Python   | `mlflow==2.22.0`, `rich==14.0.0`, `deepchecks==0.19.1`, `fastapi==0.109.2`, `ray[serve]==2.41.0`, `boto3==1.39.3`, `findspark==2.0.1`, `protobuf==6.31.1`, `smartdeploy (desde GitHub)`, `pydantic==2.5.0`, `thrift-sasl==0.4.3`, `thrift==0.22.0`, `PyHive==0.7.0`, `missingno==0.5.2`, `imbalanced-learn==0.14.0`, `psycopg2-binary==2.9.10`, `openpyxl==3.1.5`, `optbinning==0.20.1`, `mat4py==0.6.0`, `pyreadstat==1.3.0`, `statsmodels==0.14.5`, `wordcloud==1.9.4`, `mlflow-export-import==1.2.0`, `pexpect>=4.9.0`, `ptyprocess>=0.7.0`, `jupyterlab-git>=0.51.0` |
| R        | `r-data.table`, `r-mlmetrics`, `r-dplyr`, `r-tidyverse`, `r-broom`, `r-caret`, `r-dummies`, `r-scorecard`, `r-readxl`, `r-dataexplorer`, `r-desctools`, `r-unbalanced`, `r-rpart`, `r-rpart.plot`, `r-rattle`, `r-rcolorbrewer`, `r-rose`, `r-rocr`, `r-xgboost`, `r-hmisc`, `r-themis` |

Otros paquetes y herramientas instaladas en el contenedor base
- **Base container**: jupyter/scipy-notebook:python-3.11
- **Node.js**: instalado vía nodesource (v16)
- **OpenJDK**: openjdk-17-jdk
- **Elyra**: odh-elyra[all]==4.2.2
- **Apache Toree**: toree==0.5.0 (interpretes: Scala, PySpark, SparkSQL, SparkR, SQL)

#### 2.2.2 Instalación Redis
<Agregar ticket de creación de NFS server (detallado) Aprobado con control de cambios>
#### 2.2.3 Instalación NFS Server
<Agregar ticket de creación de los servidores Redis (detallado) Aprobado con control de cambios>
### 3.2 Procedimiento para Activar Servicios y/o equipo
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
### 3.3 Procedimiento para Apagar Servicios y/o equipo
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
bash desinstalador.sh
```
### 3.5 Procedimiento de recuperación en caso de fallas
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
#### d. Ejecutar desinstalación:
```bash
bash desinstalador.sh
```
#### e. Ejecutar instalación:
```bash
bash instalador.sh
```
#### f. Comprobar estados de pods:
```bash
kubectl get pods
```
### 3.6 Procedimiento de instalación de nueva imagen
#### a. Enviar correo al Analista de Arquitectura
El **Analista de DGTI** debe enviar por correo al **Analista de Arquitectura** la siguiente información:

- **Nombre de la(s) nueva(s) imagen(es)** a implementar.  
- **Etiqueta (tag)** asociada a cada imagen.  
- **Repositorio de origen** (por ejemplo, Docker Hub).  
- **URL de descarga** del paquete comprimido (`.zip`) correspondiente a la nueva versión del repositorio `mlops-sunat-config`.

📩 **Ejemplo de mensaje:**

> **Asunto:** Nueva imagen y versión disponible para despliegue MLOps-SUNAT  
> Estimado,  
> Se encuentra disponible la nueva imagen:  
> Imagen 1: `<imagen_origen>:<tag>`
> 
> Y la nueva versión del proyecto:  
> URL de descarga: `<url-descarga-nueva-version>`  
>  
> Finalmente, ejecutar los pasos 3.6.b, 3.6.c, 3.6.d, 3.6.e, 3.6.f, 3.6.g, 3.6.h del DOCUMENTO DE PASE A PRODUCCION MLOPS- HARDWARE
>  
> Saludos,  
> Analista de DGTI


#### b. Cargar en el repositorio privado de SUNAT
El **Analista de Arquitectura** debe ejecutar los siguientes comandos en el servidor con acceso a Docker Hub y al registro privado de SUNAT:

```bash
# Descargar imagen desde Docker Hub
docker pull <imagen_origen>:<tag>

# Guardar imagen como archivo tar
docker save -o <nombre-archivo>.tar <imagen_origen>:<tag>

# Cargar imagen local
docker load -i <nombre-archivo>.tar

# Etiquetar con destino Harbor
docker tag <imagen_origen>:<tag> vcf-np-w2-harbor-az1.sunat.peru/mlops/<imagen_destino>:<tag>

# Subir imagen a Harbor
docker push vcf-np-w2-harbor-az1.sunat.peru/mlops/<imagen_destino>:<tag>
```

> Ejemplo:  
> `<imagen_origen>` = `miguelsff/ray`  
> `<imagen_destino>` = `miguelsff/ray`  
> `<tag>` = `2.41.0-py311-sunat-vX`

---
#### c. Ejecutar en **todos los clústers**

> **Responsable:** Analista de Arquitectura  
> **Requisito:** tener `kubectl` con el contexto del clúster y permisos de administrador.  
> La **URL de la nueva versión** es la proporcionada en el correo del Analista de DGTI.

#### d. Descargar nueva versión
```bash
wget <url-descarga-nueva-version>
```
#### e. Descomprimir:
```bash
unzip <archivo-version>.zip
cd <carpeta-version>
```
#### f. Asignar permisos:
```bash
chmod -R 777 .
```
#### g. Ejecutar desinstalación:
```bash
bash desinstalador.sh
```
#### h. Ejecutar instalación:
```bash
bash instalador.sh
```
#### i. Comprobar estados de pods:
```bash
kubectl get pods
```