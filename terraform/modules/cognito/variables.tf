#----------------------------------------
# Cognito User Pool Configuration
# Variables for configuring AWS Cognito identity services
#----------------------------------------

#----------------------------------------
# User Pool Basic Configuration
# Core properties for the Cognito User Pool
#----------------------------------------
variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "CS301-G2-T1"
}

variable "user_pool_client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
  default     = "CS301-G2-T1-AppClient"
}

#----------------------------------------
# Password Policy
# Security requirements for user passwords
#----------------------------------------
variable "password_min_length" {
  description = "Minimum length of the password"
  type        = number
  default     = 8
  validation {
    condition     = var.password_min_length >= 8
    error_message = "Password minimum length must be at least 8 characters."
  }
}

variable "password_require_lowercase" {
  description = "Whether to require lowercase letters in passwords"
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "Whether to require uppercase letters in passwords"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "Whether to require numbers in passwords"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "Whether to require symbols in passwords"
  type        = bool
  default     = false
}

#----------------------------------------
# Multi-Factor Authentication
# MFA settings for user authentication
#----------------------------------------
variable "mfa_configuration" {
  description = "MFA configuration for the user pool. When set to 'ON', email-based MFA will be required for all users. Can be 'OFF', 'ON', or 'OPTIONAL'"
  type        = string
  default     = "OFF"
  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "MFA configuration must be one of: OFF, ON, or OPTIONAL."
  }
}

#----------------------------------------
# Hosted UI Configuration
# Settings for Cognito's built-in authentication UI
#----------------------------------------
variable "cognito_domain" {
  description = "Domain prefix for Cognito hosted UI"
  type        = string
}

#----------------------------------------
# Environment Configuration
# Regional and network-related settings
#----------------------------------------
variable "aws_region" {
  description = "AWS region for the Cognito User Pool"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the application load balancer"
  type        = string
}

variable "custom_domain" {
  description = "Custom domain for the application (if configured)"
  type        = string
  default     = "alb.itsag2t1.com" # Make it optional with a default value
}

variable "frontend_domain" {
  description = "Main frontend domain for the application (if configured)"
  type        = string
  default     = "main-frontend.itsag2t1.com"
}

#----------------------------------------
# Development Settings
# Configuration for local development environment
#----------------------------------------
variable "enable_local_development" {
  description = "Whether to enable localhost URLs for local development"
  type        = bool
  default     = true
}

variable "local_development_ports" {
  description = "List of localhost ports to allow for local development"
  type        = list(number)
  default     = [3000, 8080]
}