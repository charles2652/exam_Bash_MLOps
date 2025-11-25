# ==============================================================================
# Script : collect.sh
# Description :
#   Ce script interroge une API afin de récupérer les ventes des modèles de cartes graphiques suivants :
#     - rtx3060
#     - rtx3070
#     - rtx3080
#     - rtx3090
#     - rx6700
#
#   Les données collectées sont ajoutées à une copie du fichier :
#     data/raw/sales_data.csv
#
#   Le fichier de sortie est sauvegardé au format :
#     data/raw/sales_YYYYMMDD_HHMM.csv
#   avec les colonnes suivantes :
#     timestamp, model, sales
#
#   L’activité de collecte (requêtes, modèles interrogés, résultats, erreurs)
#   est enregistrée dans un fichier de log :
#     logs/collect.logs
#
#   La log est lisible et doit inclure :
#     - La date et l’heure de chaque requête
#     - Les modèles interrogés
#     - Les ventes récupérées
#     - Les éventuelles erreurs
# ==============================================================================

#!/bin/bash

# Récupérer le dossier du script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RAW_DIR="$DIR/../data/raw"
LOG_DIR="$DIR/../logs"

DATE=$(date +"%Y%m%d_%H%M")
OUTPUT_FILE="$RAW_DIR/sales_$DATE.csv"
MASTER_FILE="$RAW_DIR/sales_data.csv"   # fichier maître
LOG_FILE="$LOG_DIR/collect.log"

MODELS=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")

# Créer les dossiers si nécessaire
mkdir -p "$RAW_DIR"
mkdir -p "$LOG_DIR"

# Si le fichier maître n'existe pas, créer l'en-tête
if [ ! -f "$MASTER_FILE" ]; then
    echo "timestamp,model,sales" > "$MASTER_FILE"
fi

# Créer le fichier horodaté avec en-tête
echo "timestamp,model,sales" > "$OUTPUT_FILE"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

log "Début de la collecte"

for model in "${MODELS[@]}"; do
    log "Interrogation API pour le modèle $model"

    response=$(curl -s "http://0.0.0.0:5000/$model")
    status=$?

    if [ $status -eq 0 ]; then
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        line="$timestamp,$model,$response"

        # Ajouter aux deux fichiers : maître et horodaté
        echo "$line" >> "$MASTER_FILE"
        echo "$line" >> "$OUTPUT_FILE"

        log "Succès : $model => $response ventes"
    else
        log "Erreur lors de la collecte pour le modèle $model"
    fi
done

log "Fin de la collecte, fichiers créés : $MASTER_FILE et $OUTPUT_FILE"




