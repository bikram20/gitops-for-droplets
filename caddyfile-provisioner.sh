#!/bin/bash

# Read the FQDN values from environment variables
FQDN_LIST="${FQDN_VALUES//:/ }"

# Append the domain name to each subdomain
DOMAIN_NAME="${DOMAIN_NAME}"
FQDN_ARRAY=()
for SUBDOMAIN in ${FQDN_LIST[@]}; do
  FQDN_ARRAY+=("${SUBDOMAIN}.${DOMAIN_NAME}")
done

# Create a space-separated string of the FQDNs
FQDN_STRING=$(IFS=' ' && echo "${FQDN_ARRAY[*]}")

# Update the Caddyfile
tail -n +2 wordpress-setup/Caddyfile > wordpress-setup/Caddyfile.tmp
first_line="${FQDN_STRING} {"
echo "$first_line" | cat - wordpress-setup/Caddyfile.tmp > wordpress-setup/Caddyfile
rm wordpress-setup/Caddyfile.tmp
