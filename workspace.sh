#!/bin/bash

check_exit_status() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

read -p "Enter the customer name: " customer_name
read -p "Enter region: " region_name

cd resources
terraform workspace new "${customer_name}"
check_exit_status "Failed to create workspace for ${customer_name}"

tfvars_file="../vars/${customer_name}.tfvars"
cat > "${tfvars_file}" <<EOL
base_name = "${customer_name}"
region="${region_name}"
EOL
check_exit_status "Failed to create tfvars file for ${customer_name}"
echo "Successfully created tfvars file: ${tfvars_file}"

mkdir -p ../env/${customer_name}
backend_file="../env/${customer_name}/backend-${customer_name}.hcl"
cat > "${backend_file}" <<EOL
bucket         = "poc-statefiles-137"
key            = "${customer_name}/terraform.tfstate"
region         = "us-west-2"
EOL
check_exit_status "Failed to create backend file for ${customer_name}"
echo "Successfully created backend file: ${backend_file}"

terraform init -reconfigure -backend-config="${backend_file}"
check_exit_status "Failed to initialize Terraform with backend configuration for ${customer_name}"
echo "Successfully initialized Terraform with backend configuration"

terraform plan -var-file="${tfvars_file}"
check_exit_status "Failed to plan Terraform configuration for ${customer_name}"
echo "Successfully Planned Terraform configuration for ${customer_name}"

terraform apply -var-file="${tfvars_file}"
check_exit_status "Failed to apply Terraform configuration for ${customer_name}"

echo "Resources created successfully for customer: ${customer_name}"


## Destroy resource
# terraform destroy -var-file="${tfvars_file}"
# check_exit_status "Failed to apply Terraform configuration for ${customer_name}"