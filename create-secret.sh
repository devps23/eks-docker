 kubectl create secret  generic  vault-token --from-literal=token=hvs.T8WnPWmYmGZkPYlGAHXVmebk
#  if pods are created under argocd then vault-token also create under argocd only
 kubectl create secret  generic  vault-token --from-literal=token=hvs.T8WnPWmYmGZkPYlGAHXVmebk -n argocd
hvs.T8WnPWmYmGZkPYlGAHXVmebk