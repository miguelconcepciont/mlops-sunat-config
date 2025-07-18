# train_and_export.py
import mlflow
import mlflow.sklearn
import pandas as pd
import json
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from mlflow.models.signature import infer_signature
from pydantic import BaseModel


# 1️⃣ Clase Pydantic para el esquema
class Item(BaseModel):
    sepal_length: float = 6.6
    sepal_width: float = 3.0
    petal_length: float = 4.4
    petal_width: float = 1.4


# 2️⃣ Crear input_example
input_example = pd.DataFrame([Item().model_dump()])

# 3️⃣ Exportar schema.json
schema = Item.model_json_schema()
with open("Item.json", "w") as f:
    json.dump(schema, f, indent=2)

# 4️⃣ Entrenar modelo y loguear todo
mlflow.set_tracking_uri("http://4.149.157.172:5000")
mlflow.set_experiment("iris_rf_experiment")

iris = load_iris()
X = pd.DataFrame(iris.data, columns=[
    "sepal_length", "sepal_width", "petal_length", "petal_width"
])
y = iris.target
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42)

with mlflow.start_run():
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    acc = accuracy_score(y_test, model.predict(X_test))
    signature = infer_signature(X_train, model.predict(X_train))

    mlflow.log_param("n_estimators", 100)
    mlflow.log_metric("accuracy", acc)

    # 5️⃣ Registrar modelo con input_example y signature
    mlflow.sklearn.log_model(
        model,
        artifact_path="iris_rf_model",
        input_example=input_example,
        signature=signature
    )

    # 6️⃣ Adjuntar schema.json como artefacto adicional
    mlflow.log_artifact("Item.json", artifact_path="schemas")

    print("✅ Modelo entrenado, input_example válido y schema.json registrado.")
