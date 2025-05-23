#--------------------------------------------------------------
# ElastiCache Module Outputs
# Values that can be referenced by other modules
#--------------------------------------------------------------

#--------------------------------------------------------------
# Endpoint Information
# Connection information for ElastiCache instances
#--------------------------------------------------------------

# Map of primary endpoints for each Valkey replication group
output "valkey_endpoints" {
  description = "Map of application identifiers to their Valkey endpoints"
  value = {
    for app_key, app in var.applications : app_key => aws_elasticache_replication_group.valkey[app_key].primary_endpoint_address
  }
}

# Map of configuration endpoints for each Valkey replication group (useful for client-side clustering)
output "valkey_configuration_endpoints" {
  description = "Map of application identifiers to their Valkey configuration endpoints"
  value = {
    for app_key, app in var.applications : app_key => aws_elasticache_replication_group.valkey[app_key].configuration_endpoint_address
  }
}

#--------------------------------------------------------------
# Connection Configuration
# Port and other connection details
#--------------------------------------------------------------

# Port on which Valkey is accessible
output "valkey_port" {
  description = "The port on which the Valkey service is running"
  value       = 6379
}
