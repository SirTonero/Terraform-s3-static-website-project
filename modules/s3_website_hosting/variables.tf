variable "bucket_name" {
   description = "bucket name for our website"
   type = string
}

variable "public_path" {
   description = "public path for our website"
   type = string
}

variable "content_version" {
   description = "content version to be used to trigger to recreate the s3 objectsusing  a replace_triggered_by"
   type = number
}

variable "assets_path" {
   description = "Path to website assets files"
}

variable "bucket_policy_path" {
   description = "Path to bucket policy"
   type = string
}