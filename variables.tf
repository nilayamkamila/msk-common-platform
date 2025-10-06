variable "project" {
  type    = string
  default = "msk-multi-region"
}

variable "vpc_cidr_primary" {
  type    = string
  default = "10.10.0.0/16"
}

variable "vpc_cidr_secondary" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidrs_primary" {
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnet_cidrs_primary" {
  type = list(string)
  default = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}

variable "public_subnet_cidrs_secondary" {
  type = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "private_subnet_cidrs_secondary" {
  type = list(string)
  default = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
}

variable "availability_zones_primary" {
  type    = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"] # leave empty to auto-select by provider; you can pass ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "availability_zones_secondary" {
  type    = list(string)
  default = ["us-west-2a","us-west-2b","us-west-2c"] # same for secondary. you can pass ["us-west-2a","us-west-2b","us-west-2c"]
}

variable "msk_broker_instance_type" {
  description = "MSK broker instance type for high performance"
  type        = string
  default     = "kafka.m5.large"  # adjust upward for higher throughput (e.g., kafka.m5.xlarge)
}

variable "msk_number_of_broker_nodes_per_cluster" {
  type    = number
  default = 6  # total brokers across the cluster (MSK will distribute across AZs)
}

variable "msk_kafka_version" {
  type    = string
  default = "3.8.x" # choose a supported Kafka version
}

variable "local_ip_cidr" {
  description = "Your local laptop/public IP in CIDR format to allow inbound access (e.g. 203.0.113.5/32)"
  type        = string
  default     = null
}

variable "tags" {
  type = map(string)
  default = {}
}
