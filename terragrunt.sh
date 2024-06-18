#!/bin/bash

check_exit_status() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

read -p "Enter tenant name: " client_name
# read -p "Enter the AWS region for the resources: " aws_region
aws_region="eu-west-2"

mkdir -p "terragrunt/${client_name}"
check_exit_status "Failed to create client directory for ${client_name}"

cat > "terragrunt/${client_name}/terragrunt.hcl" <<EOL
terraform {
  source = "../../resources"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "poc-statefiles-137"
    key            = "terragrunt/${client_name}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

inputs = {
  base_name = "${client_name}"
  region    = "${aws_region}"
}
EOL
check_exit_status "Failed to create terragrunt.hcl file for ${client_name}"

# Create client-specific tfvars file
# mkdir -p "vars"
# cat > "vars/${client_name}.tfvars" <<EOL
# base_name = "${client_name}"
# region    = "${aws_region}"
# EOL
# check_exit_status "Failed to create tfvars file for ${client_name}"

cd "terragrunt/${client_name}"
terragrunt init
check_exit_status "Failed to initialize Terragrunt for ${client_name}"

# terragrunt plan -var-file="../../vars/${client_name}.tfvars"
terragrunt plan
check_exit_status "Failed to plan resources for ${client_name}"

# terragrunt apply -var-file="../../vars/${client_name}.tfvars"
terragrunt apply
check_exit_status "Failed to apply resources for ${client_name}"

echo "Resources created successfully for client: ${client_name}"
