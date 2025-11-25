"""
-------------------------------------------------------------------------------
Ce script preprocessed.py récupère les données du dernier fichier CSV créé 
dans le dossier 'data/raw/'.

1. Il applique un prétraitement aux données
   
2. Les résultats du prétraitement sont enregistrés dans un nouveau fichier CSV 
   dans le dossier 'data/processed/', avec un nom au format 
   'sales_processed_YYYYMMDD_HHMM.csv'.
   
3. Toutes les étapes du prétraitement sont enregistrées dans le fichier 
   'logs/preprocessed.logs' afin de garantir un suivi détaillé du processus.

Les erreurs ou anomalies éventuelles sont également loguées pour assurer la traçabilité.
-------------------------------------------------------------------------------
"""


import pandas as pd
import glob
import os
from datetime import datetime

# Chemin du script
DIR = os.path.dirname(os.path.abspath(__file__))  # src/
PROJECT_ROOT = os.path.abspath(os.path.join(DIR, ".."))

# Dossiers
RAW_DIR = os.path.join(PROJECT_ROOT, "data/raw")
PROCESSED_DIR = os.path.join(PROJECT_ROOT, "data/processed")
LOG_DIR = os.path.join(PROJECT_ROOT, "logs")
LOG_FILE = os.path.join(LOG_DIR, "preprocessed.log")

def log(message: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"{timestamp} - {message}\n")

log("Début du prétraitement")

# Récupérer les fichiers horodatés seulement (ignorer sales_data.csv)
csv_files = [f for f in glob.glob(os.path.join(RAW_DIR, "sales_*.csv"))        
             if "sales_data.csv" not in f]

if not csv_files:
    log("Aucun fichier CSV horodaté trouvé dans data/raw")
    exit()

# Prendre le fichier le plus récent
latest_file = max(csv_files, key=os.path.getctime)
log(f"Fichier le plus récent trouvé : {latest_file}")

try:
    # Lire le CSV en ignorant les lignes mal formées
    df = pd.read_csv(latest_file, on_bad_lines='warn')
    log(f"Lecture du fichier {latest_file} réussie. Lignes lues : {len(df)}")  

    # -----------------------------
    # Prétraitement
    # -----------------------------
    df = df.dropna()  # supprimer valeurs manquantes
    df = df[df['sales'].apply(lambda x: str(x).isdigit())]  # garder les ventes numériques
    df['sales'] = df['sales'].astype(int)
    df = df[df['sales'] > 0]  # filtrer ventes > 0
    df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')
    df = df.dropna(subset=['timestamp'])

    log(f"Prétraitement terminé. Lignes restantes : {len(df)}")

    # -----------------------------
    # Créer dossier processed si nécessaire
    # -----------------------------
    os.makedirs(PROCESSED_DIR, exist_ok=True)

    # -----------------------------
    # Sauvegarde du fichier prétraité
    # -----------------------------
    date_str = datetime.now().strftime("%Y%m%d_%H%M")
    output_file = os.path.join(PROCESSED_DIR, f"sales_processed_{date_str}.csv")
    df.to_csv(output_file, index=False)
    log(f"Fichier prétraité sauvegardé : {output_file}")

except Exception as e:
    log(f"Erreur lors du prétraitement : {e}")

log("Fin du prétraitement")
