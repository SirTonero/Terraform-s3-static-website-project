output "bucket-id" {
   value = module.s3_website_module.bucket-id
}

output "bucket-url" {
   value = module.s3_website_module.bucket-url
}

output "cloudfront-url" {
   value = module.s3_website_module.cloudFront_url
}

output "bucket-arn" {
   value = module.s3_website_module.bucket-arn
}