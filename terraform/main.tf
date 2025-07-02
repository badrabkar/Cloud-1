
resource "local_file" "ansible_inventory" {
  content = "[myhosts]\n"
  filename = "${path.module}/../ansible/inventory.ini"
}


resource "google_compute_instance" "cloud" {
  depends_on = [local_file.ansible_inventory]
  count = 2
  name         = "vm-${count.index}"
  zone         = "us-central1-a"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"
  #   allow_stopping_for_update = true

  provisioner "local-exec" { 
    command = "echo $PUBLIC_IP >> $ANSIBLE_INVENTORY"
    environment = {
      PUBLIC_IP = self.network_interface[0].access_config[0].nat_ip
      ANSIBLE_INVENTORY = local_file.ansible_inventory.filename
    }
  }
}



