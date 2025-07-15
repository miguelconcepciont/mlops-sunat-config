import ray
from ray import serve
import mlflow.pyfunc
from fastapi import FastAPI, Request
import pandas as pd
import json
from jsonschema import validate, ValidationError
from mlflow.tracking import MlflowClient
import os
from mlflow.exceptions import MlflowException
from json.decoder import JSONDecodeError


# Conexión al clúster remoto
if not ray.is_initialized():
    ray.init(address="ray://raycluster-kuberay-head-svc:10001")

# Iniciar Ray Serve
serve.start(detached=True, http_options={"host": "0.0.0.0", "port": 8000})

# FastAPI app
app = FastAPI(title="Iris Predictor API")


# Deployment
@serve.deployment(ray_actor_options={"num_cpus": 0.1})
@serve.ingress(app)
class IrisModel:
    def __init__(self):
        mlflow.set_tracking_uri("http://4.149.157.172:5000")
        model_uri = "models:/Iris_LogReg_Model/3"
        self.model = mlflow.pyfunc.load_model(model_uri)

        # Usar MlflowClient para descargar artifacts
        client = MlflowClient()
        run_id = self.model.metadata.run_id
        schema_dir = client.download_artifacts(run_id, "schemas")
        schema_path = os.path.join(schema_dir, "Item.json")
        with open(schema_path, "r") as f:
            self.schema = json.load(f)

        self.columns = list(self.schema["properties"].keys())

    @app.post("/predict")
    async def predict(self, request: Request):
        try:
            data = await request.json()
        except JSONDecodeError as e:
            return {"error": f"❌ JSON inválido: {e.msg} en posición {e.pos}"}

        # Validar con jsonschema
        try:
            validate(instance=data, schema=self.schema)
        except ValidationError as e:
            return {"error": f"❌ Error de validación JSON Schema: {e.message}"}

        # Construir input ordenado
        row = pd.DataFrame(
            [[data[col] for col in self.columns]], columns=self.columns)

        try:
            row = pd.DataFrame(
                [[float(data[col]) for col in self.columns]],
                columns=self.columns
            )
        except Exception as e:
            return {"error": f"❌ Error al convertir datos a float: {e}"}

        try:
            pred = self.model.predict(row)
        except MlflowException as e:
            return {
                "error": "❌ Error en la predicción",
                "message": str(e).split("Error:")[-1].strip()  # extrae solo el mensaje de MLflow
            }

        return {"prediction": int(pred[0])}


# Desplegar con prefix
serve.run(IrisModel.bind(), name="iris_app", route_prefix="/iris")

print("✅ Modelo desplegado en http://4.149.157.172:8000/iris/predict")
