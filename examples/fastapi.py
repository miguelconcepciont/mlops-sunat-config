import ray
from ray import serve
from fastapi import FastAPI

# Conexión al clúster remoto
if not ray.is_initialized():
    ray.init(address="ray://172.179.101.87:10001")

serve.start(detached=True, http_options={"host": "0.0.0.0", "port": 8000})

export_app = FastAPI(
    title="Export Predictor API",
    description="Export Pipeline online inference"
)

@serve.deployment
@serve.ingress(export_app)
class HolaMundo:
    def __init__(self):
        # Load model
        self.model = "hola"

    @export_app.get("/", include_in_schema=False)
    async def hola(self):
        return "hola mundo"

# Desplegar como aplicación Serve
serve.run(HolaMundo.bind(), name="hola_mundo_app", route_prefix="/hola")

print("App 'hola_mundo_app' desplegada en '/hola'")

#serve.shutdown()
