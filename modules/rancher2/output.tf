output "cluster_token" {
  depends_on = [
    "rancher2_cluster.custom-cluster",
  ]
  value = "${lookup(element(rancher2_cluster.custom-cluster.cluster_registration_token, 0), "node_command", "")}"
}
