# Terraform Modules for Creating DigitalOcean Droplets

This repository contains Terraform modules for creating DigitalOcean Droplets. Follow these steps to get started:

## Prerequisites

Before you begin, make sure you have the following:

- A DigitalOcean account with API access
- Terraform installed on your local machine
- An SSH key pair for logging into your Droplets

## Getting Started

1. Clone the repository to your local machine.
2. Review the `.env-sample` file, and create a copy named `.env` with your DigitalOcean API access details.
3. Choose a directory to work in. The `dev`, `staging`, and `prod` directories are currently work-in-progress to build a CI/CD template.
4. Modify the `terraform.tfvars` file to customize your Droplet configuration.
5. Review the `main.tf`, `variables.tf`, and `provider.tf` files for your own reference.
6. When you're ready to deploy, run the following commands in your chosen directory:

```
terraform init
terraform plan
terraform apply --auto-approve
```

This will initialize Terraform, show you a preview of the changes to be made, and apply the changes to create your Droplet(s).

7. To destroy your Droplet(s), run the following command:

```
terraform destroy
```

This will remove all resources created by Terraform, including your Droplet(s).

## Contributing

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository to your own GitHub account.
2. Create a new branch for your changes.
3. Make your changes, and test them locally.
4. Submit a pull request to the main repository for review.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
