provider "rancher2" {
  api_url    = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

resource "rancher2_cluster" "custom-cluster" {
  name = var.cluster_name
  description = "Custom cluster provisioned on vmware"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}