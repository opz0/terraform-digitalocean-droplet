module "labels" {
  source      = "git::https://github.com/opz0/terraform-digitalocean-labels.git?ref=v1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}
resource "digitalocean_ssh_key" "default" {
  count      = var.enabled == true ? 1 : 0
  name       = var.key_name == "" ? format("%s-key-%s", module.labels.id, (count.index)) : var.key_name
  public_key = var.ssh_key != "" ? var.ssh_key : file(var.key_path)
}

resource "digitalocean_droplet" "main" {
  count             = var.enabled == true ? var.droplet_count : 0
  image             = var.image_name
  name              = format("%s-droplet-%s", module.labels.id, (count.index))
  region            = var.region
  size              = var.droplet_size
  backups           = var.backups
  monitoring        = var.monitoring
  ipv6              = var.ipv6
  ssh_keys          = [join("", digitalocean_ssh_key.default[*].id)]
  resize_disk       = var.resize_disk
  user_data         = var.user_data
  vpc_uuid          = var.vpc_uuid
  droplet_agent     = var.droplet_agent
  graceful_shutdown = var.graceful_shutdown
  tags = [
    format("%s-%s-%s", module.labels.id, "droplet", (count.index)),
    module.labels.name,
    module.labels.environment,
    module.labels.managedby
  ]
}

resource "digitalocean_volume" "main" {
  count                    = var.enabled == true ? var.droplet_count : 0
  region                   = var.region
  name                     = format("%s-volume-%s", module.labels.id, (count.index))
  size                     = var.block_storage_size
  description              = "Block storage for ${element(digitalocean_droplet.main[*].name, count.index)}"
  initial_filesystem_label = var.block_storage_filesystem_label
  initial_filesystem_type  = var.block_storage_filesystem_type
  tags = [
    format("%s-%s-%s", module.labels.id, "volume", (count.index)),
    module.labels.name,
    module.labels.environment,
    module.labels.managedby
  ]
}

resource "digitalocean_volume_attachment" "main" {
  depends_on = [digitalocean_droplet.main, digitalocean_volume.main]
  count      = var.enabled == true ? var.droplet_count : 0
  droplet_id = element(digitalocean_droplet.main[*].id, count.index)
  volume_id  = element(digitalocean_volume.main[*].id, count.index)
}

##---------------------------------------------------------------------------------------------------------------------------------------------------
#Description : Provides a DigitalOcean Floating IP to represent a publicly-accessible static IP addresses that can be mapped to one of your Droplets.
##---------------------------------------------------------------------------------------------------------------------------------------------------
resource "digitalocean_floating_ip" "main" {
  count  = var.floating_ip == true && var.enabled == true ? var.droplet_count : 0
  region = var.region
}

resource "digitalocean_floating_ip_assignment" "main" {
  count      = var.floating_ip == true && var.enabled == true ? var.droplet_count : 0
  ip_address = element(digitalocean_floating_ip.main[*].id, count.index)
  droplet_id = element(digitalocean_droplet.main[*].id, count.index)
  depends_on = [digitalocean_droplet.main, digitalocean_floating_ip.main, digitalocean_volume_attachment.main]
}

#tfsec:ignore:digitalocean-compute-no-public-egress
resource "digitalocean_firewall" "default" {
  depends_on  = [digitalocean_droplet.main]
  count       = var.enable_firewall == true && var.enabled == true ? 1 : 0
  name        = format("%s-droplet-firewall", module.labels.id)
  droplet_ids = digitalocean_droplet.main[*].id

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      port_range       = inbound_rule.value.allowed_ports
      protocol         = lookup(inbound_rule.value, "protocol", "tcp")
      source_addresses = inbound_rule.value.allowed_ip
    }
  }

  dynamic "outbound_rule" {
    for_each = var.outbound_rule
    content {
      protocol              = outbound_rule.value.protocol
      port_range            = outbound_rule.value.port_range
      destination_addresses = outbound_rule.value.destination_addresses
    }
  }

  tags = [
    module.labels.name,
    module.labels.environment,
    module.labels.managedby
  ]
}