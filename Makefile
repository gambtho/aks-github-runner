SHELL := /bin/bash

VERSION := 0.0.1

.PHONY: init
init:
	@ARM_SUBSCRIPTION_ID=$(shell az account show --query id --out tsv)
	@ARM_TENANT_ID=$(shell az account show --query tenantId --out tsv)
	@cd ./terraform && terraform init --upgrade -input=false -migrate-state \
	-backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
	-backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}" \
	-backend-config="key=${RESOURCE_GROUP_NAME}.tfstate" \
	-backend-config="container_name=${STORAGE_CONTAINER_NAME}"

.PHONY: plan
plan:
	cd ./terraform && terraform plan \
	-var="resource_group_name=$(RESOURCE_GROUP_NAME)" \
	-var="cluster_name=${CLUSTER_NAME}" \
	--out=tf.plan

.PHONY: apply
apply:
	cd ./terraform && \
    terraform apply tf.plan

.PHONY: image
image:
	az configure --defaults acr=${RESOURCE_GROUP_NAME} \
	&& az acr build -t ghrunner:${VERSION} ./ghrimage

.PHONY: helm
helm:
	export HELM_EXPERIMENTAL_OCI=1 && \
	az configure --defaults acr=${RESOURCE_GROUP_NAME} && \
	cd ./ghrhelm && \
	helm package . && \
	helm push ghr-${VERSION}.tgz oci://${RESOURCE_GROUP_NAME}.azurecr.io/ghrunner && \
	az acr repository show --name ${RESOURCE_GROUP_NAME} --repository ghrunner

.PHONY: deploy
deploy:
	az aks get-credentials --admin --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_NAME}
	az configure --defaults acr=${RESOURCE_GROUP_NAME}

	az acr helm repo add
	helm repo update

	az acr helm list
	helm repo list
	helm fetch ${RESOURCE_GROUP_NAME}/ghrunner/ghr

	echo "deploying agent to k8s"

	helm upgrade --install ghragent ${RESOURCE_GROUP_NAME}/ghrunner \
	--set image.repository=${RESOURCE_GROUP_NAME}.azurecr.io/ghrunner 


setup_command:
	echo ". ./setup.sh -c thgamble1013 -g thgamble1013 -s d0ecd0d2-779b-4fd0-8f04-d46d07f05703 -r eastus2 2>&1"
