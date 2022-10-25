variable "profile" {
  type    = string
  default = "default"
}

variable "region-jenkins" {
  type    = string
  default = "us-east-1"
}


# used in security_groups.tf

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}


# used in intances.tf

variable "instance-type" {
  type    = string
  default = "t3.micro"
}
