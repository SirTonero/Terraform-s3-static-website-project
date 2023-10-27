module "s3_website_module" {
   source = "./modules/s3_website_hosting"
   bucket_name = var.bucket_name
}