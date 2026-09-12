variable "vm_common" {
  type = object({
    image_family  = string
    platform_id   = string
    core_fraction = number
    disk_type     = string
    preemptible   = bool
    nat           = bool
    ssh_user      = string
    ssh_key_path  = string
    serial_port   = number
  })

  default = {
    image_family  = "ubuntu-2004-lts"
    platform_id   = "standard-v1"
    core_fraction = 5
    disk_type     = "network-hdd"
    preemptible   = true
    nat           = true
    ssh_user      = "ubuntu"
    ssh_key_path  = "~/.ssh/id_ed25519.pub"
    serial_port   = 1
  }
}

variable "web_vm" {
  type = object({
    count       = number
    name_prefix = string
    cpu         = number
    ram         = number
    disk_volume = number
  })

  default = {
    count       = 2
    name_prefix = "web"
    cpu         = 2
    ram         = 1
    disk_volume = 10
  }
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))

  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    }
  ]
}

variable "storage_vm" {
  type = object({
    name             = string
    cpu              = number
    ram              = number
    boot_disk_size   = number
    disk_count       = number
    disk_size        = number
    disk_name_prefix = string
  })

  default = {
    name             = "storage"
    cpu              = 2
    ram              = 1
    boot_disk_size   = 10
    disk_count       = 3
    disk_size        = 1
    disk_name_prefix = "storage-disk"
  }
}