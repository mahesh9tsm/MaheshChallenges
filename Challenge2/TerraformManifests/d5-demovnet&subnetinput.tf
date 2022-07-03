# Provide input values for the Vnet and Subnet addressspace (Web,APP,DB)
variable "vnet_name" {
  description = "Vnet Name"
  type        = string
  default     = "vnet"
}

variable "vnet_addressspace" {
  description = "Vnet addressspace"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

variable "Web_subnet_addressspace" {
  description = "Web Subnet Name"
  type        = list(string)
  default     = [ "10.0.1.0/24" ]
}

