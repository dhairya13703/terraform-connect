resource "aws_kms_key" "connect_key" {
  description         = local.kms_key_description
  enable_key_rotation = true

  tags = {
    Name      = "${var.base_name}-kms-key"
    CreatedBy = "Terraform"
  }
}