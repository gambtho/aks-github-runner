# Github Actions - Self Hosted Agents on AKS

This repo provides instructions and configuration to setup Self Hosted Agents for Github running on an AKS cluster.  It was derived from this [article](https://github.blog/2020-08-04-github-actions-self-hosted-runners-on-google-cloud/) by John Bohannon @imjohnbo.   This project utilizes terraform and helm to provide support for a repeatable infrastructure as code approach.  The process can also be orchestrated through an **Github workflow**. 

## Setup

Fork this repo and pull your fork to your computer

Cd into the repo

Ensure you have the following dependencies:
- [jq](https://stedolan.github.io/jq/download/)
- [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (logged in to a subscription where you have contributor rights)
- [github-cli](https://cli.github.com/) (logged in)
- [Create a github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) -- and export the value -- export GITHUB_TOKEN=paste_your_token_here

Run the setup.sh script
- Syntax: **. ./setup.sh** [-c CLUSTER_NAME] [-g RESOURCE_GROUP_NAME] [-s SUBSCRIPTION_ID] [-r REGION] (the extra dot is important)
- make setup_cmd provides an example version

This script does the following:
    - Create a service principal for use by terraform
    - Create a storage account to keep the terraform state
    - Create a resource group where your AKS cluster will be deployed
    - Save service principal and other provided variables in github screts
    
If running locally:

- make all_terraform
- make all_ghr

This uses the repo makefile to create your AKS cluster, create an ACR, and deploy the runner to the cluster


## Possible additions

- Instructions for workflow
- Add 2nd nodepool, with windows agents?
- Add cluster/pod autoscale

## Contributions

This repo is a work in progress, pull requests and suggestions are greatly appreciated

## Maintainers

Thomas Gamble thgamble@microsoft.com


