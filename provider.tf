provider "vault" {
  address = "https://vault-internal.pdevops78.online:8200"
  token = "hvs.T8WnPWmYmGZkPYlGAHXVmebk"
  skip_tls_verify = true
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}