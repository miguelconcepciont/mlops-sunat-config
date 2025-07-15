import ray
from ray import serve

# Conexión al clúster remoto
if not ray.is_initialized():
    ray.init(address="ray://raycluster-kuberay-head-svc:10001")

serve.start(detached=True, http_options={"host": "0.0.0.0", "port": 8000})

serve.shutdown()
