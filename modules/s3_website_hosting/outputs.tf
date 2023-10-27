output "bucket-id" {
   value = aws_s3_bucket.website_bucket.bucket
}

output "bucket-url" {
   value = aws_s3_bucket_website_configuration.website_configuration.website_domain
}