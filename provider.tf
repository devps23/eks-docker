provider "vault" {
  address = "https://vault-internal.pdevops72.online:8200"
  token = "hvs.T8WnPWmYmGZkPYlGAHXVmebk"
  skip_tls_verify = true
}
provider "helm" {
  version = "~> 2.0"  # Ensuring you're using version 2.x or later
  kubernetes {
    config_path = "~/.kube/config"  # Path to your kubeconfig file
  }
}
