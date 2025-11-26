#!/bin/bash
LOG_FILE="/home/ubuntu/exam_MAMOU/exam_bash/exam_Bash_MLOps/logs/cron.log"

# Redirection de stdout et stderr vers le fichier de log
exec >> "$LOG_FILE" 2>&1

NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "=============================================="
echo "=== Pipeline cron lancé à $NOW ==="
echo "=============================================="

NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "=== Collect.sh lancé à $NOW ==="
/bin/bash /home/ubuntu/exam_MAMOU/exam_bash/exam_Bash_MLOps/scripts/collect.sh

NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "=== Preprocessed.sh lancé à $NOW ==="
/bin/bash /home/ubuntu/exam_MAMOU/exam_bash/exam_Bash_MLOps/scripts/preprocessed.sh

NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "=== Train.sh lancé à $NOW ==="
/bin/bash /home/ubuntu/exam_MAMOU/exam_bash/exam_Bash_MLOps/scripts/train.sh

echo "=== Pipeline cron terminé à $(date "+%Y-%m-%d %H:%M:%S") ==="
