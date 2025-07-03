# GitHub OIDC Provider for secure authentication (AWS only)
resource "aws_iam_openid_connect_provider" "github" {
  count = var.cloud_provider == "aws" ? 1 : 0
  
  url = "https://token.actions.githubusercontent.com"
  
  client_id_list = ["sts.amazonaws.com"]
  
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
  
  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-github-oidc"
  })
}

# IAM Role for GitHub Actions (AWS only)
resource "aws_iam_role" "github_actions" {
  count = var.cloud_provider == "aws" ? 1 : 0
  name  = "${local.resource_prefix}-github-actions-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github[0].arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
          }
        }
      }
    ]
  })
  
  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-github-actions-role"
  })
}

# IAM Policy for GitHub Actions (AWS only)
resource "aws_iam_policy" "github_actions" {
  count       = var.cloud_provider == "aws" ? 1 : 0
  name        = "${local.resource_prefix}-github-actions-policy"
  description = "Policy for GitHub Actions to deploy ${var.project_name} in ${var.environment}"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # ECR permissions
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          # ECS permissions
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeClusters",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:ListTasks",
          "ecs:DescribeTasks"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          # CloudWatch Logs
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/ecs/${local.resource_prefix}*"
      },
      {
        Effect = "Allow"
        Action = [
          # IAM permissions for ECS tasks
          "iam:PassRole"
        ]
        Resource = module.aws_ecs[0].ecs_execution_role_arn
      }
    ]
  })
  
  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-github-actions-policy"
  })
}

# Attach policy to role (AWS only)
resource "aws_iam_role_policy_attachment" "github_actions" {
  count      = var.cloud_provider == "aws" ? 1 : 0
  role       = aws_iam_role.github_actions[0].name
  policy_arn = aws_iam_policy.github_actions[0].arn
} 