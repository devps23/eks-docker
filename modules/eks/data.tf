data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "RHEL-9-DevOps-Practice"
  owners           = ["973714476881"]
}
# get existing assume role policy from service
# data "aws_iam_policy_document" "instance_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }