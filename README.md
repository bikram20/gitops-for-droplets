# Terraform and Docker Compose Modules for Setting up Wordpress on DigitalOcean Droplet

This repository contains Terraform and Docker Compose manifests for setting up WordPress on a DigitalOcean Droplet. Follow these steps to get started:

## Prerequisites

Before you begin, make sure you have the following:

- A DigitalOcean account with API access
- Terraform installed on your local machine
- An SSH key pair for logging into your Droplets
- A domain name that has been configured under DigitalOcean's domain settings

## Getting Started

1. Clone the repository to your local machine.
2. Review the `.env-sample` file and create a copy named `.env`, replacing the placeholders with your DigitalOcean API access details.
3. Modify the `terraform.tfvars` file to customize your Droplet configuration.
4. Review the `main.tf`, `variables.tf`, and `provider.tf` files for your reference.
5. When you're ready to deploy, run the following commands in your chosen directory:

   ```bash
   source .env
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

   This will initialize Terraform, show you a preview of the changes to be made, and apply the changes to create your Droplet(s).

   At this point, your Droplet will be created with the domain name pointing to it, and firewall rules applied.

6. Now, you can SSH into the Droplet using the 'ubuntu' username or your specified username. After logging into the Droplet, clone this repository and navigate to the `wordpress-setup` directory.

   Create a `.env` file with the necessary credentials.

   Also, update the `Caddyfile` with your domain names.

   Run the following command to set up WordPress:

   ```bash
   docker-compose up -d
   ```

   After the installation is complete, you should be able to access the WordPress site using `https://<your_domain>`. 

7. To destroy your Droplet(s), run the following command:

   ```bash
   terraform destroy
   ```

   This will remove all resources created by Terraform, including your Droplet(s).

## Contributing

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository to your own GitHub account.
2. Create a new branch for your changes.
3. Make your changes and test them locally.
4. Submit a pull request to the main repository for review.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.