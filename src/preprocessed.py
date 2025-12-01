#!/usr/bin/env python3

import pandas as pd
from pathlib import Path
from datetime import datetime
import logging
from sklearn.preprocessing import OrdinalEncoder

# Mes  Variables  #
BASE_DIR = Path(__file__).parent.parent.resolve()
INPUT_FOLDER = BASE_DIR / "data/raw"
OUTPUT_FOLDER = BASE_DIR / "data/processed"
LOG_FILE = BASE_DIR / "logs/preprocessed.logs"


OUTPUT_FOLDER.mkdir(parents=True, exist_ok=True)
LOG_FILE.parent.mkdir(parents=True, exist_ok=True)


logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# Liste des  Fonctions utilisées #

def load_latest_raw_file() -> Path:
    csv_files = list(INPUT_FOLDER.glob("sales_*.csv"))
    if not csv_files:
        logging.error(f"Aucun fichier raw trouvé dans {INPUT_FOLDER}")
        raise FileNotFoundError(f"Aucun fichier raw trouvé dans {INPUT_FOLDER}")
    latest_file = max(csv_files, key=lambda f: f.stat().st_mtime)
    logging.info(f"Fichier raw chargé : {latest_file.relative_to(BASE_DIR)}")
    print(f"Fichier raw chargé : {latest_file.relative_to(BASE_DIR)}")
    return latest_file

def preprocess_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    print(f"Nombre de lignes avant prétraitement : {len(df)}")
    print(f"Colonnes avant prétraitement : {list(df.columns)}")

    # Suppression de la colonne timestamp si elle existe
    if "timestamp" in df.columns:
        df = df.drop(columns=["timestamp"])
        logging.info("Colonne 'timestamp' supprimée")
        print("Colonne 'timestamp' supprimée")

    # Sélection des colonnes attendues
    expected_cols = ["model", "sales"]
    df = df[expected_cols]

    # Encodage ordinal pour 'model'
    encoder = OrdinalEncoder(handle_unknown="use_encoded_value", unknown_value=-1)
    df["model"] = encoder.fit_transform(df[["model"]]).astype(int)

    # Conversion de 'sales' en entier
    df["sales"] = pd.to_numeric(df["sales"], errors="coerce").fillna(0).astype(int)

    logging.info("Prétraitement terminé : colonnes = model, sales (int)")
    print(f"Nombre de lignes après prétraitement : {len(df)}")
    print(f"Colonnes après prétraitement : {list(df.columns)}")
    print(f"Valeurs uniques de 'model' : {df['model'].unique()}")
    return df

def save_processed_file(df: pd.DataFrame) -> Path:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = OUTPUT_FOLDER / f"sales_processed_{timestamp}.csv"
    df.to_csv(output_file, index=False)
    logging.info(f"Fichier prétraité enregistré : {output_file.relative_to(BASE_DIR)}")
    print(f"Fichier prétraité enregistré : {output_file.relative_to(BASE_DIR)}")
    return output_file


def main():
    try:
        raw_file = load_latest_raw_file()
        df = pd.read_csv(raw_file)
        df = preprocess_dataframe(df)
        save_processed_file(df)
        print("Prétraitement terminé avec succès.")
    except Exception as e:
        logging.error(f"Erreur pendant le prétraitement : {e}")
        print(f"Erreur : {e}")

if __name__ == "__main__":
    main()
