variable "container_name" {
  type        = string
  description = "Name of the LXC container"
}

variable "os_image" {
  type        = string
  description = "OS image to use (e.g., ubuntu:20.04)"
}

variable "cpu_limit" {
  type        = number
  description = "Number of CPUs"
  default     = 2
}

variable "memory_limit" {
  type        = string
  description = "Memory limit (e.g., 2GB)"
  default     = "2GB"
}

variable "disk_size" {
  type        = string
  description = "Disk size (e.g., 10GB)"
  default     = "10GB"
}
