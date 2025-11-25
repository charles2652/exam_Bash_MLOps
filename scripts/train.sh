# -----------------------------------------------------------------------------
# Ce script train.sh exécute le programme Python src/train.py
# Ce programme entraîne un modèle de prédiction et enregistre le modèle final
# dans le répertoire model/. Le script enregistre également tous les détails
# de l'exécution dans le fichier logs/train.logs.
# -----------------------------------------------------------------------------

# Récupérer le chemin du dossier du script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Chemin vers le script Python
PYTHON_SCRIPT="$DIR/../src/train.py"

# Chemin vers le fichier de log
LOG_FILE="$DIR/../logs/train.logs"

echo "----------------------------------------" >> "$LOG_FILE"
echo "$(date +"%Y-%m-%d %H:%M:%S") - Début de l'entraînement du modèle" >> "$LOG_FILE"

# Exécuter le script Python et rediriger stdout + stderr vers le log
python3 "$PYTHON_SCRIPT" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Entraînement terminé avec succès" >> "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Erreur lors de l'entraînement" >> "$LOG_FILE"
fi

echo "----------------------------------------" >> "$LOG_FILE"
