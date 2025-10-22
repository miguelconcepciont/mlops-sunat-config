# DOCUMENTO DE PASE A PRODUCCION MLOPS- HARDWARE

## 2. Configuración de software
### 2.2  Relación de software de aplicación instalados
La relación de aplicativos instalados para la plataforma MLOPS- SUNAT (Ver arquitectura en Anexo N° 02) es el siguiente:
| Software | Versión de helm chart| Versión de software| Función |
|-------------|---------------------------|---------|---------|
| PostgreSQL | 11.9.11 | latest | Se emplea como componente de base de datos para registrar los metadatos (métricas y parámetros) que se enviarán al gestor del ciclo de vida del modelo. |
| Mlflow | 0.18.0 | 2.22.1 | Gestor de datos/metadata del ciclo de vida del modelo. Rastrea experimentos, asegura reproducibilidad y automatiza tareas de ML como seguimiento, almacenamiento e implementación de modelos. |
| Ray Cluster | 1.3.0 | 2.41.0 | Sirve modelos de aprendizaje automático mediante una API, permitiendo el despliegue y escalamiento en producción. |
| MinIO | 11.10.9 | latest | Repositorio de artefactos (tablas, imágenes, modelos). Ofrece almacenamiento de objetos seguro, escalable y de alto rendimiento. |
| JupyterHub | 3.3.8 | 3.3.8 | Herramienta para análisis de datos y ML, permite crear y compartir notebooks, gestión de usuarios, autenticación y cifrado. |
| Jenkins | 12.2.2 | latest | Servidor de automatización para tareas de construcción, prueba, entrega o implementación de software. |
| csi-driver-nfs | 4.11.0 | v4.11.0 | Controlador CSI que permite montar volúmenes NFS como almacenamiento persistente en clústeres Kubernetes. |

#### 2.2.1 Librerías instaladas por componente
##### RayCluster
| Lenguaje | Librería | Versión |
| -------- | -------- | -------- |
| Python | absl-py | 2.3.1 |
| Python | aiohappyeyeballs | 2.6.1 |
| Python | aiohttp | 3.12.15 |
| Python | aiohttp-cors | 0.8.1 |
| Python | aiosignal | 1.4.0 |
| Python | alembic | 1.12.0 |
| Python | anaconda-anon-usage | 0.4.4 |
| Python | annotated-types | 0.7.0 |
| Python | anyio | 4.0.0 |
| Python | archspec | 0.2.3 |
| Python | astunparse | 1.6.3 |
| Python | async-timeout | 4.0.3 |
| Python | attrs | 23.1.0 |
| Python | backoff | 1.10.0 |
| Python | blinker | 1.9.0 |
| Python | blis | 1.2.1 |
| Python | boltons | 23.0.0 |
| Python | boto3 | 1.39.3 |
| Python | botocore | 1.39.17 |
| Python | Brotli | 1.1.0 |
| Python | cachetools | 5.5.2 |
| Python | catalogue | 2.0.10 |
| Python | catboost | 1.2.8 |
| Python | category_encoders | 2.8.1 |
| Python | certifi | 2025.8.3 |
| Python | cffi | 1.16.0 |
| Python | charset-normalizer | 3.3.2 |
| Python | click | 8.1.8 |
| Python | cloudpathlib | 0.23.0 |
| Python | cloudpickle | 3.0.0 |
| Python | colorful | 0.5.5 |
| Python | colorlog | 6.10.1 |
| Python | conda | 24.11.3 |
| Python | conda_package_streaming | 0.9.0 |
| Python | conda-content-trust | 0.2.0 |
| Python | conda-libmamba-solver | 24.1.0 |
| Python | conda-package-handling | 2.2.0 |
| Python | confection | 0.1.5 |
| Python | contourpy | 1.3.3 |
| Python | cramjam | 2.11.0 |
| Python | cryptography | 42.0.5 |
| Python | cupy-cuda12x | 13.1.0 |
| Python | cycler | 0.12.1 |
| Python | cymem | 2.0.11 |
| Python | Cython | 3.0.4 |
| Python | dask | 2025.10.0 |
| Python | databricks-sdk | 0.63.0 |
| Python | distlib | 0.3.7 |
| Python | distro | 1.9.0 |
| Python | dm-tree | 0.1.8 |
| Python | docker | 7.1.0 |
| Python | et_xmlfile | 2.0.0 |
| Python | Farama-Notifications | 0.0.4 |
| Python | fastapi | 0.109.2 |
| Python | fastparquet | 2024.11.0 |
| Python | fastrlock | 0.8.2 |
| Python | filelock | 3.19.1 |
| Python | Flask | 3.1.2 |
| Python | flatbuffers | 25.9.23 |
| Python | fonttools | 4.60.1 |
| Python | frozendict | 2.4.6 |
| Python | frozenlist | 1.7.0 |
| Python | fsspec | 2023.9.2 |
| Python | future | 1.0.0 |
| Python | gast | 0.6.0 |
| Python | gensim | 4.3.3 |
| Python | gitdb | 4.0.12 |
| Python | GitPython | 3.1.45 |
| Python | google-api-core | 2.25.1 |
| Python | google-api-python-client | 2.111.0 |
| Python | googleapis-common-protos | 1.70.0 |
| Python | google-auth | 2.23.4 |
| Python | google-auth-httplib2 | 0.1.1 |
| Python | google-oauth | 1.0.1 |
| Python | google-pasta | 0.2.0 |
| Python | graphene | 3.4.3 |
| Python | graphql-core | 3.2.6 |
| Python | graphql-relay | 3.2.0 |
| Python | graphviz | 0.21 |
| Python | greenlet | 3.2.4 |
| Python | grpcio | 1.74.0 |
| Python | gunicorn | 23.0.0 |
| Python | gymnasium | 1.0.0 |
| Python | h11 | 0.12.0 |
| Python | h5py | 3.15.1 |
| Python | hf-xet | 1.1.10 |
| Python | httplib2 | 0.20.4 |
| Python | httptools | 0.6.4 |
| Python | huggingface-hub | 0.35.3 |
| Python | hyperopt | 0.2.7 |
| Python | idna | 3.7 |
| Python | imageio | 2.37.0 |
| Python | imbalanced-learn | 0.14.0 |
| Python | importlib_metadata | 8.7.0 |
| Python | itsdangerous | 2.2.0 |
| Python | Jinja2 | 3.1.2 |
| Python | jmespath | 1.0.1 |
| Python | joblib | 1.5.2 |
| Python | jsonpatch | 1.33 |
| Python | jsonpointer | 2.1 |
| Python | jsonschema | 4.17.3 |
| Python | keras | 3.11.3 |
| Python | kiwisolver | 1.4.9 |
| Python | langcodes | 3.5.0 |
| Python | language_data | 1.3.0 |
| Python | lazy_loader | 0.4 |
| Python | libclang | 18.1.1 |
| Python | libmambapy | 1.5.8 |
| Python | lightgbm | 4.6.0 |
| Python | lime | 0.2.0.1 |
| Python | llvmlite | 0.45.1 |
| Python | locket | 1.0.0 |
| Python | lz4 | 4.3.3 |
| Python | Mako | 1.3.10 |
| Python | marisa-trie | 1.3.1 |
| Python | Markdown | 3.9 |
| Python | markdown-it-py | 2.2.0 |
| Python | MarkupSafe | 2.1.3 |
| Python | matplotlib | 3.10.7 |
| Python | mdurl | 0.1.2 |
| Python | memray | 1.10.0 |
| Python | menuinst | 2.0.2 |
| Python | ml_dtypes | 0.5.3 |
| Python | mlflow | 2.22.0 |
| Python | mlflow-skinny | 2.22.0 |
| Python | mlxtend | 0.23.4 |
| Python | mpmath | 1.3.0 |
| Python | msgpack | 1.0.7 |
| Python | multidict | 6.6.4 |
| Python | murmurhash | 1.0.13 |
| Python | namex | 0.1.0 |
| Python | narwhals | 2.9.0 |
| Python | networkx | 3.5 |
| Python | nltk | 3.9.2 |
| Python | numba | 0.62.1 |
| Python | numpy | 1.26.4 |
| Python | nvidia-cublas-cu12 | 12.8.4.1 |
| Python | nvidia-cuda-cupti-cu12 | 12.8.90 |
| Python | nvidia-cuda-nvrtc-cu12 | 12.8.93 |
| Python | nvidia-cuda-runtime-cu12 | 12.8.90 |
| Python | nvidia-cudnn-cu12 | 9.10.2.21 |
| Python | nvidia-cufft-cu12 | 11.3.3.83 |
| Python | nvidia-cufile-cu12 | 1.13.1.3 |
| Python | nvidia-curand-cu12 | 10.3.9.90 |
| Python | nvidia-cusolver-cu12 | 11.7.3.90 |
| Python | nvidia-cusparse-cu12 | 12.5.8.93 |
| Python | nvidia-cusparselt-cu12 | 0.7.1 |
| Python | nvidia-nccl-cu12 | 2.27.5 |
| Python | nvidia-nvjitlink-cu12 | 12.8.93 |
| Python | nvidia-nvshmem-cu12 | 3.3.20 |
| Python | nvidia-nvtx-cu12 | 12.8.90 |
| Python | opencensus | 0.11.4 |
| Python | opencensus-context | 0.1.3 |
| Python | openpyxl | 3.1.5 |
| Python | opentelemetry-api | 1.38.0 |
| Python | opentelemetry-exporter-otlp | 1.1.0 |
| Python | opentelemetry-exporter-otlp-proto-grpc | 1.1.0 |
| Python | opentelemetry-proto | 1.1.0 |
| Python | opentelemetry-sdk | 1.38.0 |
| Python | opentelemetry-semantic-conventions | 0.59b0 |
| Python | opt_einsum | 3.4.0 |
| Python | optree | 0.17.0 |
| Python | optuna | 4.5.0 |
| Python | ormsgpack | 1.7.0 |
| Python | packaging | 23.2 |
| Python | pandas | 2.1.1 |
| Python | partd | 1.4.2 |
| Python | patsy | 1.0.2 |
| Python | pillow | 12.0.0 |
| Python | pip | 25.1.1 |
| Python | platformdirs | 3.11.0 |
| Python | plotly | 6.3.1 |
| Python | pluggy | 1.6.0 |
| Python | polars | 1.34.0 |
| Python | polars-runtime-32 | 1.34.0 |
| Python | preshed | 3.0.10 |
| Python | prometheus-client | 0.19.0 |
| Python | propcache | 0.4.1 |
| Python | protobuf | 6.33.0 |
| Python | proto-plus | 1.26.1 |
| Python | psutil | 5.9.6 |
| Python | py4j | 0.10.9.9 |
| Python | pyarrow | 14.0.2 |
| Python | pyasn1 | 0.6.1 |
| Python | pyasn1_modules | 0.4.2 |
| Python | pycosat | 0.6.6 |
| Python | pycparser | 2.21 |
| Python | pydantic | 2.5.0 |
| Python | pydantic_core | 2.14.1 |
| Python | Pygments | 2.18.0 |
| Python | pyOpenSSL | 24.2.1 |
| Python | pyparsing | 3.1.1 |
| Python | pyrsistent | 0.20.0 |
| Python | PySocks | 1.7.1 |
| Python | py-spy | 0.4.1 |
| Python | python-dateutil | 2.8.2 |
| Python | python-dotenv | 1.1.1 |
| Python | pytz | 2023.3.post1 |
| Python | PyYAML | 6.0.1 |
| Python | ray | 2.41.0 |
| Python | redis | 4.4.2 |
| Python | regex | 2025.9.18 |
| Python | requests | 2.32.4 |
| Python | rich | 14.0.0 |
| Python | rsa | 4.9.1 |
| Python | ruamel.yaml | 0.17.39 |
| Python | ruamel.yaml.clib | 0.2.14 |
| Python | s3transfer | 0.13.1 |
| Python | safetensors | 0.6.2 |
| Python | scikit-image | 0.25.2 |
| Python | scikit-learn | 1.7.1 |
| Python | scipy | 1.13.1 |
| Python | seaborn | 0.13.2 |
| Python | sentence-transformers | 5.1.1 |
| Python | setuptools | 71.1.0 |
| Python | shap | 0.49.1 |
| Python | shellingham | 1.5.4 |
| Python | six | 1.16.0 |
| Python | slicer | 0.0.8 |
| Python | smart-open | 6.2.0 |
| Python | smmap | 5.0.2 |
| Python | sniffio | 1.3.1 |
| Python | spacy | 3.8.7 |
| Python | spacy-legacy | 3.0.12 |
| Python | spacy-loggers | 1.0.5 |
| Python | SQLAlchemy | 2.0.44 |
| Python | sqlparse | 0.5.3 |
| Python | srsly | 2.5.1 |
| Python | starlette | 0.36.3 |
| Python | statsmodels | 0.14.5 |
| Python | sympy | 1.14.0 |
| Python | tensorboard | 2.20.0 |
| Python | tensorboard-data-server | 0.7.2 |
| Python | tensorboardX | 2.6.2.2 |
| Python | tensorflow | 2.20.0 |
| Python | termcolor | 3.1.0 |
| Python | thinc | 8.3.4 |
| Python | threadpoolctl | 3.6.0 |
| Python | tifffile | 2025.10.16 |
| Python | tokenizers | 0.22.1 |
| Python | toolz | 1.1.0 |
| Python | torch | 2.9.0 |
| Python | torch_cluster | 1.6.3 |
| Python | torch_scatter | 2.1.2 |
| Python | torch_sparse | 0.6.18 |
| Python | torch_spline_conv | 1.2.2 |
| Python | torchaudio | 2.9.0 |
| Python | torch-geometric | 2.7.0 |
| Python | torchvision | 0.24.0 |
| Python | tqdm | 4.66.2 |
| Python | transformers | 4.57.1 |
| Python | triton | 3.5.0 |
| Python | truststore | 0.8.0 |
| Python | typer | 0.20.0 |
| Python | typing_extensions | 4.15.0 |
| Python | tzdata | 2025.2 |
| Python | uritemplate | 4.1.1 |
| Python | urllib3 | 1.26.20 |
| Python | uvicorn | 0.35.0 |
| Python | uvloop | 0.21.0 |
| Python | virtualenv | 20.34.0 |
| Python | wasabi | 1.1.3 |
| Python | watchfiles | 1.1.0 |
| Python | weasel | 0.4.1 |
| Python | websockets | 15.0.1 |
| Python | Werkzeug | 3.1.3 |
| Python | wheel | 0.43.0 |
| Python | wordcloud | 1.9.4 |
| Python | wrapt | 2.0.0 |
| Python | xgboost | 3.0.5 |
| Python | xlrd | 2.0.1 |
| Python | xlsxwriter | 3.2.9 |
| Python | xxhash | 3.6.0 |
| Python | yarl | 1.20.1 |
| Python | zipp | 3.23.0 |
| Python | zstandard | 0.22.0 |
##### JupyterHubSingleUser
| Lenguaje | Librería | Versión |
| -------- | -------- | -------- |
| Python | absl-py | 2.3.1 |
| Python | aiohappyeyeballs | 2.6.1 |
| Python | aiohttp | 3.13.1 |
| Python | aiohttp-cors | 0.8.1 |
| Python | aiosignal | 1.4.0 |
| Python | alembic | 1.12.0 |
| Python | altair | 5.1.2 |
| Python | annotated-types | 0.7.0 |
| Python | ansicolors | 1.1.8 |
| Python | anyio | 4.0.0 |
| Python | appengine-python-standard | 1.1.10 |
| Python | argon2-cffi | 23.1.0 |
| Python | argon2-cffi-bindings | 21.2.0 |
| Python | arrow | 1.3.0 |
| Python | astroid | 3.3.11 |
| Python | asttokens | 2.4.0 |
| Python | astunparse | 1.6.3 |
| Python | async-generator | 1.1 |
| Python | async-lru | 2.0.4 |
| Python | attrs | 23.1.0 |
| Python | autopep8 | 2.0.4 |
| Python | Babel | 2.13.0 |
| Python | backcall | 0.2.0 |
| Python | backports.functools-lru-cache | 1.6.5 |
| Python | beautifulsoup4 | 4.12.2 |
| Python | black | 25.9.0 |
| Python | bleach | 6.1.0 |
| Python | blinker | 1.9.0 |
| Python | blis | 1.2.1 |
| Python | bokeh | 3.3.0 |
| Python | boltons | 23.0.0 |
| Python | boto3 | 1.39.3 |
| Python | botocore | 1.39.17 |
| Python | Bottleneck | 1.3.7 |
| Python | Brotli | 1.1.0 |
| Python | cached-property | 1.5.2 |
| Python | cachetools | 5.5.2 |
| Python | catalogue | 2.0.10 |
| Python | catboost | 1.2.8 |
| Python | category_encoders | 2.8.1 |
| Python | certifi | 2025.10.5 |
| Python | certipy | 0.1.3 |
| Python | cffi | 1.16.0 |
| Python | charset-normalizer | 3.3.0 |
| Python | clarabel | 0.11.1 |
| Python | click | 8.1.8 |
| Python | click-option-group | 0.5.7 |
| Python | cloudpathlib | 0.23.0 |
| Python | cloudpickle | 3.0.0 |
| Python | colorama | 0.4.6 |
| Python | colorful | 0.5.7 |
| Python | colorlog | 6.10.1 |
| Python | comm | 0.1.4 |
| Python | conda | 23.9.0 |
| Python | conda_package_streaming | 0.9.0 |
| Python | conda-package-handling | 2.2.0 |
| Python | confection | 0.1.5 |
| Python | contourpy | 1.1.1 |
| Python | cramjam | 2.11.0 |
| Python | cryptography | 41.0.4 |
| Python | cvxpy | 1.7.3 |
| Python | cycler | 0.12.1 |
| Python | cymem | 2.0.11 |
| Python | Cython | 3.0.4 |
| Python | cytoolz | 0.12.2 |
| Python | dask | 2025.10.0 |
| Python | databricks-sdk | 0.69.0 |
| Python | debugpy | 1.8.0 |
| Python | decorator | 5.1.1 |
| Python | deepchecks | 0.19.1 |
| Python | defusedxml | 0.7.1 |
| Python | deprecation | 2.1.0 |
| Python | dill | 0.3.7 |
| Python | distlib | 0.4.0 |
| Python | distributed | 2023.10.0 |
| Python | docker | 7.1.0 |
| Python | docstring_parser | 0.17.0 |
| Python | docstring-to-markdown | 0.17 |
| Python | elyra-examples-kfp-catalog | 0.1.0 |
| Python | entrypoints | 0.4 |
| Python | et-xmlfile | 1.1.0 |
| Python | exceptiongroup | 1.1.3 |
| Python | executing | 1.2.0 |
| Python | fastapi | 0.109.2 |
| Python | fastjsonschema | 2.18.1 |
| Python | fastparquet | 2024.11.0 |
| Python | filelock | 3.20.0 |
| Python | findspark | 2.0.1 |
| Python | flake8 | 7.1.2 |
| Python | Flask | 3.1.2 |
| Python | flatbuffers | 25.9.23 |
| Python | fonttools | 4.43.1 |
| Python | fqdn | 1.5.1 |
| Python | frozendict | 2.4.6 |
| Python | frozenlist | 1.8.0 |
| Python | fsspec | 2023.9.2 |
| Python | future | 1.0.0 |
| Python | gast | 0.6.0 |
| Python | gensim | 4.3.3 |
| Python | gitdb | 4.0.10 |
| Python | GitPython | 3.1.40 |
| Python | gmpy2 | 2.1.2 |
| Python | google-api-core | 2.26.0 |
| Python | googleapis-common-protos | 1.71.0 |
| Python | google-auth | 2.41.1 |
| Python | google-cloud-core | 2.4.3 |
| Python | google-cloud-storage | 3.4.1 |
| Python | google-crc32c | 1.7.1 |
| Python | google-pasta | 0.2.0 |
| Python | google-resumable-media | 2.7.2 |
| Python | graphene | 3.4.3 |
| Python | graphql-core | 3.2.6 |
| Python | graphql-relay | 3.2.0 |
| Python | graphviz | 0.21 |
| Python | greenlet | 3.0.0 |
| Python | grpcio | 1.75.1 |
| Python | gunicorn | 23.0.0 |
| Python | h11 | 0.16.0 |
| Python | h5py | 3.15.1 |
| Python | hf-xet | 1.1.10 |
| Python | httpcore | 1.0.9 |
| Python | httptools | 0.7.1 |
| Python | httpx | 0.28.1 |
| Python | huggingface-hub | 0.35.3 |
| Python | hyperopt | 0.2.7 |
| Python | idna | 3.4 |
| Python | imagecodecs | 2025.8.2 |
| Python | imageio | 2.31.5 |
| Python | imbalanced-learn | 0.14.0 |
| Python | immutabledict | 4.2.2 |
| Python | importlib-metadata | 6.8.0 |
| Python | importlib-resources | 6.1.0 |
| Python | iniconfig | 2.3.0 |
| Python | ipykernel | 6.25.2 |
| Python | ipympl | 0.9.3 |
| Python | ipython | 8.16.1 |
| Python | ipython-genutils | 0.2.0 |
| Python | ipywidgets | 8.1.1 |
| Python | isoduration | 20.11.0 |
| Python | isort | 6.1.0 |
| Python | itsdangerous | 2.2.0 |
| Python | jedi | 0.19.1 |
| Python | Jinja2 | 3.1.2 |
| Python | jmespath | 1.0.1 |
| Python | joblib | 1.3.2 |
| Python | json5 | 0.9.14 |
| Python | jsonpatch | 1.33 |
| Python | jsonpickle | 4.1.1 |
| Python | jsonpointer | 2.4 |
| Python | jsonschema | 4.19.1 |
| Python | jsonschema-specifications | 2023.7.1 |
| Python | jupyter_client | 8.4.0 |
| Python | jupyter_core | 5.4.0 |
| Python | jupyter_packaging | 0.12.3 |
| Python | jupyter_server | 2.8.0 |
| Python | jupyter_server_terminals | 0.4.4 |
| Python | jupyter-events | 0.8.0 |
| Python | jupyterhub | 4.0.2 |
| Python | jupyterlab | 4.4.9 |
| Python | jupyterlab_git | 0.51.2 |
| Python | jupyterlab_server | 2.27.3 |
| Python | jupyterlab-lsp | 5.1.1 |
| Python | jupyterlab-pygments | 0.2.2 |
| Python | jupyterlab-widgets | 3.0.9 |
| Python | jupyter-lsp | 2.2.0 |
| Python | jupyter-resource-usage | 1.1.1 |
| Python | jupyter-server-mathjax | 0.2.6 |
| Python | jupyter-telemetry | 0.1.0 |
| Python | keras | 3.11.3 |
| Python | kfp | 2.14.6 |
| Python | kfp-kubernetes | 2.14.6 |
| Python | kfp-pipeline-spec | 2.14.6 |
| Python | kfp-server-api | 2.14.6 |
| Python | kiwisolver | 1.4.5 |
| Python | kubernetes | 30.1.0 |
| Python | langcodes | 3.5.0 |
| Python | language_data | 1.3.0 |
| Python | lazy_loader | 0.3 |
| Python | legacy-cgi | 2.6.3 |
| Python | libclang | 18.1.1 |
| Python | libmambapy | 1.5.2 |
| Python | lightgbm | 4.6.0 |
| Python | lime | 0.2.0.1 |
| Python | llvmlite | 0.45.1 |
| Python | locket | 1.0.0 |
| Python | lz4 | 4.4.4 |
| Python | Mako | 1.2.4 |
| Python | mamba | 1.5.2 |
| Python | marisa-trie | 1.3.1 |
| Python | Markdown | 3.9 |
| Python | markdown-it-py | 4.0.0 |
| Python | MarkupSafe | 2.1.3 |
| Python | mat4py | 0.6.0 |
| Python | matplotlib | 3.8.0 |
| Python | matplotlib-inline | 0.1.6 |
| Python | mccabe | 0.7.0 |
| Python | mdurl | 0.1.2 |
| Python | minio | 7.2.18 |
| Python | missingno | 0.5.2 |
| Python | mistune | 3.0.1 |
| Python | ml_dtypes | 0.5.3 |
| Python | mlflow | 2.22.0 |
| Python | mlflow-export-import | 1.2.0 |
| Python | mlflow-skinny | 2.22.0 |
| Python | mlxtend | 0.23.4 |
| Python | mock | 5.2.0 |
| Python | mpmath | 1.3.0 |
| Python | msgpack | 1.0.6 |
| Python | multidict | 6.7.0 |
| Python | munkres | 1.1.4 |
| Python | murmurhash | 1.0.13 |
| Python | mypy_extensions | 1.1.0 |
| Python | namex | 0.1.0 |
| Python | narwhals | 2.9.0 |
| Python | nbclassic | 1.0.0 |
| Python | nbclient | 0.10.2 |
| Python | nbconvert | 7.9.2 |
| Python | nbdime | 4.0.2 |
| Python | nbformat | 5.9.2 |
| Python | nest-asyncio | 1.5.8 |
| Python | networkx | 3.5 |
| Python | nltk | 3.9.2 |
| Python | notebook | 7.0.6 |
| Python | notebook_shim | 0.2.3 |
| Python | numba | 0.62.1 |
| Python | numexpr | 2.8.7 |
| Python | numpy | 1.26.4 |
| Python | nvidia-cublas-cu12 | 12.8.4.1 |
| Python | nvidia-cuda-cupti-cu12 | 12.8.90 |
| Python | nvidia-cuda-nvrtc-cu12 | 12.8.93 |
| Python | nvidia-cuda-runtime-cu12 | 12.8.90 |
| Python | nvidia-cudnn-cu12 | 9.10.2.21 |
| Python | nvidia-cufft-cu12 | 11.3.3.83 |
| Python | nvidia-cufile-cu12 | 1.13.1.3 |
| Python | nvidia-curand-cu12 | 10.3.9.90 |
| Python | nvidia-cusolver-cu12 | 11.7.3.90 |
| Python | nvidia-cusparse-cu12 | 12.5.8.93 |
| Python | nvidia-cusparselt-cu12 | 0.7.1 |
| Python | nvidia-nccl-cu12 | 2.27.5 |
| Python | nvidia-nvjitlink-cu12 | 12.8.93 |
| Python | nvidia-nvshmem-cu12 | 3.3.20 |
| Python | nvidia-nvtx-cu12 | 12.8.90 |
| Python | oauthlib | 3.2.2 |
| Python | odh-elyra | 4.2.2 |
| Python | opencensus | 0.11.4 |
| Python | opencensus-context | 0.1.3 |
| Python | openpyxl | 3.1.5 |
| Python | opentelemetry-api | 1.38.0 |
| Python | opentelemetry-sdk | 1.38.0 |
| Python | opentelemetry-semantic-conventions | 0.59b0 |
| Python | opt_einsum | 3.4.0 |
| Python | optbinning | 0.20.1 |
| Python | optree | 0.17.0 |
| Python | optuna | 4.5.0 |
| Python | ortools | 9.10.4067 |
| Python | osqp | 1.0.5 |
| Python | overrides | 7.4.0 |
| Python | packaging | 23.2 |
| Python | pamela | 1.1.0 |
| Python | pandas | 2.1.1 |
| Python | pandocfilters | 1.5.0 |
| Python | papermill | 2.6.0 |
| Python | parso | 0.8.3 |
| Python | partd | 1.4.1 |
| Python | pathspec | 0.12.1 |
| Python | patsy | 1.0.2 |
| Python | pexpect | 4.9.0 |
| Python | pickleshare | 0.7.5 |
| Python | pillow | 11.3.0 |
| Python | pip | 25.1.1 |
| Python | pkgutil_resolve_name | 1.3.10 |
| Python | platformdirs | 3.11.0 |
| Python | plotly | 6.3.1 |
| Python | pluggy | 1.6.0 |
| Python | polars | 1.34.0 |
| Python | polars-runtime-32 | 1.34.0 |
| Python | preshed | 3.0.10 |
| Python | prometheus-client | 0.17.1 |
| Python | prompt-toolkit | 3.0.39 |
| Python | propcache | 0.4.1 |
| Python | protobuf | 6.31.1 |
| Python | proto-plus | 1.26.1 |
| Python | psutil | 5.9.5 |
| Python | psycopg2-binary | 2.9.10 |
| Python | ptyprocess | 0.7.0 |
| Python | pure-eval | 0.2.2 |
| Python | pure-sasl | 0.6.2 |
| Python | py4j | 0.10.9.9 |
| Python | pyarrow | 21.0.0 |
| Python | pyasn1 | 0.6.1 |
| Python | pyasn1_modules | 0.4.2 |
| Python | pycodestyle | 2.12.1 |
| Python | pycosat | 0.6.6 |
| Python | pycparser | 2.21 |
| Python | py-cpuinfo | 9.0.0 |
| Python | pycryptodome | 3.23.0 |
| Python | pycurl | 7.45.1 |
| Python | pydantic | 2.5.0 |
| Python | pydantic_core | 2.14.1 |
| Python | pydocstyle | 6.3.0 |
| Python | pyflakes | 3.2.0 |
| Python | PyGithub | 2.8.1 |
| Python | Pygments | 2.16.1 |
| Python | PyHive | 0.7.0 |
| Python | PyJWT | 2.8.0 |
| Python | pylint | 3.3.9 |
| Python | PyNaCl | 1.6.0 |
| Python | PyNomaly | 0.3.4 |
| Python | pyOpenSSL | 23.2.0 |
| Python | pyparsing | 3.1.1 |
| Python | pyreadstat | 1.3.0 |
| Python | PySocks | 1.7.1 |
| Python | py-spy | 0.4.1 |
| Python | pytest | 8.4.2 |
| Python | pytest-html | 4.1.1 |
| Python | pytest-metadata | 3.1.1 |
| Python | python-dateutil | 2.8.2 |
| Python | python-dotenv | 1.1.1 |
| Python | python-gitlab | 6.5.0 |
| Python | python-json-logger | 2.0.7 |
| Python | python-lsp-jsonrpc | 1.1.2 |
| Python | python-lsp-server | 1.13.1 |
| Python | python-utils | 3.9.1 |
| Python | pytokens | 0.2.0 |
| Python | pytoolconfig | 1.3.1 |
| Python | pytz | 2023.3.post1 |
| Python | PyWavelets | 1.4.1 |
| Python | PyYAML | 6.0.1 |
| Python | pyzmq | 25.1.1 |
| Python | ray | 2.41.0 |
| Python | referencing | 0.30.2 |
| Python | regex | 2025.9.18 |
| Python | requests | 2.32.5 |
| Python | requests-oauthlib | 2.0.0 |
| Python | requests-toolbelt | 1.0.0 |
| Python | rfc3339-validator | 0.1.4 |
| Python | rfc3986-validator | 0.1.1 |
| Python | rich | 14.0.0 |
| Python | rope | 1.14.0 |
| Python | ropwr | 1.1.0 |
| Python | rpds-py | 0.10.6 |
| Python | rsa | 4.9.1 |
| Python | ruamel.yaml | 0.17.39 |
| Python | ruamel.yaml.clib | 0.2.7 |
| Python | s3transfer | 0.13.1 |
| Python | safetensors | 0.6.2 |
| Python | scikit-image | 0.22.0 |
| Python | scikit-learn | 1.7.2 |
| Python | scipy | 1.13.1 |
| Python | scs | 3.2.9 |
| Python | seaborn | 0.13.2 |
| Python | Send2Trash | 1.8.2 |
| Python | sentence-transformers | 5.1.1 |
| Python | setuptools | 68.2.2 |
| Python | shap | 0.49.1 |
| Python | shellingham | 1.5.4 |
| Python | shortuuid | 1.0.13 |
| Python | six | 1.16.0 |
| Python | slicer | 0.0.8 |
| Python | smart_open | 7.4.0 |
| Python | smartdeploy | 0.1.0 |
| Python | smmap | 3.0.5 |
| Python | sniffio | 1.3.0 |
| Python | snowballstemmer | 3.0.1 |
| Python | sortedcontainers | 2.4.0 |
| Python | soupsieve | 2.5 |
| Python | spacy | 3.8.7 |
| Python | spacy-legacy | 3.0.12 |
| Python | spacy-loggers | 1.0.5 |
| Python | SQLAlchemy | 2.0.22 |
| Python | sqlparse | 0.5.3 |
| Python | srsly | 2.5.1 |
| Python | stack-data | 0.6.2 |
| Python | starlette | 0.36.3 |
| Python | statsmodels | 0.14.5 |
| Python | sympy | 1.14.0 |
| Python | tables | 3.10.2 |
| Python | tabulate | 0.9.0 |
| Python | tblib | 2.0.0 |
| Python | tenacity | 9.1.2 |
| Python | tensorboard | 2.20.0 |
| Python | tensorboard-data-server | 0.7.2 |
| Python | tensorflow | 2.20.0 |
| Python | termcolor | 3.1.0 |
| Python | terminado | 0.17.1 |
| Python | thinc | 8.3.4 |
| Python | threadpoolctl | 3.2.0 |
| Python | thrift | 0.22.0 |
| Python | thrift-sasl | 0.4.3 |
| Python | tifffile | 2023.9.26 |
| Python | tinycss2 | 1.2.1 |
| Python | tokenizers | 0.22.1 |
| Python | tomli | 2.0.1 |
| Python | tomlkit | 0.13.3 |
| Python | toolz | 0.12.0 |
| Python | torch | 2.9.0 |
| Python | torchaudio | 2.9.0 |
| Python | torch_cluster | 1.6.3 |
| Python | torch-geometric | 2.7.0 |
| Python | torch_scatter | 2.1.2 |
| Python | torch_sparse | 0.6.18 |
| Python | torch_spline_conv | 1.2.2 |
| Python | torchvision | 0.24.0 |
| Python | toree | 0.5.0 |
| Python | tornado | 6.3.3 |
| Python | tqdm | 4.66.1 |
| Python | traitlets | 5.11.2 |
| Python | transformers | 4.57.1 |
| Python | triton | 3.5.0 |
| Python | truststore | 0.8.0 |
| Python | typer | 0.20.0 |
| Python | types-python-dateutil | 2.8.19.14 |
| Python | typing_extensions | 4.15.0 |
| Python | typing-utils | 0.1.0 |
| Python | tzdata | 2023.3 |
| Python | ujson | 5.11.0 |
| Python | uri-template | 1.3.0 |
| Python | urllib3 | 1.26.20 |
| Python | uvicorn | 0.38.0 |
| Python | uvloop | 0.22.1 |
| Python | virtualenv | 20.35.3 |
| Python | wasabi | 1.1.3 |
| Python | watchdog | 6.0.0 |
| Python | watchfiles | 1.1.1 |
| Python | wcwidth | 0.2.8 |
| Python | weasel | 0.4.1 |
| Python | webcolors | 1.13 |
| Python | webencodings | 0.5.1 |
| Python | websocket-client | 1.6.4 |
| Python | websockets | 15.0.1 |
| Python | Werkzeug | 3.1.3 |
| Python | whatthepatch | 1.0.7 |
| Python | wheel | 0.41.2 |
| Python | widgetsnbextension | 4.0.9 |
| Python | wordcloud | 1.9.4 |
| Python | wrapt | 2.0.0 |
| Python | xgboost | 3.0.5 |
| Python | xlrd | 2.0.1 |
| Python | xlsxwriter | 3.2.9 |
| Python | xxhash | 3.6.0 |
| Python | xyzservices | 2023.10.0 |
| Python | yapf | 0.43.0 |
| Python | yarl | 1.22.0 |
| Python | yaspin | 3.3.0 |
| Python | zict | 3.0.0 |
| Python | zipp | 3.17.0 |
| Python | zstandard | 0.25.0 |

| Lenguaje | Librería |
| -------- | -------- | 
| R | r-broom |
| R | r-caret |
| R | r-data.table |
| R | r-dataexplorer |
| R | r-desctools |
| R | r-dplyr |
| R | r-dummies |
| R | r-hmisc |
| R | r-mlmetrics |
| R | r-rattle |
| R | r-rcolorbrewer |
| R | r-readxl |
| R | r-rocr |
| R | r-rose |
| R | r-rpart |
| R | r-rpart.plot |
| R | r-scorecard |
| R | r-themis |
| R | r-tidyverse |
| R | r-unbalanced |
| R | r-xgboost |

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

- **Nueva(s) imagen(es)** a implementar.  
- **URL de descarga** del paquete comprimido (`.zip`) correspondiente a la nueva versión del repositorio `mlops-sunat-config`.

📩 **Ejemplo de mensaje:**

> **Asunto:** Nueva imagen y versión disponible para despliegue MLOps-SUNAT  
> Estimado,  
> Se encuentra disponible la nueva imagen:  
> - `<imagen-1>`: repositorio/scipy-notebook:python-3.11-sunat-v8
> - `<archivo-imagen-1>`: repositorio-scipy-notebook-python-3.11-sunat-v8
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
docker pull <imagen-1>

# Guardar imagen como archivo tar
docker save -o <archivo-imagen-1>.tar <imagen-1>

# Cargar imagen local
docker load -i <archivo-imagen-1>.tar

# Etiquetar con destino repositorio Sunat
docker tag <imagen-1> vcf-np-w2-harbor-az1.sunat.peru/mlops/<imagen-1>

# Subir imagen a repositorio Sunat
docker push vcf-np-w2-harbor-az1.sunat.peru/mlops/<imagen-1>
```

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