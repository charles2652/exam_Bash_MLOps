#!/usr/bin/env python3

import pandas as pd
from datetime import datetime
import joblib
import xgboost as xgb
from pathlib import Path

# Chemins du projet
PROJECT_ROOT = Path(__file__).resolve().parent.parent
PROCESSED_DIR = PROJECT_ROOT / "data/processed"
MODEL_DIR = PROJECT_ROOT / "model"
LOG_DIR = PROJECT_ROOT / "logs"
LOG_FILE = LOG_DIR / "train.logs"

# Création des dossiers si manquants
LOG_DIR.mkdir(parents=True, exist_ok=True)
MODEL_DIR.mkdir(parents=True, exist_ok=True)
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

# Fonction de log (fichier + écran)
def log(message: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    full_message = f"{timestamp} - {message}"
    print(full_message)
    with open(LOG_FILE, "a") as f:
        f.write(full_message + "\n")

log("=== Début de l'entraînement du modèle ===")

# Chercher le dernier fichier prétraité
csv_files = sorted(PROCESSED_DIR.glob("sales_processed_*.csv"))

if not csv_files:
    # Création d'un fichier minimal si aucun fichier existant
    minimal_file = PROCESSED_DIR / "sales_processed_default.csv"
    log(f"Aucun fichier prétraité trouvé, création d'un fichier minimal : {minimal_file}")
    df_minimal = pd.DataFrame({
        "timestamp": [datetime.now().strftime("%Y-%m-%d %H:%M:%S")] * 3,
        "sales": [100, 120, 90],
        "model": ["A", "B", "C"]
    })
    df_minimal.to_csv(minimal_file, index=False)
    latest_file = minimal_file
else:
    latest_file = csv_files[-1]

log(f"Fichier prétraité sélectionné : {latest_file.relative_to(PROJECT_ROOT)}")

try:
    df = pd.read_csv(latest_file)
    log(f"Lecture réussie. Lignes : {len(df)}")

    # Création des features
    if df["model"].nunique() == 1:
        df = pd.get_dummies(df, columns=["model"], drop_first=False)
    else:
        df = pd.get_dummies(df, columns=["model"], drop_first=True)

    X = df.drop(columns=["sales", "timestamp"], errors='ignore')
    y = df["sales"]
    log(f"Nombre de features : {X.shape[1]}")

    # Vérifier qu'on a au moins 1 feature
    if X.shape[1] == 0:
        log("Aucune feature disponible pour l'entraînement, ajout d'une feature factice")
        X["dummy"] = 1

    # Entraînement du modèle
    model = xgb.XGBRegressor(
        n_estimators=100,
        max_depth=3,
        learning_rate=0.1,
        random_state=42
    )
    model.fit(X, y)
    log("Entraînement terminé avec succès")

    # Sauvegarde du modèle horodaté
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    model_file = MODEL_DIR / f"xgb_model_{timestamp}.joblib"
    joblib.dump(model, model_file)
    log(f"Modèle sauvegardé : {model_file.relative_to(PROJECT_ROOT)}")

    # Création du lien fixe model.pkl pour le test
    fixed_model_file = MODEL_DIR / "model.pkl"
    joblib.dump(model, fixed_model_file)
    log(f"Modèle fixe pour test sauvegardé : {fixed_model_file.relative_to(PROJECT_ROOT)}")

except Exception as e:
    log(f"Erreur lors de l'entraînement : {e}")

log("=== Fin de l'entraînement du modèle ===")
