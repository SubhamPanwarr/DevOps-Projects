output "api_invoke_url" {
  description = "Default API Gateway HTTPS endpoint."
  value       = "https://${aws_api_gateway_rest_api.api_gateway.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.api.stage_name}"
}

output "healthcheck_url" {
  description = "Health endpoint used to verify the deployed API."
  value       = "https://${aws_api_gateway_rest_api.api_gateway.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.api.stage_name}/healthz"
}

output "lambda_function_name" {
  description = "Deployed Lambda function name."
  value       = aws_lambda_function.api_lambda.function_name
}

output "artifact_bucket_name" {
  description = "Private S3 bucket used for product images."
  value       = aws_s3_bucket.private_bucket.id
}

output "custom_domain_url" {
  description = "Custom API URL when enable_custom_domain is true."
  value       = var.enable_custom_domain ? "https://${var.domain}" : null
}

output "github_actions_deploy_role_arn" {
  description = "IAM role assumed by the trusted GitHub Actions deployment workflow"
  value       = aws_iam_role.github_actions_deploy.arn
}
