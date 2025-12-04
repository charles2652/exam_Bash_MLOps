#!/bin/bash

# =====================================
# Variables utilisées dans le script
# =====================================
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$DIR/.."
SRC_FILE="$ROOT/src/train.py"
MODEL_DIR="$ROOT/model"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/train.logs"

# =====================================
# Création des dossiers si manquants
# =====================================
mkdir -p "$MODEL_DIR" "$LOG_DIR"

echo "=== Début de l'entraînement ===" | tee -a "$LOG_FILE"

# =====================================
# Activation conditionnelle du venv ou fallback Python système
# =====================================
if [ -f "$ROOT/.venv/bin/activate" ]; then
    source "$ROOT/.venv/bin/activate"
    PYTHON="$ROOT/.venv/bin/python3"
    echo "Venv activé : $ROOT/.venv" | tee -a "$LOG_FILE"
else
    PYTHON=$(which python3)
    echo "Venv non trouvé, utilisation du Python système : $PYTHON" | tee -a "$LOG_FILE"
fi

# =====================================
# Vérifications
# =====================================
if [ ! -x "$PYTHON" ]; then
    echo "Erreur : Python non exécutable : $PYTHON" | tee -a "$LOG_FILE"
    exit 1
fi

if [ ! -f "$SRC_FILE" ]; then
    echo "Erreur : Script train.py introuvable : $SRC_FILE" | tee -a "$LOG_FILE"
    exit 1
fi

# =====================================
# Exécution du script Python
# =====================================
cd "$ROOT" || exit 1
"$PYTHON" "$SRC_FILE" 2>&1 | tee -a "$LOG_FILE" || exit 1

# =====================================
# Vérification des modèles créés
# =====================================
LATEST_MODEL=$(ls -t "$MODEL_DIR"/xgb_model_*.joblib 2>/dev/null | head -1)
FIXED_MODEL="$MODEL_DIR/model.pkl"

if [ -f "$LATEST_MODEL" ]; then
    echo "Dernier modèle horodaté : $LATEST_MODEL"
else
    echo "Erreur : aucun modèle horodaté trouvé !" | tee -a "$LOG_FILE"
fi

if [ -f "$FIXED_MODEL" ]; then
    echo "Modèle fixe pour test : $FIXED_MODEL"
else
    echo "Erreur : modèle fixe model.pkl non trouvé !" | tee -a "$LOG_FILE"
    exit 1
fi

echo "=== Entraînement terminé ==="
