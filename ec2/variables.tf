variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-2"

}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the instance"
  type        = string
  
}

variable "instance_name" {
  description = "The name tag for the instance"
  type        = string
  default     = "terraform instance" # Replace with your desired instance name

}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-053a0835435bf4f45" # Replace with a valid AMI ID for your region

}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string

}

variable "vpc_id" {
  description = "The ID of the VPC to launch the instance in"
  type        = string

}
