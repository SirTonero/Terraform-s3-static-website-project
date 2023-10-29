module "s3_website_module" {
   source = "./modules/s3_website_hosting"
   bucket_name = var.bucket_name
   public_path = var.public_path
   content_version = var.content_version
   assets_path = var.assets_path
}