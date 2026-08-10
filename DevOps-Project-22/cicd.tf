resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "GitHub Actions OIDC"
  }
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    sid     = "GitHubActionsOIDC"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:SubhamPanwarr/DevOps-Projects:ref:refs/heads/master"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_deploy" {
  name                 = "project22-github-actions-deploy"
  description          = "Deploys Project 22 Lambda code from the trusted GitHub master branch"
  assume_role_policy   = data.aws_iam_policy_document.github_actions_assume_role.json
  max_session_duration = 3600

  tags = {
    Name = "Project 22 GitHub Actions deployment role"
  }
}

data "aws_iam_policy_document" "github_actions_lambda_deploy" {
  statement {
    sid = "DeployProject22Lambda"

    actions = [
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:UpdateFunctionCode"
    ]

    resources = [
      aws_lambda_function.api_lambda.arn
    ]
  }
}

resource "aws_iam_role_policy" "github_actions_lambda_deploy" {
  name   = "project22-lambda-deployment"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.github_actions_lambda_deploy.json
}
