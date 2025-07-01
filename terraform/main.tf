

resource "google_compute_instance" "cloud" {
	count 			 = 2
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

}