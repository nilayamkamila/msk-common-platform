#########################################
# locals.tf — auto-detect your local IP
#########################################

# Fetch current public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

# Trim whitespace and append /32
locals {
  local_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}
