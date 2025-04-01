data "aws_iam_policy_document" "external_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "external-dns" {
  name               = "eks-pod-identity-external-dns"
  assume_role_policy = data.aws_iam_policy_document.external_role.json
}

resource "aws_iam_role_policy" "external_dns_policy" {
  name = "external-dns"
  role = aws_iam_role.external-dns.id
  policy = file("${path.module}/policy-external-dns.json")
}

resource "aws_eks_pod_identity_association" "external--pod-assocation" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "default"
  service_account = "dns-sa"
  role_arn        = aws_iam_role.external-dns.arn
}

resource "helm_release" "external-dns" {
  depends_on = [null_resource.aws-auth,aws_iam_role_policy.external_dns_policy]
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.14.5"
  namespace = "default"

  set {
    name  = "serviceAccount.name"
    value = "dns-sa"

  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "argocd"
  chart = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  set {
    name  = "service.type"
    value = "LoadBalancer"

  }
}

# resource "helm_release" "grafana" {
#   chart      = "grafana"
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   namespace  = "default"
#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }
# }
# resource "helm_release" "alertmanager" {
#   name       = "alertmanager"
#   chart      = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   namespace  = "monitoring"
#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }
# }



