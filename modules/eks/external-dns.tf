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


