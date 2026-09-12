data "yandex_compute_image" "ubuntu" {
  family = var.vm_common.image_family
}

resource "yandex_compute_instance" "web" {
  count = var.web_vm.count

  name        = "${var.web_vm.name_prefix}-${count.index + 1}"
  platform_id = var.vm_common.platform_id

  resources {
    cores         = var.web_vm.cpu
    memory        = var.web_vm.ram
    core_fraction = var.vm_common.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.vm_common.disk_type
      size     = var.web_vm.disk_volume
    }
  }

  scheduling_policy {
    preemptible = var.vm_common.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_common.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = var.vm_common.serial_port
    ssh-keys           = "${var.vm_common.ssh_user}:${local.ssh_public_key}"
  }

  depends_on = [yandex_compute_instance.db]
}