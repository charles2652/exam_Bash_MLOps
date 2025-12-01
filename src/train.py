#!/usr/bin/env python3

import glob
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
    log("Aucun fichier prétraité trouvé dans data/processed")
    exit()

latest_file = csv_files[-1]
log(f"Fichier prétraité le plus récent : {latest_file.relative_to(PROJECT_ROOT)}")

try:
    df = pd.read_csv(latest_file)
    log(f"Lecture du fichier réussie. Lignes : {len(df)}")

    df = pd.get_dummies(df, columns=["model"], drop_first=True)
    X = df.drop(columns=["sales", "timestamp"], errors='ignore')
    y = df["sales"]
    log(f"Nombre de features : {X.shape[1]}")

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

    # --- Création du lien fixe model.pkl pour le test ---
    fixed_model_file = MODEL_DIR / "model.pkl"
    joblib.dump(model, fixed_model_file)
    log(f"Modèle fixe pour test sauvegardé : {fixed_model_file.relative_to(PROJECT_ROOT)}")

except Exception as e:
    log(f"Erreur lors de l'entraînement : {e}")

log("=== Fin de l'entraînement du modèle ===")
