#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR="$DIR/../logs"
LOG_FILE="$LOG_DIR/train.log"
SRC_DIR="$DIR/../src"
PYTHON="/home/ubuntu/exam_MAMOU/exam_bash/.venv/bin/python3"

mkdir -p "$LOG_DIR"

echo "=== Début de l'entraînement ===" | tee -a "$LOG_FILE"

# Lancer le script Python d'entraînement
"$PYTHON" "$SRC_DIR/train.py" 2>&1 | tee -a "$LOG_FILE"

echo "=== Entraînement terminé avec succès ===" | tee -a "$LOG_FILE"
