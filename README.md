# Setting up Wordpress on DigitalOcean using Terraform and Docker Compose  

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

5. Review the .env, Caddyfile, and docker-compose.yaml files in ./wordpress-setup directory. You will need to update .env with your desired credentials, and Caddyfile must be updated with the domains that are pointing to the droplet. Should you decide to run docker compose on your own, you can simply remove the specific remote-exec provisioner in main.tf file.

Note that the Caddyfile TLS configuration uses staging ACME server from LetsEncrypt for testing purpose. When you deploy in production, remove that specific block from Caddyfile (reference: https://caddyserver.com/docs/automatic-https).

6. When you're ready to deploy, run the following commands in your terraform directory:

   ```bash
   source .env
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

   This will initialize Terraform, show you a preview of the changes to be made, and apply the changes to create your Droplet(s).

   At this point, your Droplet will be created with the domain name pointing to it, and firewall rules applied. Wordpress is installed using docker compose (ref: the last resource in main.tf file).

   After the installation is complete, you should be able to access the WordPress site using `https://<your_domain>`. If the domain does not resolve, then SSH into the droplet, and check the logs of Caddy container.

   ```
   ssh ubuntu@<droplet>
   cd wordpress-setup
   docker compose ps
   docker compose logs caddy
   ```

   If you need to modify Caddy configuration, you can update the Caddyfile, and restart Caddy.

   ```
   docker compose restart caddy
   ```

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