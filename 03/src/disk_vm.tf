resource "yandex_compute_disk" "storage" {
  count = var.storage_vm.disk_count

  name = "${var.storage_vm.disk_name_prefix}-${count.index + 1}"
  type = var.vm_common.disk_type
  zone = var.default_zone
  size = var.storage_vm.disk_size
}

resource "yandex_compute_instance" "storage" {
  name        = var.storage_vm.name
  platform_id = var.vm_common.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.storage_vm.cpu
    memory        = var.storage_vm.ram
    core_fraction = var.vm_common.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.vm_common.disk_type
      size     = var.storage_vm.boot_disk_size
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage

    content {
      disk_id = secondary_disk.value.id
    }
  }

  scheduling_policy {
    preemptible = var.vm_common.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_common.nat
  }

  metadata = {
    serial-port-enable = var.vm_common.serial_port
    ssh-keys           = "${var.vm_common.ssh_user}:${local.ssh_public_key}"
  }
}