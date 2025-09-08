terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "generate_ssh_keys" {
  provisioner "local-exec" {
    command = <<EOT
      if [ ! -f "${path.root}/id_rsa" ]; then
        ssh-keygen -t rsa -b 4096 -f "${path.root}/id_rsa" -N ""
      else
        echo "SSH key already exists, skipping generation."
      fi
    EOT
    interpreter = ["bash", "-c"]
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


data "local_file" "ssh_pub_key" {
  filename = "${path.root}/id_rsa.pub"
}

locals {
  cloud_init = templatefile("${path.module}/cloud-init.yaml", {
    ssh_public_key = data.local_file.ssh_pub_key.content
  })
}

resource "null_resource" "create_lxc_container" {
  depends_on = [data.local_file.ssh_pub_key]

  provisioner "local-exec" {
    command = <<EOT
      echo '${replace(local.cloud_init, "'", "'\\''")}' > ./cloud-init-${var.container_name}.yaml

      lxc launch ${var.os_image} ${var.container_name} \
        -c limits.cpu=${var.cpu_limit} \
        -c limits.memory=${var.memory_limit}

      lxc config device add ${var.container_name} root disk path=/ pool=default size=${var.disk_size}

      lxc config set ${var.container_name} user.user-data - < ./cloud-init-${var.container_name}.yaml

      lxc restart ${var.container_name}
    EOT
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      lxc stop ${self.triggers.container_name} --force || true
      sleep 2
      lxc delete ${self.triggers.container_name} --force
    EOT
    interpreter = ["bash", "-c"]
  }

  triggers = {
    container_name = var.container_name
  }
}
