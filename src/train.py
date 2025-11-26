#!/usr/bin/env python3


import glob
import pandas as pd
from datetime import datetime
import joblib
import xgboost as xgb
import os


# Les variables et les chemins du projet

DIR = os.path.dirname(os.path.abspath(__file__))  # src/
PROJECT_ROOT = os.path.abspath(os.path.join(DIR, ".."))
PROCESSED_DIR = os.path.join(PROJECT_ROOT, "data/processed")
MODEL_DIR = os.path.join(PROJECT_ROOT, "model")
LOG_DIR = os.path.join(PROJECT_ROOT, "logs")
LOG_FILE = os.path.join(LOG_DIR, "train.logs")

os.makedirs(LOG_DIR, exist_ok=True)
os.makedirs(MODEL_DIR, exist_ok=True)


# Fonction de log (fichier + écran)

def log(message: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    full_message = f"{timestamp} - {message}"
    print(full_message)  
    with open(LOG_FILE, "a") as f:
        f.write(full_message + "\n")


# Début de l'entraînement

log("=== Début de l'entraînement du modèle ===")


csv_files = glob.glob(os.path.join(PROCESSED_DIR, "sales_processed_*.csv"))
if not csv_files:
    log("Aucun fichier prétraité trouvé dans data/processed")
    exit()

latest_file = max(csv_files, key=os.path.getctime)
log(f"Fichier prétraité le plus récent : {os.path.relpath(latest_file, PROJECT_ROOT)}")

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


    # Sauvegarde du modèle

    timestamp = datetime.now().strftime("%Y%m%d_%H%M")
    model_file = os.path.join(MODEL_DIR, f"model_{timestamp}.pkl")
    joblib.dump(model, model_file)
    log(f"Modèle sauvegardé : {os.path.relpath(model_file, PROJECT_ROOT)}")

except Exception as e:
    log(f"Erreur lors de l'entraînement : {e}")

log("=== Fin de l'entraînement du modèle ===")
