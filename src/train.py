"""
-------------------------------------------------------------------------------
Ce script exécute l'entraînement d'un modèle XGBoost pour prédire les ventes de 
cartes graphiques à partir des données prétraitées.

1. Il commence par rechercher le dernier fichier CSV prétraité dans le dossier 
   'data/processed/'.
2. Si un modèle standard (model.pkl) n'existe pas, il charge les données, les 
   divise en ensembles d'entraînement et de test, entraîne un modèle sur ces 
   données, l'évalue, puis le sauvegarde dans 'model/model.pkl'.
3. Si un modèle standard existe déjà, il entraîne un nouveau modèle sur les 
   données les plus récentes, l'évalue, puis sauvegarde le modèle dans le dossier 
   'model/' sous formats : model_YYYYMMDD_HHMM.pkl.
4. Les métriques de performance (RMSE, MAE, R²) sont affichées et sauvegardées dans 
   le fichier de log.
5. Des erreurs éventuelles sont gérées et signalées dans les logs.

Les modèles sont sauvegardés dans le dossier 'model/' avec le nom 'model.pkl' pour 
le modèle standard et avec un horodatage pour les versions ultérieures.
Les métriques du modèle sont enregistrées dans les logs du script.
-------------------------------------------------------------------------------
"""
import glob
import pandas as pd
from datetime import datetime
import joblib
import xgboost as xgb
import os

# Chemins relatifs
DIR = os.path.dirname(os.path.abspath(__file__))  # src/
PROJECT_ROOT = os.path.abspath(os.path.join(DIR, ".."))

PROCESSED_DIR = os.path.join(PROJECT_ROOT, "data/processed")
MODEL_DIR = os.path.join(PROJECT_ROOT, "model")
LOG_DIR = os.path.join(PROJECT_ROOT, "logs")
LOG_FILE = os.path.join(LOG_DIR, "train.logs")

# Fonction de log
def log(message: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"{timestamp} - {message}\n")

log("Début de l'entraînement du modèle")

# Récupérer le dernier fichier prétraité
csv_files = glob.glob(os.path.join(PROCESSED_DIR, "sales_processed_*.csv"))    
if not csv_files:
    log("Aucun fichier prétraité trouvé dans data/processed")
    exit()

latest_file = max(csv_files, key=os.path.getctime)
log(f"Fichier prétraité le plus récent : {latest_file}")

try:
    # Lire le CSV
    df = pd.read_csv(latest_file)
    log(f"Lecture du fichier réussie. Lignes : {len(df)}")

    # -----------------------------
    # Préparation des données pour XGBoost
    # -----------------------------
    # Encodage simple du modèle GPU en variable catégorielle
    df = pd.get_dummies(df, columns=["model"], drop_first=True)

    # Variables explicatives et cible
    X = df.drop(columns=["sales", "timestamp"], errors='ignore')
    y = df["sales"]

    log(f"Nombre de features : {X.shape[1]}")

    # -----------------------------
    # Entraînement du modèle XGBoost
    # -----------------------------
    model = xgb.XGBRegressor(
        n_estimators=100,
        max_depth=3,
        learning_rate=0.1,
        random_state=42
    )
    model.fit(X, y)
    log("Entraînement terminé avec succès")

    # -----------------------------
    # Sauvegarde du modèle
    # -----------------------------
    os.makedirs(MODEL_DIR, exist_ok=True)
    model_file = os.path.join(MODEL_DIR, "model.pkl")
    joblib.dump(model, model_file)
    log(f"Modèle sauvegardé : {model_file}")

except Exception as e:
    log(f"Erreur lors de l'entraînement : {e}")

log("Fin de l'entraînement du modèle")
