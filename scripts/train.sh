#!/bin/bash


# Configuration des chemins

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$HOME/exam_MAMOU/exam_bash"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/train.logs"
PYTHON="$ROOT/.venv/bin/python3"
SRC_FILE="$DIR/../src/train.py"


# Début du script

echo "==============================================" | tee -a "$LOG_FILE"
echo "=== Début de l'entraînement ===" | tee -a "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"

# Vérification que Python existe
if [ ! -f "$PYTHON" ]; then
    echo "Erreur : Python non trouvé dans $PYTHON" | tee -a "$LOG_FILE"
    exit 1
fi

# Vérification que le script train.py existe
if [ ! -f "$SRC_FILE" ]; then
    echo "Erreur : Script $SRC_FILE introuvable" | tee -a "$LOG_FILE"
    exit 1
fi

# Lancer l'entraînement et loguer tout
"$PYTHON" "$SRC_FILE" 2>&1 | tee -a "$LOG_FILE"


# Fin du script

echo "==============================================" | tee -a "$LOG_FILE"
echo "=== Entraînement terminé  ===" | tee -a "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"
