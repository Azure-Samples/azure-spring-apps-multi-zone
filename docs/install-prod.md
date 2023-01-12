# Installation for non-test environments

In case you install this sample in a non-test environment, usage of a private GitHub repository and authentication to it with a valid Git PAT token is advised. See [set up Git PAT](#set-up-git-pat) for steps to create a PAT token.

In case you install this sample in a non-test environment, you should also provide a properly signed pfx certificate for your custom domain.

To install this sample in your subscription:

## 1. Clone this repo

```bash
git clone https://github.com/Azure-Samples/azure-spring-apps-multi-zone.git
cd azure-spring-apps-multi-zone
```

## 2. Review the tfvars file

The [variables.tf](../tf-deploy/variables.tf) and [myvars.prod.tfvars](../tf-deploy/myvars.prod.tfvars) files in the tf-deploy directory contain the different variables you can configure. Update any values in the myvars.prod.tfvars file to reflect the environment you would like to build. See [variables.md](variables.md) for an explanation of the different variables you can configure.

Some of the variables are secret values, it is better to create environment variables for these and pass them along through the command line instead of putting them in the tfvars file.

```bash
GIT_REPO_PASSWORD="GH_PAT_your_created"
CERT_PASSWORD='password_of_your_certificate'
```

## 3. Log in to your Azure environment

```bash
az login
```

## 4. Execute the deployment

```bash
cd tf-deploy

terraform init -upgrade
terraform plan -var-file="myvars.prod.tfvars" -out=plan.tfplan -var='git_repo_passwords=["$GIT_REPO_PASSWORD","$GIT_REPO_PASSWORD"]' -var="cert_password=$CERT_PASSWORD"
terraform apply -auto-approve plan.tfplan
```

## 5. Test your setup

You can test your setup by going to your app through your Application Gateway IP address in the browser. The IP address is part of the Terraform output. You should see the "Hurray~Your app is up and running!" page. You can also configure the custom domain for it, for instance in your local host file.

## 6. Extra: Deploying the Spring Petclinic application

In case you want to deploy the spring petclinic micorservices application to your Spring Apps instances, use the guidance in [deploy-app.md](deploy-app.md)

## 7. Cleanup

To remove all the resources you have set up, run the below statement: 

```bash
terraform destroy -var-file="myvars.prod.tfvars" -var='git_repo_passwords=["$GIT_REPO_PASSWORD","$GIT_REPO_PASSWORD"]' -var="cert_password=$CERT_PASSWORD"
```

## Additional prerequisites
### Set up Git PAT

You can use the [Creating a personal access token](https://docs.github.com/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) from GitHub for creating a PAT token. 

In case you choose to create a classic PAT token, you should enable full repo scope access for your config repo.

In case you create a newer (beta) fine-grained PAt token, create it for your specific repository, and `read-only` access for `Contents`. 
