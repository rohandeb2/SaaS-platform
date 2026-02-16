variable "global_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.r6g.large"
}

# Primary Region Config
variable "primary_subnet_group" { type = string }
variable "primary_security_group_id" { type = string }
variable "primary_kms_key_arn" { type = string }
variable "primary_instance_count" { type = number; default = 2 }

# Secondary Region Config
variable "secondary_subnet_group" { type = string }
variable "secondary_security_group_id" { type = string }
variable "secondary_kms_key_arn" { type = string }
variable "secondary_instance_count" { type = number; default = 1 }

# Auth
variable "master_username" { type = string }
variable "master_password" { type = string; sensitive = true }
