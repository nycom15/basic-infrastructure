variable "my_vpc_cidr" {
  type        = string
  description = "my vpc cidr block"
  default     = "10.0.0.0/16"
}
variable "my_subnet_cidr" {
  type        = string
  description = "my subnet cidr block"
  default     = "10.0.10.0/24"
}
variable "my_az" {
  type        = string
  description = "my availability zones"
  default     = "us-west-1b"
}
variable "my_env_prefix" {
  type        = string
  description = "my environment"
  default     = "dev"
}

variable "my_ip" {
  type = string
  description = "my ip address"
  default = "0.0.0.0/0"
}

variable "my_instance_type" {
  type = string
  description = "type of the ec2 instance"
  default = "t2.micro"
}

/*variable "my_key_pair" {
  type= string
  description = "my ec2 key pair"
  default = file("~/.ssh/terraforkey.pub")
}*/