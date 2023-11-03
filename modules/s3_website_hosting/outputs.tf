output "bucket-id" {
   value = aws_s3_bucket.website_bucket.bucket
}

output "bucket-url" {
   value = aws_s3_bucket_website_configuration.website_configuration.website_domain
}

output "cloudFront_url" {
   value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "bucket-arn" {
   value = aws_s3_bucket.website_bucket.arn
}