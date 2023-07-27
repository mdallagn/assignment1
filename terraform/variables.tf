variable "default_tags" {
  default = {
    "Owner" = "marco"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tag"
}

variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Group used as prefix"
}

variable "instance_type" {
  default     = "t3.micro"
  type        = string
  description = "Type of the instance"
}

variable "public_subnet_cidrs" {
  default     = "172.31.96.0/20"
  type        = string
  description = "Public subnet CIDR block"
}