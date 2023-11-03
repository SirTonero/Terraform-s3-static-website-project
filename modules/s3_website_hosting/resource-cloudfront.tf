locals {
   s3_origin_id = "MyS3Origin"
}


# Cloudfront- Origin acess Control
resource "aws_cloudfront_origin_access_control" "cloudfront-oac" {
   name                              = "OAC-${aws_s3_bucket.website_bucket.bucket}"
   description                       = "Origin access control for an s3 bucket"
   origin_access_control_origin_type = "s3"
   signing_behavior                  = "always"
   signing_protocol                  = "sigv4"
}

# cloudFront Distribution.
resource "aws_cloudfront_distribution" "s3_distribution" {
   origin {
      domain_name              = aws_s3_bucket.website_bucket.bucket_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront-oac.id
      origin_id                = local.s3_origin_id
   }

   enabled             = true
   comment             = "This distribution enables access to an s3 bucket"
   default_root_object = "index.html"


   default_cache_behavior {
      allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = local.s3_origin_id

      forwarded_values {
         query_string = false
         cookies {
            forward = "none"
         }
      }

      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
   }

   price_class = "PriceClass_200"


   restrictions {
      geo_restriction {
         restriction_type = "none"
         locations        = []
      }
   }

   viewer_certificate {
      cloudfront_default_certificate = true
   }


}

resource "terraform_data" "invalidate_cache" {
   triggers_replace = terraform_data.content_version.output

   ## create a local-exec provisioner to invalidate cache
   provisioner "local-exec" {
      command = <<COMMAND
aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} --paths "/*"
      COMMAND 
   }

}
