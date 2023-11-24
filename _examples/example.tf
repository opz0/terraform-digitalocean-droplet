provider "digitalocean" {}


##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source = "git::https://github.com/cypik/terraform-digitalocean-vpc.git?ref=v1.0.0"

  name        = "app"
  environment = "test"
  region      = "blr1"
  ip_range    = "10.20.0.0/24"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source      = "../"
  name        = "app"
  environment = "test"
  region      = "blr1"

  droplet_count = 1
  vpc_uuid      = module.vpc.id
  ssh_key       = "ssh-rsa AAbimg/NuiVu2rF7xTKiSfBgmhmmv/w7YhI0"
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