#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RAW_DIR="$DIR/../data/raw"
LOG_DIR="$DIR/../logs"
LOG_FILE="$LOG_DIR/collect.log"
PYTHON="/home/ubuntu/exam_MAMOU/exam_bash/.venv/bin/python3"
DATE=$(date +"%Y%m%d_%H%M")
OUTPUT_FILE="$RAW_DIR/sales_$DATE.csv"
MASTER_FILE="$RAW_DIR/sales_data.csv"
MODELS=("rtx3060" "rtx3070" "rtx3080" "rtx3090" "rx6700")

mkdir -p "$RAW_DIR"
mkdir -p "$LOG_DIR"

echo "=== Début de la collecte ===" | tee -a "$LOG_FILE"

# Créer master si nécessaire
if [ ! -f "$MASTER_FILE" ]; then
    echo "timestamp,model,sales" > "$MASTER_FILE"
fi

echo "timestamp,model,sales" > "$OUTPUT_FILE"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

log "Début de la collecte"

# Exemple simple de collecte
for model in "${MODELS[@]}"; do
    sales=$((RANDOM % 20 + 1))
    echo "$(date +"%Y-%m-%d %H:%M:%S"),$model,$sales" >> "$OUTPUT_FILE"
done

# Fusion avec master
tail -n +2 "$OUTPUT_FILE" >> "$MASTER_FILE"

log "Fin de la collecte"
echo "=== Collecte terminée avec succès ===" | tee -a "$LOG_FILE"
