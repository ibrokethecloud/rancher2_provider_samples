provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_url

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


resource "vsphere_virtual_machine" "node" {
  name             = "${var.node_name}-${count.index+1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  count            = (var.enabled == true ? var.node_count : 0 )
  num_cpus         = var.cpu_count
  memory           = var.memory
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.userdata"          = base64gzip(templatefile("${path.module}/cloud-init.tpl", {node_command = var.node_command, node_role = var.node_role, ssh_key = data.local_file.pub_ssh_key.content, node_name = "${var.node_name}-${count.index+1}" }))
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  disk {
    label            = "disk0"
    size             = 20
    unit_number      = 0
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }
}
