variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "AMIS" {
  type = map(string)
  default = {
    "eu-west-2" : "ami-03e88be9ecff64781"
  }
}

variable "INSTANCE_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "KEY_PATH" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "VPC_CIDR_BLOCK" {
  type    = string
  default = "10.0.0.0/16"
}

variable "SUBNET_CIDR_BLOCK" {
  type    = string
  default = "10.0.1.0/24"
}

variable "SUBNET_AVAILABILITY_ZONE" {
  type    = string
  default = "eu-west-2a"
}

variable "MASTER_SG_RULES_INGRESS" {
  type = list(object({
    from_port   = number,
    to_port     = number,
    cidr_blocks = string,
    protocol    = string,
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      cidr_blocks = "0.0.0.0/0"
      protocol    = "TCP"
      description = "Allow SSH"
    },
    {
      from_port   = 8080
      to_port     = 8080
      cidr_blocks = "0.0.0.0/0"
      protocol    = "TCP"
      description = "Allow port 8080"
    }
  ]
}

variable "MASTER_SG_RULES_EGRESS" {
  type = list(object({
    from_port   = number,
    to_port     = number,
    cidr_blocks = string,
    protocol    = string,
    description = string
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      cidr_blocks = "0.0.0.0/0"
      protocol    = "-1"
      description = "Allow All Traffic"
    }
  ]
}

variable "TAGS" {
  type = map(any)
  default = {
    name = "poc"
  }
}
