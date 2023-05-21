terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

terraform {
  backend "s3" {
    endpoint = "sfo3.digitaloceanspaces.com"
    region = "us-west-1"
    bucket = "infra-as-code-logs"
    key = "terraform-staging.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
