#--------------------------------------------------------------
# EC2 Instance Configuration Variables
# Core settings for the SFTP server instance
#--------------------------------------------------------------
variable "ami_id" {
  description = "The AMI ID to use for the SFTP server"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the SFTP server"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name to use for SSH access"
  type        = string
}

#--------------------------------------------------------------
# Network Configuration Variables
# Settings related to VPC, subnet, and security groups
#--------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1" # Change this to your preferred region
}

#--------------------------------------------------------------
# File and Security Configuration
# Settings for file upload and secure access
#--------------------------------------------------------------
# variable "private_key_path" {
#   description = "The path to the private key for SSH connections"
#   type        = string
#   default     = "~/.ssh/id_rsa"  # Default path, can be overridden
# }

variable "csv_file_path" {
  description = "The path to the CSV file to upload to the SFTP server"
  type        = string
}

variable "sftp_private_key_secret_name" {
  description = "Name for the AWS Secrets Manager secret that will store the SFTP private key"
  type        = string
  default     = "sftp-server-private-key"
}