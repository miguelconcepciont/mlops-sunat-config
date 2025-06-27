import ray
from ray import serve
from fastapi import FastAPI
from starlette.requests import Request

# Conectarse al cluster solo si no está inicializado
if not ray.is_initialized():
    ray.init(address="ray://raycluster-kuberay-head-svc.default.svc.cluster.local:10001")

# Iniciar Serve
serve.start(detached=True)

# Crear FastAPI app
app = FastAPI()

@app.get("/")
async def hello(request: Request):
    return {"mensaje": "Hola mundo desde Ray Serve"}

# Crear clase de entrada a Serve
from ray.serve import Deployment

@serve.deployment
@serve.ingress(app)
class HolaRay:
    pass

# Bind del deployment
deployment = HolaRay.bind()

# Ejecutar con route_prefix correcto
serve.run(deployment, name="hola-ray", route_prefix="/hola")