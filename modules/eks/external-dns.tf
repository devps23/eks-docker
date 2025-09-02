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

#  create an iam role and attach  trust policy
#  create a role with "eks-pod-identity-external-dns"
resource "aws_iam_role" "external-dns" {
  name               = "eks-pod-identity-external-dns"
  assume_role_policy = data.aws_iam_policy_document.external_role.json
#   the above assume_role_policy is a trust relationships
}

# create an inline policy and attach role, resource + action
#  here policy name is "external-dns"
resource "aws_iam_role_policy" "external_dns_policy" {
  name = "external-dns"
  role = aws_iam_role.external-dns.id
  policy = file("${path.module}/policy-external-dns.json")
#   attach policy-external-dns.json to external-dns
}

resource "aws_iam_role_policy" "ebs-csi-driver" {
  name = "ebs-csi"
  role = aws_iam_role.external-dns.id
  policy = file("${path.module}/policy-ebs-csi-driver.json")
}

resource "aws_iam_role_policy" "auto-scaler" {
  name = "auto-scaler"
  role = aws_iam_role.external-dns.id
  policy = file("${path.module}/policy-auto-scaler.json")
}


#  create pod identity and  attach to cluster
resource "aws_eks_pod_identity_association" "external-pod-association" {
  cluster_name    = aws_eks_cluster.cluster.name
  namespace       = "default"
  service_account = "dns-sa"
  role_arn        = aws_iam_role.external-dns.arn
}
# resource "kubernetes_service_account" "external_dns" {
#   metadata {
#     name      = "dns-sa"               #  Service account name
#     namespace = "kube-system"          #  Namespace where pods are deployed
#
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.cluster-role.arn
#       # 👆 Link this SA to IAM Role via IRSA
#     }
#   }
# }

#  create a pod and serviceaccount name with external-dns
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









