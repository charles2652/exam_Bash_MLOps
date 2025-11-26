# Makefile pour le projet Bash MLOps
# Logs globaux, messages importants à l'écran

.PHONY: all collect preprocess train tests

# Chemin de l'environnement virtuel
VENV = @. /home/ubuntu/exam_MAMOU/exam_bash/.venv/bin/activate &&
GLOBAL_LOG = logs/pipeline.log

# Crée le fichier log et les dossiers si nécessaire
init:
	@mkdir -p logs ./data/raw ./data/processed
	@touch $(GLOBAL_LOG)

# Pipeline complète : collect, preprocess, train, tests
all: init collect preprocess train tests
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète terminée avec succès ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

# Collecte
collect: init
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Démarrage du Pipeline avec succès ==="      | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

	@echo "=== Lancement de la collecte des données ===" | tee -a $(GLOBAL_LOG)
	$(VENV) bash ./scripts/collect.sh >> $(GLOBAL_LOG) 2>&1

# Prétraitement
preprocess: init
	@echo "=== Prétraitement des données ===" | tee -a $(GLOBAL_LOG)
	$(VENV) bash ./scripts/preprocessed.sh >> $(GLOBAL_LOG) 2>&1

# Entraînement du modèle
train: init
	@echo "=== Entraînement du modèle ===" | tee -a $(GLOBAL_LOG)
	$(VENV) bash ./scripts/train.sh >> $(GLOBAL_LOG) 2>&1

# Tests
tests: init
	@echo "=== Lancement des tests ===" | tee -a $(GLOBAL_LOG)
	$(VENV) pytest -v tests/test_collect.py >> $(GLOBAL_LOG) 2>&1
	$(VENV) pytest -v tests/test_preprocessed.py >> $(GLOBAL_LOG) 2>&1
	$(VENV) pytest -v tests/test_model.py >> $(GLOBAL_LOG) 2>&1
	@echo "=== Tests terminés ===" | tee -a $(GLOBAL_LOG)
