# Terraform-digitalocean-droplet
# Terraform digitalocean Cloud droplet Module.

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Author](#author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)


## Introduction
This Terraform configuration sets up a DigitalOcean Virtual Private Cloud (VPC) and deploys one or more Droplets in the specified region. It also sets up firewall rules to control incoming traffic to the Droplets.

## Usage
To get started, make sure you have configured your DigitalOcean provider. You can use the following code as a starting point:
The Droplet module allows you to create DigitalOcean Droplets within the VPC created by the VPC module. You can use this module by including the following code in your Terraform configuration:

```hcl
module "droplet" {
  source      = "cypik/droplet/digitalocean"
  version     = "1.0.2"
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


## Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/cypik/terraform-digitalocean-droplet/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-digitalocean-droplet/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/digitalocean | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.default](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_floating_ip.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/floating_ip) | resource |
| [digitalocean_floating_ip_assignment.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/floating_ip_assignment) | resource |
| [digitalocean_ssh_key.default](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [digitalocean_volume.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume) | resource |
| [digitalocean_volume_attachment.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backups"></a> [backups](#input\_backups) | Boolean controlling if backups are made. Defaults to false. | `bool` | `false` | no |
| <a name="input_block_storage_filesystem_label"></a> [block\_storage\_filesystem\_label](#input\_block\_storage\_filesystem\_label) | Initial filesystem label for the block storage volume. | `string` | `"data"` | no |
| <a name="input_block_storage_filesystem_type"></a> [block\_storage\_filesystem\_type](#input\_block\_storage\_filesystem\_type) | Initial filesystem type (xfs or ext4) for the block storage volume. | `string` | `null` | no |
| <a name="input_block_storage_size"></a> [block\_storage\_size](#input\_block\_storage\_size) | (Required) The size of the block storage volume in GiB. If updated, can only be expanded. | `number` | `5` | no |
| <a name="input_droplet_agent"></a> [droplet\_agent](#input\_droplet\_agent) | A boolean indicating whether to install the DigitalOcean agent used for providing access to the Droplet web console in the control panel. By default, the agent is installed on new Droplets but installation errors (i.e. OS not supported) are ignored. To prevent it from being installed, set to false. To make installation errors fatal, explicitly set it to true. | `bool` | `false` | no |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | The number of droplets / other resources to create | `number` | `1` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | the size slug of a droplet size | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_enable_firewall"></a> [enable\_firewall](#input\_enable\_firewall) | Enable default Security Group with only Egress traffic allowed. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to control the droplet creation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_floating_ip"></a> [floating\_ip](#input\_floating\_ip) | (Optional) Boolean to control whether floating IPs should be created. | `bool` | `false` | no |
| <a name="input_graceful_shutdown"></a> [graceful\_shutdown](#input\_graceful\_shutdown) | A boolean indicating whether the droplet should be gracefully shut down before it is deleted. | `bool` | `false` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The image name or slug to lookup. | `string` | `"ubuntu-22-04-x64"` | no |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | List of objects that represent the configuration of each inbound rule. | `any` | `[]` | no |
| <a name="input_ipv6"></a> [ipv6](#input\_ipv6) | (Optional) Boolean controlling if IPv6 is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name  (e.g. `it-admin` or `devops`). | `string` | `""` | no |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | Name  (e.g. `~/.ssh/id_rsa.pub` or `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQ`). | `string` | `""` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `cypik`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'cypik' | `string` | `"cypik"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | (Optional) Boolean controlling whether monitoring agent is installed. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_outbound_rule"></a> [outbound\_rule](#input\_outbound\_rule) | List of objects that represent the configuration of each outbound rule. | <pre>list(object({<br>    protocol              = string<br>    port_range            = string<br>    destination_addresses = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "destination_addresses": [<br>      "0.0.0.0/0",<br>      "::/0"<br>    ],<br>    "port_range": "1-65535",<br>    "protocol": "tcp"<br>  },<br>  {<br>    "destination_addresses": [<br>      "0.0.0.0/0",<br>      "::/0"<br>    ],<br>    "port_range": "1-65535",<br>    "protocol": "udp"<br>  }<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create VPC, like `blr1` | `string` | `"blr1"` | no |
| <a name="input_resize_disk"></a> [resize\_disk](#input\_resize\_disk) | (Optional) Boolean controlling whether to increase the disk size when resizing a Droplet. It defaults to true. When set to false, only the Droplet's RAM and CPU will be resized. Increasing a Droplet's disk size is a permanent change. Increasing only RAM and CPU is reversible. | `bool` | `true` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH key | `string` | `""` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | (Optional) A string of the desired User Data for the Droplet. | `string` | `null` | no |
| <a name="input_vpc_uuid"></a> [vpc\_uuid](#input\_vpc\_uuid) | The ID of the VPC where the Droplet will be located. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_disk"></a> [disk](#output\_disk) | The size of the instance's disk in GB. |
| <a name="output_fingerprint"></a> [fingerprint](#output\_fingerprint) | The fingerprint of the SSH key. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Droplet. |
| <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address) | The IPv4 address. |
| <a name="output_ipv4_address_private"></a> [ipv4\_address\_private](#output\_ipv4\_address\_private) | The private networking IPv4 address. |
| <a name="output_ipv6"></a> [ipv6](#output\_ipv6) | Is IPv6 enabled. |
| <a name="output_ipv6_address"></a> [ipv6\_address](#output\_ipv6\_address) | The IPv6 address. |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The unique ID of the key. |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | The name of the SSH key. |
| <a name="output_locked"></a> [locked](#output\_locked) | Is the Droplet locked. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Droplet. |
| <a name="output_price_hourly"></a> [price\_hourly](#output\_price\_hourly) | Droplet hourly price. |
| <a name="output_price_monthly"></a> [price\_monthly](#output\_price\_monthly) | Droplet hourly price. |
| <a name="output_public_key"></a> [public\_key](#output\_public\_key) | The text of the public key. |
| <a name="output_region"></a> [region](#output\_region) | The region of the Droplet. |
| <a name="output_size"></a> [size](#output\_size) | The instance size. |
| <a name="output_status"></a> [status](#output\_status) | The status of the Droplet. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags associated with the Droplet. |
| <a name="output_urn"></a> [urn](#output\_urn) | The uniform resource name of the Droplet. |
| <a name="output_vcpus"></a> [vcpus](#output\_vcpus) | The number of the instance's virtual CPUs. |
<!-- END_TF_DOCS -->
