import pandas as pd
import re
import numpy as np
import mlflow.pyfunc


class CustomModel:
    def reemplazar_tildes(self, col_name):
        mapeo_tildes = {
            r"Á": "A", r"É": "E", r"Í": "I", r"Ó": "O", r"Ú": "U",
            r"Â": "A", r"Ê": "E", r"Î": "I", r"Ô": "O", r"Û": "U",
            r"Ä": "A", r"Ë": "E", r"Ï": "I", r"Ö": "O", r"Ü": "U",
            r"À": "A", r"È": "E", r"Ì": "I", r"Ò": "O", r"Ù": "U",
            r"Ñ": "N", r"Ý": "Y", r"Ç": "C", r"Ã": "A", r"Õ": "O"
            # ,".":""             #Se agrega el cambio de un punto por nada
            }
        for letra, reemplazo in mapeo_tildes.items():
            col_name = re.sub(letra, reemplazo, col_name)
        return col_name

    def reemplazar_otro(self, col_name):
        return re.sub(r'[^a-zA-Z0-9\s]', '', col_name)

    def reemplazar_espacios(self, col_name):
        return re.sub(r' ', '', col_name)

    def preprocess_transacciones(self, transacciones):
        try:
            transacciones['codigo_mercancia'] = transacciones['codigo_mercancia'].str.upper()
            transacciones['codigo_mercancia'] = transacciones['codigo_mercancia'].apply(self.reemplazar_tildes)
            transacciones['codigo_mercancia'] = transacciones['codigo_mercancia'].apply(self.reemplazar_otro)
            transacciones['codigo_mercancia'] = transacciones['codigo_mercancia'].apply(self.reemplazar_espacios)
            transacciones = transacciones.drop_duplicates()
        except Exception as e:
            raise e
        return transacciones

    def predict(self, transacciones, percentiles):
        try:
            transacciones = self.preprocess_transacciones(transacciones)
            merged = pd.merge(transacciones, percentiles, on=["codigo_mercancia"], how="left")
            merged["flag_p25"] = (merged["fob_unitario"] < merged["p25"]).astype(int)
            merged = merged.reset_index(drop=True)
            merged['Monto_diferencia'] = merged['p25'] - merged['fob_unitario']
            merged['tributo_difrencial'] = merged['Monto_diferencia'] * merged['cnt_merc'] * 0.18
            merged = merged.reset_index(drop=True)
            merged['ratio'] = merged['tributo_difrencial'] / 700
            merged['ratio'] = merged['ratio'].mask(merged['ratio'] > 1, 1)
        except Exception as e:
            raise e
        return np.array(merged[['ratio']])


class CustomModelWrapper(mlflow.pyfunc.PythonModel):
    def __init__(self, model):
        self.model = model

    def load_context(self, context):
        # Cargar el CSV de percentiles desde los artifacts
        self.percentiles_df = pd.read_csv(context.artifacts["percentiles"])

    def predict(self, context, transacciones):
        return self.model.predict(transacciones, self.percentiles_df)
