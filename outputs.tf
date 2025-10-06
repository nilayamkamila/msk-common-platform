output "primary_vpc_id" {
  value = aws_vpc.primary.id
  description = "Primary VPC id"
}

output "primary_msk_bootstrap_servers" {
  value = aws_msk_cluster.primary.bootstrap_brokers_tls
  description = "Primary MSK TLS bootstrap brokers"
}

#output "secondary_msk_bootstrap_servers" {
#  value = aws_msk_cluster.secondary.bootstrap_brokers_tls
#  description = "Secondary MSK TLS bootstrap brokers"
#}

output "primary_msk_cluster_arn" {
  value = aws_msk_cluster.primary.arn
}

#output "secondary_msk_cluster_arn" {
#  value = aws_msk_cluster.secondary.arn
#}
