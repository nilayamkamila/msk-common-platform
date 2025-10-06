variable "aws_region_primary" {
  description = "Primary AWS region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "aws_region_secondary" {
  description = "Secondary AWS region (e.g., us-west-2)"
  type        = string
  default     = "us-west-2"
}

provider "aws" {
  alias  = "primary"
  region = var.aws_region_primary
}

provider "aws" {
  alias  = "secondary"
  region = var.aws_region_secondary
}
