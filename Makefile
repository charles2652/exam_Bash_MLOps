# Makefile pour le projet Bash MLOps

.PHONY: all collect preprocess train tests init bash

# Racine du projet
ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# Python du venv
PYTHON := $(ROOT)/.venv/bin/python3
# Fichier log global
GLOBAL_LOG := $(ROOT)/logs/pipeline.log

# --- Cibles ---

init:
	@mkdir -p $(ROOT)/logs $(ROOT)/data/raw $(ROOT)/data/processed $(ROOT)/model
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Initialisation terminée ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@touch $(GLOBAL_LOG)

all: init collect preprocess train tests
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète terminée avec succès ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

bash: all
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Pipeline complète lancée via make bash ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)

collect:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Lancement de la collecte des données ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	bash $(ROOT)/scripts/collect.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Collecte terminée ===" | tee -a $(GLOBAL_LOG)

preprocess:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Prétraitement des données ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	bash $(ROOT)/scripts/preprocessed.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Prétraitement terminé ===" | tee -a $(GLOBAL_LOG)

train:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Entraînement du modèle ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	bash $(ROOT)/scripts/train.sh >> $(GLOBAL_LOG) 2>&1
	@echo "=== Entraînement terminé ===" | tee -a $(GLOBAL_LOG)

tests:
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	@echo "=== Début des tests ===" | tee -a $(GLOBAL_LOG)
	@echo "==============================================" | tee -a $(GLOBAL_LOG)
	pytest -v $(ROOT)/tests/test_collect.py | tee -a $(GLOBAL_LOG)
	pytest -v $(ROOT)/tests/test_preprocessed.py | tee -a $(GLOBAL_LOG)
	pytest -v $(ROOT)/tests/test_model.py | tee -a $(GLOBAL_LOG)
	@echo "=== Fin des tests ===" | tee -a $(GLOBAL_LOG)
