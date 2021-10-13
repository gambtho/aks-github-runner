SHELL := /bin/bash

.PHONY: init
init:
	@ARM_SUBSCRIPTION_ID=$(shell az account show --query id --out tsv)
	@ARM_TENANT_ID=$(shell az account show --query tenantId --out tsv)
	cd ./terraform && terraform init --upgrade -input=false -migrate-state \
	-backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
	-backend-config="storage_account_name=${RESOURCE_GROUP_NAME}" \
	-backend-config="key=${RESOURCE_GROUP_NAME}.tfstate" \
	-backend-config="container_name=${STORAGE_CONTAINER_NAME}"

setup_command:
	echo ". ./setup.sh -c thgamble1013 -g thgamble1013 -s d0ecd0d2-779b-4fd0-8f04-d46d07f05703 -r eastus2 2>&1"