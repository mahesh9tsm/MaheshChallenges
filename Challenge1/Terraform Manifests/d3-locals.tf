# Define Local Values in Terraform which can be used multiple times
locals {
  owners               = var.businessdivision
  environment          = var.env
  resource_name_prefix = "${var.businessdivision}-${var.env}-${var.location}"
} 