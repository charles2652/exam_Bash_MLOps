#!/bin/bash

# Variables utilisées dans le script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
PYTHON="$ROOT/.venv/bin/python3"
SRC_FILE="$ROOT/src/train.py"
MODEL_DIR="$ROOT/model"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/train.logs"

# Création des dossiers si manquants
mkdir -p "$MODEL_DIR" "$LOG_DIR"

echo "=== Début de l'entraînement ===" | tee -a "$LOG_FILE"


if [ ! -x "$PYTHON" ]; then
    echo "Erreur : Python non trouvé dans $PYTHON" | tee -a "$LOG_FILE"
    exit 1
fi

if [ ! -f "$SRC_FILE" ]; then
    echo "Erreur : Script train.py introuvable" | tee -a "$LOG_FILE"
    exit 1
fi


cd "$ROOT" || exit 1
"$PYTHON" "$SRC_FILE" 2>&1 | tee -a "$LOG_FILE"

# Vérification de  la présence du dernier modèle
LATEST_MODEL=$(ls -t "$MODEL_DIR"/xgb_model_*.joblib 2>/dev/null | head -1)
if [ -f "$LATEST_MODEL" ]; then
    echo "Modèle sauvegardé : $LATEST_MODEL" | tee -a "$LOG_FILE"
else
    echo "Erreur : Aucun modèle trouvé" | tee -a "$LOG_FILE"
    exit 1
fi

echo "=== Entraînement terminé ===" | tee -a "$LOG_FILE"
