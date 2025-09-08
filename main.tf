module "amit_container" {
  source         = "./modules/lxc_container"
  container_name = "amit-dev-container"
  os_image       = "ubuntu:20.04"
  cpu_limit      = 2
  memory_limit   = "2GB"
  disk_size      = "10GB"
}
