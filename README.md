Overview
This project provisions an AKS (Azure Kubernetes Service) cluster and deploys:

a Keycloak authentication server (backed by a managed Postgres DB),

and a static webapp (NGINX) protected by Keycloak.

All infrastructure is provisioned with Terraform.
All Kubernetes resource configuration and app deployment is handled with Ansible (as required)
CI/CD workflows for rollout, configuration, and teardown are implemented using GitHub Actions.

KEYCLOAK-AKS-PROJECT/
├── .github/workflows/         
├── ansible/                 
│   ├── deploy.yml
│   ├── destroy.yml
│   ├── infra.yml
│   └── inventory.ini
├── k8s/                     
│   ├── keycloak-deployment.yaml
│   ├── postgres-deployment.yaml
│   ├── secrets.yaml
│   ├── webapp-configmap.yaml
│   └── webapp-deployment.yaml
├── terraform/               
│   ├── main.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── variables.tf
├── webapp/
│   └── index.html


Workflow Steps
1. Infrastructure Provisioning (Terraform)
Create Resource Group, VNet, Subnet and AKS cluster in Azure.

Why: Terraform is best for cloud infra lifecycle management.

2. Kubernetes & App Deployment (Ansible)
All cluster config (namespace, secrets, ConfigMaps, Deployments) is managed by Ansible, using k8s/ YAML manifests.

Why: Requirement says "all configuration should be done with Ansible wherever possible". This ensures full separation of infra (Terraform) and app config (Ansible).

3. CI/CD (GitHub Actions)
Three workflows:

deploy.yml: Provisions infra (infra.yml), deploys apps (deploy.yml).

configure.yml: For future config updates (optional).

destroy.yml: Destroys apps and infra (destroy.yml).

How to Use This Project
A. Setup Azure & GitHub
Fork this repo and clone locally.

Create an Azure Service Principal and save its JSON output as a secret named AZURE_CREDENTIALS in your GitHub repo.

Login to Azure CLI on your local machine (az login).

B. Provision Infrastructure
From the root:


cd terraform
terraform init
terraform apply -auto-approve
Or trigger the GitHub Actions deploy.yml to run both infra and app deploy (using Ansible).

C. Deploy K8s Manifests
Configure kubectl for your AKS cluster:


az aks get-credentials --resource-group <rg> --name <aks-name>
Then use Ansible:


cd ..
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

D. Test the Application
Get the Keycloak and Webapp service EXTERNAL-IPs (or port-forward if ClusterIP):

kubectl get svc -n keycloakns
Access the webapp:

kubectl port-forward -n keycloakns svc/static-web 8081:80
Then open http://localhost:8081

If LoadBalancer: open the EXTERNAL-IP in browser.

Create a test user in Keycloak admin and test OIDC login.

E. Destroy All Resources
Either manually:


ansible-playbook -i ansible/inventory.ini ansible/destroy.yml
Or trigger the GitHub Actions workflow destroy.yml.

Justification of Choices
Components Used
AKS: Azure-managed Kubernetes; robust, scalable, cloud-native.

Keycloak: Modern, open source identity provider with OIDC/OAuth2 support.

Postgres: Stable, production-grade RDBMS for Keycloak persistence.

NGINX (static webapp): Simple and widely used for static content.

Why Not Other Components?
AKS: Simpler, more cost-effective, and better-integrated with Azure compared to self-managed K8s.

Keycloak: Chosen over Auth0/Okta for open source, free use, and easy containerization.

Terraform: Preferred for infra as code in Azure; more mature than native Ansible Azure modules for large deployments.

Ansible for K8s: Required by assignment; more readable and better for config orchestration than Terraform's K8s provider.

Image Choices:
Keycloak: Official Keycloak container image (hardened, maintained).

Postgres: Official Postgres image.

NGINX: Official alpine image (lightweight, secure).

Network Configuration:
Private VNet/subnet for AKS nodes, secure access to Postgres.

Container Environment Justification:

Containers enable fast, repeatable, portable deployments with high isolation and fast scaling.

Kubernetes enables orchestration and self-healing.



