FROM jupyterhub/k8s-singleuser-sample:3.3.8

RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
    --index-url https://pypi.org/simple \
    pandas==2.3.0 \
    scikit-learn==1.7.0 \
    mlflow==2.22.0 \
    ray[default]==2.41.0