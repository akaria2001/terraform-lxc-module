# Terraform LXC Container Module

This module creates and manages LXC containers using Terraform and the Null Provider.

## Features

- Dynamic CPU, RAM, disk, and OS configuration
- SSH key generation and injection via cloud-init
- OS update and package installation
- Graceful shutdown before deletion
- Modular structure for CI/CD scalability

## Usage

```
bash
terraform init
terraplan plan
terraform apply
terraform destroy
```

## Requirements

* Terraform CLI

* LXD installed and initialized (lxd init)