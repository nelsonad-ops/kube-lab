
data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "sn1-c60-e12-16-vc01-ds01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool1" {
   name          = "Andy"
   datacenter_id = "${data.vsphere_datacenter.dc.id}"
 }
data "vsphere_network" "public" {
  name          = "vm-2234"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntubase"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "k8s" {
  name             = "dev-${count.index}"
  count            = "5"
  resource_pool_id = data.vsphere_resource_pool.pool1.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "FSA Lab Users/Andy"
  wait_for_guest_ip_timeout = "-1"
  wait_for_guest_net_timeout = "-1"
  enable_disk_uuid = "true"

  num_cpus = 4
  memory   = 8192
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  cdrom {
    client_device = true
  }

  network_interface {
    network_id   = data.vsphere_network.public.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  disk {
    name             = "dev-${count.index}_disk_2.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.1.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.1.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.1.thin_provisioned
    unit_number = 1
  }
  disk {
    name             = "dev-${count.index}_disk_3.vmdk"
    size             = data.vsphere_virtual_machine.template.disks.2.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.2.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.2.thin_provisioned
    unit_number = 2
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "dev-${count.index}"
        domain    = "adn"
      }
      network_interface {
        ipv4_address = "10.21.234.${96 + count.index}"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.21.234.1"
      dns_server_list = ["10.21.234.10","10.21.234.11"]
    }
  }
}

