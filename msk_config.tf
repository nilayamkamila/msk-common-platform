resource "aws_msk_configuration" "custom_broker_config" {
  name           = "${var.project}-broker-config"
  kafka_versions = ["3.8.x"]
  description    = "Custom Kafka broker configuration for ${var.project}"

  server_properties = <<EOF
# Enable topic auto-creation for testing
auto.create.topics.enable=true

# Log retention: 7 days
log.retention.hours=168

# Default number of partitions
num.partitions=3

# Replication configuration
default.replication.factor=3
min.insync.replicas=2
unclean.leader.election.enable=false

# Topic deletion allowed
delete.topic.enable=true

# Compression tuning
compression.type=producer

# Request handling
num.replica.fetchers=2
replica.fetch.max.bytes=1048576
EOF

}
