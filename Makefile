## Allows (hopefully) use of conda
## https://stackoverflow.com/questions/53382383/makefile-cant-use-conda-activate
## .ONESHELL:

.PHONY: clean data lint requirements sync_data_to_s3 sync_data_from_s3

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PYTHON_INTERPRETER = python
ENV_NAME = dmtech1

ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
endif

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Make Dataset
## TODO: Currently this doesn't do anything
data:
	$(PYTHON_INTERPRETER) src/data/make_dataset.py data/raw data/processed

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Set up development environment
## NOTE: If this errors out, then call 
## conda activate dmtech1
## pip install -e .
## directly
create_environment:
ifeq (True,$(HAS_CONDA))
	@echo ">>> Detected conda, creating conda environment."
	conda env create -f environment.yml
	@echo ">>> IMPORTANT!!!!!!!!!"
	@echo ">>> Call the following directly (without the '>>>'):"
	@echo ">>> conda activate $(ENV_NAME)"
	@echo ">>> pip install -e . "
else
	@echo ">>> Conda not detected, please install conda."	
endif

## Update an existing development environment with new packages
update_environment:
ifeq (True, $(HAS_CONDA))
	conda env update --name $(ENV_NAME) --file environment.yml 
else	
	@echo ">>> Conda not detected, please install conda."	
endif 
