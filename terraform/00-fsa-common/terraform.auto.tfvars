# -----------------------------------------------------------------------------
# Azure Subscription and Tenant
# -----------------------------------------------------------------------------

subscription_id = "d3c69ca6-2cb1-46d7-ba08-092dbd46a3bc"
tenant_id       = "3590242b-a92d-4bb9-9ff9-eb7a1183f511"

# -----------------------------------------------------------------------------
# Global
# -----------------------------------------------------------------------------

location       = "northeurope"
resource_group = "rg-fsa-common"
dns_zone_name  = "fullstackacademy.sk"

# radovan.pieter@posam.sk -> ObjectID: "f07c709b-a2a4-4538-9b38-3cea737b1a69"
owners = ["f07c709b-a2a4-4538-9b38-3cea737b1a69"]

grafana_sa_name = "kube-prometheus-stack-grafana"
