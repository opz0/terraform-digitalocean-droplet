provider "digitalocean" {}


##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "cypik/vpc/digitalocean"
  version     = "1.0.1"
  name        = "app"
  environment = "test"
  region      = "blr1"
  ip_range    = "10.20.0.0/24"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source      = "./../"
  name        = "app"
  environment = "test"
  region      = "blr1"

  droplet_count = 1
  vpc_uuid      = module.vpc.id
  ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIEcTzWlK/Cl0d0xaS3llNSrFWQbK+uhtwDz8OMYcBAYWdzQ2FV+R19QXjJIMF33oqBWNiiGtMcx+u5YWBUWia3ckNXaQpsWfcUpT549tOEfZ9ZbV6yk6nuV/vGU0p+HFvKpYaYo+DxJaYFOAuL1Tqc/Kdl3VyltwMLut5JAScQWJhlT8OltF2Pc+S8ZjBcbrpR3109Rz/lfijYRJWsRDSChSRBXhsanYotselm9vlWzZW+libeIXYSVp/7WNdDCMvrnb6fkCnq4WfkkQEZJ74J4gLG9UpIiJosadKFdB+J1rZq3D7KNQ1gjuWv/uU77WmpQUMCX5CM9rp1q3ipTAOqcZhCDi3qQuMhPeojsuCeTsB727IZ8+XeXDWiWHZXZKvvvMy+itVOP48qkwnO1ByiGaE7J/tC1cOG6/ihoBox5Sg4hnZEQk9CrNtHV+i8ojE2oF2jYxF620YMPJO31JVZd//IzJNFNCOvCPIhy2t2967zy1sBBNy/p4MDUSsGTc= baldev@baldev"
  user_data     = file("user-data.sh")
  ####firewall
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