# Github Actions - Self Hosted Agents on AKS


This repo provides instructions and configuration to setup Self Hosted Agents for Github running on an AKS cluster.  It was derived from this [article](https://github.blog/2020-08-04-github-actions-self-hosted-runners-on-google-cloud/) by John Bohannon @imjohnbo.   This project utilizes terraform and helm to provide support for a repeatable infrastructure as code approach.  The process is orchestrated through an **Github workflow**. 

## Setup

Syntax: **./manual.sh** [-s applicationId] [-p password]

This script does the following:
    - Create service principal for use by terraform and AKS (optionally, you can use -s for the Application Id and -p for the spn password)
    - Save service principal and other provided variables in keyvault
    - Authorize the selected SPN in keyvault
    
   This command will ask for your Azure subscription id, as well as the name (arbitrary string of your choice), env (arbitrary string of your choice), location (valid Azure region) for your AKS cluster, the name of your .................
---
4. Create a variable group named "ado-kv" and associate it with the key vault you just created:
   - Toggle **Link secrets from an Azure key vault as variables**
   - Select your subscription and the key vault you created in the previous step
   - **Authorize** it for use in the pipelines
   - Add all the variables aviable in your key vault
   If authorize doesn't work, use:

    az keyvault set-policy --name VAULTNAME --spn SPNId --secret-permissions get list 
---
5. Create another variable group named "ado-config":
    - Add a variable named azure_sub
    - Set that value for the created variable as the name used for the Service Connection in step 2
    - **Authorize** it for use in the pipelines
---
6. Create a pipeline using the provided YAML file **./pipeline/pipeline.yml**, and run it:
    - From Azure DevOps click on **Pipelines** in the left navigation bar and click on **Create pipeline**
    - On the page **Where is your code?** select **Azure Repos Git YAML**
    - Select your repository in Azure DevOps
    - On the page **Configure your pipeline** select **Existing Azure Pipelines YAML file** and set the path to **pipeline/pipeline.yml** 
    - Click on **Continue** and then on **Run**
---

## Possible additions

- Add 2nd nodepool, with windows agents
- Add cluster/pod autoscale

## Contributions

This repo is a work in progress, pull requests and suggestions are greatly appreciated

## Maintainers

Thomas Gamble thgamble@microsoft.com


