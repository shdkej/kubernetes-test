resource "digitalocean_domain" "default" {
  name = "shdkej.com"
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.default.name
  type = "A"
  name = "www"
  value = digitalocean_droplet.master.ipv4_address
}
