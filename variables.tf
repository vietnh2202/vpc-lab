variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "wifi_ips" {
  description = "List of IPs to allow access to the ALB"
  type        = list(string)
  default     = ["203.167.11.186", "58.186.32.244", "222.253.79.245"]
}

variable "ecr_image" {
  description = "ECR image URI"
  type        = string
  default     = "public.ecr.aws/nginx/nginx:stable-alpine"
}