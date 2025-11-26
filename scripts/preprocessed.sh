#!/bin/bash

# Variables utilisées dans le script

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
SRC_DIR="$ROOT/src"
DATA_PROCESSED="$ROOT/data/processed"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/processed.logs"

# Chemin vers Python dans le .venv
PYTHON="$ROOT/../.venv/bin/python3"


# Début du prétraitement

echo "=============================================="
echo "=== Début du prétraitement et des tests ===" | tee -a "$LOG_FILE"
echo "============================================="

# Lancer le script Python de prétraitement
"$PYTHON" "$SRC_DIR/preprocessed.py" 2>&1 | tee -a "$LOG_FILE"

echo "=== Prétraitement terminé avec succès ===" | tee -a "$LOG_FILE"


echo "=== Début des tests ($(date +"%Y-%m-%d %H:%M:%S")) ===" | tee -a "$LOG_FILE"
echo "Début du test de structure du fichier prétraité" | tee -a "$LOG_FILE"

# Récupérer le dernier fichier prétraité
LATEST_FILE=$(ls -t "$DATA_PROCESSED"/sales_processed_*.csv | head -n1)
REL_PATH=$(realpath --relative-to="$ROOT" "$LATEST_FILE")

echo "Fichier chargé : $REL_PATH" | tee -a "$LOG_FILE"

# Vérification colonne timestamp
if ! grep -q "timestamp" <(head -n1 "$LATEST_FILE"); then
    echo "Vérification colonne 'timestamp' : OK (non présente)" | tee -a "$LOG_FILE"
else
    echo "Le fichier contient une colonne 'timestamp'" | tee -a "$LOG_FILE"
fi

# Vérification des types entiers pour les deux colonnes
python3 << EOF | tee -a "$LOG_FILE"
import pandas as pd
df = pd.read_csv("$LATEST_FILE")
all_ints = all(df[col].dtype.kind in 'iu' for col in df.columns)
if all_ints:
    print("Vérification types entiers : OK (toutes les colonnes sont des entiers)")
else:
    print("Le fichier contient des colonnes qui ne sont pas des entiers")
EOF

echo "Test terminé pour le fichier prétraité." | tee -a "$LOG_FILE"

echo "==========================================="
echo "=== Fin du prétraitement et des  tests ===" | tee -a "$LOG_FILE"
echo "=========================================="
