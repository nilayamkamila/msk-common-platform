aws_region_primary = "us-east-1"
aws_region_secondary = "us-west-2"

#local_ip_cidr = "203.0.113.5/32"  # <-- replace with your laptop public IP /32

# Optional:
msk_broker_instance_type = "kafka.m5.large"
msk_number_of_broker_nodes_per_cluster = 6
msk_kafka_version = "3.8.x"

# Tagging
tags = {
  Owner = "team-Xviews"
  Environment = "dev"
}
