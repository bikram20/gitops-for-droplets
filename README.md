# Terraform modules to create DigitalOcean Droplets

- Clone the repository
- Review the .env-sample. Copy it over to .env and provide your access details.
- The sample code in staging keeps the terraform state in DigitalOcean Spaces. The sample code in dev folder keeps the terraform state locally.
- Current dev, staging, and prod folders are work-in-progress to build a CI/CD template. You can pick any directory you prefer.
- Modify the terraform.tfvars. Currently it is capable of creating a droplet with or without volume. It also creates an additional user (default ubuntu) to login with the same ssh key.
- Review main.tf, variables.tf, provider.tf for your own reference. When ready to deploy:
terraform init
terraform plan 
terraform apply --auto-approve
- To destroy:
terraform destroy
