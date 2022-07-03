# Define Local Values in Terraform
locals {
  owners               = var.businessdivision
  environment          = var.env
  resource_name_prefix = "${var.businessdivision}-${var.env}-${var.location}"
} 