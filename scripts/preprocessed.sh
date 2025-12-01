#!/bin/bash

# Variables utilisées dans le script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
SRC_DIR="$ROOT/src"
DATA_PROCESSED="$ROOT/data/processed"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/preprocessed.logs"
PYTHON="$ROOT/.venv/bin/python3"

# Création des dossiers si manquants
mkdir -p "$DATA_PROCESSED" "$LOG_DIR"

# Début du prétraitement
echo "=============================================="
echo "=== Début du prétraitement et des tests ===" | tee -a "$LOG_FILE"
echo "============================================="


"$PYTHON" "$SRC_DIR/preprocessed.py" 2>&1 | tee -a "$LOG_FILE"

echo "=== Prétraitement terminé avec succès ===" | tee -a "$LOG_FILE"
echo "==========================================="
echo "=== Fin du prétraitement ===" | tee -a "$LOG_FILE"
echo "==========================================="
