variable "bucket_name" {
  description = "Globally unique S3 bucket name (3 to 63 lowercase letters, digits, dots or hyphens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3 to 63 lowercase letters, digits, dots or hyphens."
  }
}

variable "region" {
  description = "AWS region where the S3 bucket is created."
  type        = string
  default     = "eu-west-1"
}

variable "create_iam_user" {
  description = "Create a dedicated least-privilege IAM user + access key scoped only to studio-media/* and voice-reviews/*."
  type        = bool
  default     = true
}

variable "iam_user_name" {
  description = "Optional custom IAM user name (defaults to thisbit-byoc-<bucket_name>)."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to created AWS resources."
  type        = map(string)
  default     = {}
}
