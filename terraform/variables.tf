# Define a variable "default_tags" with default values for common tags used across resources.
# This variable is of type "map(any)" and serves as a collection of key-value pairs.
variable "default_tags" {
  default = {
    "Owner" = "marco"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tag: Common tags applied to various resources."
}

# Define a variable "prefix" that sets a default value "Assignment1".
# This variable is of type "string" and represents a group used as a prefix for resource names.
variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Group used as prefix: A string used as a prefix for resource names."
}

# Define a variable "instance_type" that sets a default value "t3.micro".
# This variable is of type "string" and specifies the type of EC2 instance to be launched.
variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "Type of the instance: The EC2 instance type for the web server."
}

# Define a variable "public_subnet_cidrs" that sets a default value "172.31.96.0/20".
# This variable is of type "string" and represents the CIDR block for the public subnet.
variable "public_subnet_cidrs" {
  default     = "172.31.96.0/20"
  type        = string
  description = "Public subnet CIDR block: The CIDR block for the public subnet."
}