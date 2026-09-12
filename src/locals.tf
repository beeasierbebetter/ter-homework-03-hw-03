locals {
  ssh_public_key = trimspace(file(pathexpand(var.vm_common.ssh_key_path)))
}