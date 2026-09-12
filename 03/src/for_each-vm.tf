resource "yandex_compute_instance" "db" {
  for_each = {
    for vm in var.each_vm : vm.vm_name => vm
  }

  name        = each.value.vm_name
  platform_id = var.vm_common.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = var.vm_common.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = var.vm_common.disk_type
      size     = each.value.disk_volume
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