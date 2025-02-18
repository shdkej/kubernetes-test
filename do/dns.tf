resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  type = "A"
  name = "www"
  value = digitalocean_droplet.master.ipv4_address
  proxied = true
}
