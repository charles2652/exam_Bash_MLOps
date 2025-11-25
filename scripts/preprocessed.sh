# =============================================================================
# Ce script preprocessed.sh exécute le programme src/preprocessed.py
# et enregistre les détails de son exécution dans le fichier de log
# logs/preprocessed.logs.
# =============================================================================

# Chemin du dossier scripts
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Chemin vers le script Python
PYTHON_SCRIPT="$DIR/../src/preprocessed.py"

# Chemin vers le fichier de log
LOG_FILE="$DIR/../logs/preprocessed.log"

echo "----------------------------------------" >> "$LOG_FILE"
echo "$(date +"%Y-%m-%d %H:%M:%S") - Début du prétraitement" >> "$LOG_FILE"    

# Exécuter le script Python et rediriger stdout + stderr vers le log
python3 "$PYTHON_SCRIPT" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Prétraitement terminé avec succès" >> "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Erreur lors du prétraitement" >> "$LOG_FILE"
fi

echo "----------------------------------------" >> "$LOG_FILE"
