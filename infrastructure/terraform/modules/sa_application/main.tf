data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

// Cluster autoscaler
resource "aws_iam_role" "eks_sa" {
  name = "eks_sa_${var.app_name}_${var.namespace}_${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.cluster_oidc_issuer}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {

          StringLike = {
            "${local.cluster_oidc_issuer}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_sa" {
  name = "eks_sa_${var.app_name}_${var.namespace}_${data.aws_region.current.name}"
  policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:*",
        ]
        Resource = [
          "*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:*",
        ]
        Resource = [
          "*",
        ]
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_sa" {
  role       = aws_iam_role.eks_sa.name
  policy_arn = aws_iam_policy.eks_sa.arn
}