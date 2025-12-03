import mlflow
import os
import json
import yaml
from collections import defaultdict
from mlflow.tracking import MlflowClient

# 1. Conectar a MLflow y obtener el Run ID del modelo
mlflow.set_tracking_uri("http://mlflow.default.svc.cluster.local:5000")
client = MlflowClient()
config_list = []  # Array para guardar las configuraciones
yaml_data = {"applications": []}

# 1. Buscar todas las versiones con el tag 'backup=active' globalmente
# Nota: search_model_versions devuelve una lista paginada
tagged_versions = client.search_model_versions("tags.backup = 'active'")

# 2. Agrupar versiones por nombre de modelo
model_map = defaultdict(list)
for v in tagged_versions:
    model_map[v.name].append(v)

final_models = []

# 3. Aplicar lógica: Si > 2 versiones, solo la más alta. Si <= 2, todas.
for name, versions in model_map.items():
    # Ordenar descendente por número de versión (v3, v2, v1...)
    versions.sort(key=lambda x: int(x.version), reverse=True)
    final_models.append(versions[0])  # Solo la más alta

print(f"Modelos seleccionados: {len(final_models)}")
for m in final_models:
    print(f"Procesando: {m.name} (v{m.version}) -> {m.run_id}")

    # 4. Crear carpeta con el nombre del Run ID
    target_dir = m.run_id
    os.makedirs(target_dir, exist_ok=True)

    # 5. Descargar artefactos de la carpeta 'deployment'
    try:
        local_path = client.download_artifacts(
            run_id=m.run_id, 
            path="deployment", 
            dst_path=target_dir
        )
        print(f"   ✅ Archivos descargados en: {local_path}")

        # Leer el archivo deploy_config.json
        # Nota: local_path es .../<run_id>/deployment/
        json_path = os.path.join(local_path, "deploy_config.json")

        if os.path.exists(json_path):
            with open(json_path, "r") as f:
                config_data = json.load(f)
                config_list.append(config_data)
        else:
            print("   ⚠️ deploy_config.json no encontrado en la descarga.")
    except Exception as e:
        print(f"   ⚠️ No se encontró la carpeta 'deployment' o hubo un error: {e}")

print("\n--- Lista Final de Configuraciones ---")
print(json.dumps(config_list, indent=2))

for config in config_list:
    # 6. Limpiar extensión .py para formato de módulo
    module_name = config.get("file_name").replace(".py", "")
    run_id = config.get("run_id")

    # 7. Construir el import_path dinámico
    # Formato: /<RUN_ID>/deployment/<MODULE_NAME>:entrypoint
    import_path = f"/{run_id}/deployment/{module_name}:entrypoint"

    # 8. Crear diccionario de la aplicación
    app_entry = {
        "name": config.get("app_name"),
        "route_prefix": config.get("route_prefix"),
        "import_path": import_path
    }

    yaml_data["applications"].append(app_entry)

# Guardar el archivo config.yaml en el disco
output_file = "config.yaml"
with open(output_file, "w") as f:
    yaml.dump(yaml_data, f, sort_keys=False, default_flow_style=False)

print(f"✅ Archivo generado exitosamente: {output_file}")
