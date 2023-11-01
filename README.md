# terraform-digitalocean-droplet
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This Terraform configuration sets up a DigitalOcean Virtual Private Cloud (VPC) and deploys one or more Droplets in the specified region. It also sets up firewall rules to control incoming traffic to the Droplets.

## Usage
To get started, make sure you have configured your DigitalOcean provider. You can use the following code as a starting point:
The Droplet module allows you to create DigitalOcean Droplets within the VPC created by the VPC module. You can use this module by including the following code in your Terraform configuration:

```hcl
module "droplet" {
  source      = "../"
  name        = "app"
  environment = "test"
  region      = "blr1"

  droplet_count = 1
  vpc_uuid      = module.vpc.id
  ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAxsgc"
  user_data     = file("user-data.sh")

  inbound_rules = [
    {
      allowed_ip    = ["10.20.0.0/16"]
      allowed_ports = "22"
    },
    {
      allowed_ip    = ["0.0.0.0/0"]
      allowed_ports = "80"
    }
  ]
}
```

## Module Inputs

- 'name' (string): The name of the Droplet.
- 'environment' (string): The environment in which the Droplet is being created.
- 'region' (string): The DigitalOcean region where the Droplet should be created.
- 'droplet_count' (number): The number of Droplets to create.
- 'vpc_uuid' (string): The ID of the VPC in which the Droplets should be created.
- 'ssh_key' (string): The SSH public key for accessing the Droplets.
- 'user_data' (string): The user data script to run on the Droplets.
Please make sure to configure these variables according to your requirements.

## Module Outputs

- 'droplet_ids' (list of strings): The IDs of the created Droplets.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-digitalocean-droplet/blob/readme/LICENSE) file for details.
