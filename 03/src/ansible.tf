resource "local_file" "inventory" {
  filename = "${path.module}/hosts.ini"

  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = yandex_compute_instance.db
    storage    = [yandex_compute_instance.storage]
  })
}