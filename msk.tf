# Primary MSK cluster
resource "aws_msk_cluster" "primary" {
  provider = aws.primary
  cluster_name = "${var.project}-msk-${var.aws_region_primary}"
  kafka_version = var.msk_kafka_version

  broker_node_group_info {
    instance_type   = var.msk_broker_instance_type
    client_subnets  = aws_subnet.primary_private[*].id
    security_groups = [aws_security_group.primary_msk.id]
    storage_info {
      ebs_storage_info {
        volume_size = 1
      }
    }
  }

  number_of_broker_nodes = var.msk_number_of_broker_nodes_per_cluster

  configuration_info {
    arn      = aws_msk_configuration.custom_broker_config.arn
    revision = aws_msk_configuration.custom_broker_config.latest_revision
  }



  tags = merge(local.common_tags, { Name = "${var.project}-msk-primary" })
}

# Secondary MSK cluster
#resource "aws_msk_cluster" "secondary" {
#  provider = aws.secondary
#  cluster_name = "${var.project}-msk-${var.aws_region_secondary}"
#  kafka_version = var.msk_kafka_version
#
#  broker_node_group_info {
#    instance_type   = var.msk_broker_instance_type
#    client_subnets  = aws_subnet.secondary_private[*].id
#    security_groups = [aws_security_group.secondary_msk.id]
#    storage_info {
#      ebs_storage_info {
#        volume_size = 1000
#      }
#    }
#  }

#  number_of_broker_nodes = var.msk_number_of_broker_nodes_per_cluster

#  configuration_info {
#    arn      = aws_msk_configuration.custom_broker_config.arn
#    revision = aws_msk_configuration.custom_broker_config.latest_revision
#  }
#
#
#  tags = merge(local.common_tags, { Name = "${var.project}-msk-secondary" })
#}
