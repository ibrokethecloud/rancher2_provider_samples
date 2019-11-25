## VMWare module will call the rancher2 module
## and do the following
## - create a custom cluster
## - extract cluster-registeration token
## - pass it to cloud-init for the provisioned vm's to join the cluster

module "rancher_cluster" {
    source = "./modules/rancher2"
    rancher_url = var.rancher_url
    rancher_access_key = var.rancher_access_key
    rancher_secret_key = var.rancher_secret_key
    cluster_name = "tf-custom-cluster"
}

module "vmware" {
    source = "./modules/vsphere"
    enabled = true
    vsphere_user = var.vsphere_user
    vsphere_password = var.vsphere_password
    vsphere_url = var.vsphere_url
    vsphere_datacenter = var.vsphere_datacenter
    vsphere_datastore = var.vsphere_datastore
    local_pub_key = var.local_pub_key
    vsphere_resource_pool = var.vsphere_resource_pool
    vsphere_network = var.vsphere_network
    vm_image = var.vm_image
    node_count = var.node_count
    cpu_count = var.cpu_count
    memory = var.memory
    node_name = var.node_name
    node_role = "--worker --etcd --controlplane"
    node_command = "${module.rancher_cluster.cluster_token}"
}
