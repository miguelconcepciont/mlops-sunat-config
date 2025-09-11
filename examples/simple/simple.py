import ray
from ray import serve
from starlette.requests import Request

# Conexión al clúster remoto
if not ray.is_initialized():
    ray.init(address="ray://raycluster-kuberay-head-svc:10001")

serve.start(detached=True, http_options={"host": "0.0.0.0", "port": 8000})

@serve.deployment
class HolaMundo:
    def __init__(self):
        # Load model
        self.model = "hola"

    async def __call__(self, http_request: Request) -> str:
        return "hola mundo"

# Desplegar como aplicación Serve
serve.run(HolaMundo.bind(), name="hola_mundo_app", route_prefix="/hola")

print("App 'hola_mundo_app' desplegada en '/hola'")

#serve.shutdown()