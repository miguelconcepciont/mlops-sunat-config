import os
import json
import pandas as pd
import mlflow.pyfunc
from fastapi import FastAPI, Request
from json.decoder import JSONDecodeError
from jsonschema import validate, ValidationError
from mlflow.tracking import MlflowClient
from mlflow.exceptions import MlflowException
from ray import serve
from typing import Any, Dict

MODEL_NAME = "iris"
MODEL_VERSION = "3"
APP_NAME = "iris_app"
ROUTE_PREFIX = "/iris"
MLFLOW_URI = "http://mlflow.default.svc.cluster.local:5000"

app = FastAPI(title="Iris Predictor API")


@serve.deployment(ray_actor_options={"num_cpus": 0.1})
@serve.ingress(app)
class IrisModel:
    def __init__(self):
        self.model = self._load_model(f"models:/{MODEL_NAME}/{MODEL_VERSION}")
        self.schema = self._load_schema(self.model.metadata.run_id)
        self.columns = list(self.schema["properties"].keys())

    @staticmethod
    def _load_model(model_uri: str):
        mlflow.set_tracking_uri(MLFLOW_URI)
        return mlflow.pyfunc.load_model(model_uri)

    @staticmethod
    def _load_schema(run_id: str) -> Dict[str, Any]:
        client = MlflowClient()
        schema_dir = client.download_artifacts(run_id, "schemas")
        with open(os.path.join(schema_dir, "Item.json")) as f:
            return json.load(f)

    @staticmethod
    async def _parse_request(request: Request) -> Dict[str, Any]:
        try:
            return await request.json()
        except JSONDecodeError as e:
            raise ValueError(f"❌ JSON inválido: {e.msg} en posición {e.pos}")

    def _validate_input(self, data: Dict[str, Any]) -> None:
        try:
            validate(instance=data, schema=self.schema)
        except ValidationError as e:
            raise ValueError(f"❌ Error de validación JSON Schema: {e.message}")

    def _to_dataframe(self, data: Dict[str, Any]) -> pd.DataFrame:
        try:
            values = [float(data[col]) for col in self.columns]
            return pd.DataFrame([values], columns=self.columns)
        except Exception as e:
            raise ValueError(f"❌ Error al convertir datos a float: {e}")

    @app.post("/predict")
    async def predict(self, request: Request):
        try:
            data = await self._parse_request(request)
            self._validate_input(data)
            row = self._to_dataframe(data)
            pred = self.model.predict(row)
            return {"prediction": int(pred[0])}

        except ValueError as ve:
            return {"error": str(ve)}

        except MlflowException as me:
            return {
                "error": "❌ Error en la predicción",
                "message": str(me).split("Error:")[-1].strip()
            }

        except Exception as e:
            return {"error": f"❌ Error inesperado: {str(e)}"}


entrypoint = IrisModel.bind()