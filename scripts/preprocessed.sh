#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR="$DIR/../logs"
LOG_FILE="$LOG_DIR/processed.log"
SRC_DIR="$DIR/../src"
PYTHON="/home/ubuntu/exam_MAMOU/exam_bash/.venv/bin/python3"

mkdir -p "$LOG_DIR"
mkdir -p "$DIR/../data/processed"

echo "=== Début du prétraitement ===" | tee -a "$LOG_FILE"

# Lancer le script Python
"$PYTHON" "$SRC_DIR/preprocessed.py" 2>&1 | tee -a "$LOG_FILE"

echo "=== Prétraitement terminé avec succès ===" | tee -a "$LOG_FILE"
