#############
## General ##
#############

.PHONY: init lint local

init: pyrequirements

lint: init
	${PYENV_ACTIVATE} && pylint slate

local: init
	${PYENV_ACTIVATE} && python3 -B -m slate


################################
## Python Virtual Environment ##
################################

PYENV = .virtualenv
PYENV_ACTIVATE = . ${PYENV}/bin/activate

.PHONY: pyrequirements

pyrequirements: ${PYENV}/.touchfile

${PYENV}/.touchfile: requirements.txt ${PYENV}
	# Install any packages if the requirements.txt file has been updated recently.
	# Touchfile used to track when we last installed all requirements.
	${PYENV_ACTIVATE} && python3 -m pip install -r $<
	touch $@

${PYENV}:
	# Create a virtualenv directory. This directory is not tracked by Git.
	virtualenv $@
