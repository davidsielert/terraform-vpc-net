variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_network_count" {
  type = number
  default = 4
}
variable "private_network_count" {
  type = number
  default = 4
}
variable "data_network_count" {
  type = number
  default = 4
}
variable "network_bits" {
  type = number
  default = 8
}

locals {
  alphabet = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"]
  
  private_subnet_ids = [for s in aws_subnet.private: s.id]
  public_subnet_ids = [for s in aws_subnet.public: s.id]
  ssh_cidr_blocks =  concat([for subnet in aws_subnet.private: subnet.cidr_block],[
      //addl cidr's here
  ])
}