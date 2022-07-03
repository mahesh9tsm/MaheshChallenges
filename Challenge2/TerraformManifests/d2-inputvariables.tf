# Generic Input Variables
# Default Business Division
variable "businessdivision" {
  description = "Name of the business division"
  type        = string
  default     = "hr"
}
# Default Environment Variable 
variable "env" {
  description = "Environment Variable which would be used as per the Company Standard"
  type        = string
  default     = "sbx"
}

# Default location Variable
variable "location" {
  description = "provide location name in the resource name as per company standards"
  type        = string
  default     = "eus2"
}


# Default Azure Resource group
variable "rg_location" {
  description  = "default Region in which Azure Resources need to be created"
  type         = string
  default      = "eastus2"  
}

variable "zones" {
type    = list(string)
default = [ "1" , "2" ] 
}


