# Generic Input Variables to define the values are per the company standards
# Default Business Division as per the Standards
variable "businessdivision" {
  description = "Name of the business division"
  type        = string
  default     = "hr"
}
# Default Environment Variable as per the Standards
variable "env" {
  description = "Environment Variable which would be used as per the Company Standard"
  type        = string
  default     = "sbx"
}

# Default location Variable as per the Standards
variable "location" {
  description = "provide location name in the resource name as per company standards"
  type        = string
  default     = "wus2"
}

# Default location Variable as per the Standards
variable "rg_location" {
  description = "provide location name in the resource name as per company standards"
  type        = string
  default     = "westus2"
}


# Default Azure availability zone as per the Requirement

variable "zones" {
type    = list(string)
default = [ "1" , "2" ] 
}
###############################################################################################################
###############################################################################################################

# Provide input values for the Vnet and Subnet addressspace (Web,APP,DB and Bastion)
variable "vnet_name" {
  description = "Vnet Name"
  type        = string
  default     = "vnet"
}

variable "vnet_addresspace" {
  description = "Vnet addressspace"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

variable "Web_subnet_addressspace" {
  description = "Web Subnet Name"
  type        = list(string)
  default     = [ "10.0.1.0/24" ]
}

variable "App_subnet_addressspace" {
  description = "App Subnet Name"
  type        = list(string)
  default     = [ "10.0.2.0/24" ]
}

variable "Db_subnet_addressspace" {
  description = "Db Subnet Name"
  type        = list(string)
  default     = [ "10.0.3.0/24" ]
}

variable "Bastion_subnet_addressspace" {
  description = "Bastion Subnet Name"
  type        = list(string)
  default     = [ "10.0.4.0/24" ]
}
