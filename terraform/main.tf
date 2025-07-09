
resource "local_file" "ansible_inventory" {
  content  = "[myhosts]\n"
  filename = "${path.module}/../ansible/inventory.ini"
}


resource "google_compute_instance" "cloud" {
  depends_on   =  [local_file.ansible_inventory]
  count        =  var.nb_vms
  name         =  "vm-${count.index}"
  zone         =  "us-central1-a"
  machine_type =  "e2-micro"

  tags = ["vms"]

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
    command = <<-EOT
      echo "$PUBLIC_IP ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $ANSIBLE_INVENTORY
    EOT
    environment = {
      PUBLIC_IP         = self.network_interface[0].access_config[0].nat_ip
      ANSIBLE_INVENTORY = local_file.ansible_inventory.filename
    }
  }
}

resource "google_compute_firewall" "rules" {
  name = "my-firewall-rules"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vms"]
}


# resource "terraform_data" "known_hosts" {
#   depends_on = [google_compute_instance.cloud]

#   provisioner "local-exec" {
#     # This command constructs a loop in bash to iterate over the IPs
#     # and execute your desired command for each.
#     command = <<-EOT
#       IPS=${join(" ", [for instance in google_compute_instance.cloud : instance.network_interface[0].access_config[0].nat_ip])}
      
#       echo $IPS
#     EOT
#   }
# }



