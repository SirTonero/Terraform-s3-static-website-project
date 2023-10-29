variable "bucket_name" {
   description = "Bucket name"
   type = string
}

variable "public_path" {
   description = "public path to website files"
   type = string
}
variable "content_version" {
   type = number
}

variable "assets_path" {
   description = "path  to assets files"
   type = string
}