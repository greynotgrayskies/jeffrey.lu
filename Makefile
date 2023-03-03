#############
## General ##
#############

.PHONY: init lint local local-docker local-kubernetes

init: pyrequirements

lint: init
	${PYENV_ACTIVATE} && pylint slate

local: init
	${PYENV_ACTIVATE} && python3 -B -m slate

local-docker: dev-img
	docker run -p 8080:8080 jeffreylu:dev

local-kubernetes: start-minikube
	minikube image load jeffreylu:dev
	minikube kubectl -- apply -f kubernetes/local.yaml


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


###############
## Packaging ##
###############

dist:
	mkdir $@


############
## Docker ##
############

.PHONY: dev-img

dev-img:
	docker build . --file=docker/Dockerfile --tag=jeffreylu:dev


################
## Kubernetes ##
################

.PHONY: local-kubernetes start-minikube

start-minikube:
	# Ensure local Kubernetes cluster is running.
	minikube status || minikube start


################
## Deployment ##
################

# A project must be preconfigured before any of these deployment targets will
# work. To configure a project for Kubernetes,
# Variables can be configured in local/envsetup.sh

.PHONY: deploy-kubernetes-dev

deploy-kubernetes-dev:
	gcloud container clusters get-credentials ${CLUSTER} \
		--region=${REGION} \
		--project=${PROJECT_ID}
	docker build . \
		--file=docker/Dockerfile \
		--tag=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/jeffreylu:dev
	docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/jeffreylu:dev
	# This command can start a new Kubernetes deployment and service, but won't
	# update them if they already exist.
	kubectl apply -f kubernetes/dev.yaml
