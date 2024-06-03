terraform {
    required_providers {
        cloudflare = {
            source = "cloudflare/cloudflare"
        }
    }

    backend "local" {
        # todo
        path = "terraformstate/terraform.tfstate"
        # use workdir instead of path??
    }
}

provider "cloudflare" {
    api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
    type = string
    sensitive = true
}

locals {
    gcp_public_ips = {
      "cloud66" = "34.23.115.253"
      "family" = "34.73.36.163"
      "machine" = "34.73.255.44"
    }
}

# todo do this
variable "records" {
    type = map(object({
        name = string
        value = string
        type = string
    }))
    default = {
        dynamic_dns = {
            name = "windy"
            value = "67.140.90.146"
            type = "A"
        }
        hot = {
            name = "hot"
            value = "windy.griffinht.com"
            type = "CNAME"
        }
        hot_all = {
            name = "*.hot"
            value = "hot.griffinht.com"
            type = "CNAME"
        }
        cool = {
            name = "cool"
            value = "100.117.0.28"
            type = "A"
        }
        cool_all = {
            name = "*.cool"
            value = "cool.griffinht.com"
            type = "CNAME"
        }
    }
}

locals {
    computed_records = merge(var.records, {
        for name, value in local.gcp_public_ips :
        name => {
            name = "${name}.gcp"
            value = value
            type = "A"
        }
    })
}

variable "zone_id" {
    type = string
    default = "d691921860e35a45bc7f99007af14a7d"
}

resource "cloudflare_record" "record" {
    for_each = local.computed_records
    zone_id = var.zone_id
    name = each.value.name
    value = each.value.value
    type = each.value.type
    comment = "auto managed by terraform"
}
