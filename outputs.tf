output "thisbit_s3_bucket" {
  description = "Enter this bucket name under External location (S3) on the Integrations page."
  value       = aws_s3_bucket.thisbit.bucket
}

output "thisbit_s3_region" {
  description = "AWS region of the S3 bucket."
  value       = aws_s3_bucket.thisbit.region
}

output "thisbit_access_key_id" {
  description = "Access Key ID for the least-privilege Thisbit S3 IAM user."
  value       = var.create_iam_user ? aws_iam_access_key.thisbit_connector[0].id : null
}

output "thisbit_secret_access_key" {
  description = "Secret Access Key for the least-privilege Thisbit S3 IAM user (retrieve with: terraform output -raw thisbit_secret_access_key)."
  value       = var.create_iam_user ? aws_iam_access_key.thisbit_connector[0].secret : null
  sensitive   = true
}
