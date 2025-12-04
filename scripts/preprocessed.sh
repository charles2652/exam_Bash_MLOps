#!/bin/bash

# Variables utilisées dans le script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
SRC_DIR="$ROOT/src"
DATA_PROCESSED="$ROOT/data/processed"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/preprocessed.logs"
PYTHON="$ROOT/.venv/bin/python3"

# Activation du venv si présent
if [ -f "$ROOT/.venv/bin/activate" ]; then
    source "$ROOT/.venv/bin/activate"
    echo "Venv activé : $ROOT/.venv"
fi

# Création des dossiers si manquants
mkdir -p "$DATA_PROCESSED" "$LOG_DIR"

# Début du prétraitement
echo "=============================================="
echo "=== Début du prétraitement et des tests ===" | tee -a "$LOG_FILE"
echo "============================================="

RAW_DATA="$ROOT/data/raw"

# Vérification de la présence d'au moins un fichier CSV
RAW_FILES=("$RAW_DATA"/sales*.csv)
if [ ! -e "${RAW_FILES[0]}" ]; then
    echo "Erreur : aucun fichier raw trouvé dans $RAW_DATA" | tee -a "$LOG_FILE"
    exit 1
fi

echo "=== Lancement du prétraitement ==="

# Lancement du script Python
"$PYTHON" "$SRC_DIR/preprocessed.py" 2>&1 | tee -a "$LOG_FILE" || exit 1

echo "=== Prétraitement terminé ===" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"
echo "=== Fin du prétraitement ===" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"
