// Create a bucket to house the static website
resource "aws_s3_bucket" "website_bucket" {
   bucket = var.bucket_name

   tags = {
      Name = "s3 website bucket"
   }
}

# creating a map to house our content types
locals {
   content_type_map = {
      "js" = "application/javascript"
      "html" = "text/html"
      "css" = "text/css"
   }
}


# uploading Html files to bucket
resource "aws_s3_object" "index_object" {
   bucket = aws_s3_bucket.website_bucket.bucket
   key = "index.html"
   content_type = local.content_type_map["html"]
   source = "${var.public_path}/index.html"
   etag = filemd5("${var.public_path}/index.html")

   lifecycle {
      ignore_changes = [ etag ]
   }
}

resource "aws_s3_object" "error_ebject" {
   bucket = aws_s3_bucket.website_bucket.bucket
   key = "error.html"
   content_type = local.content_type_map["html"]
   source = "${var.public_path}/error.html"
   etag = filemd5("${var.public_path}/error.html")

   ## https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
   lifecycle {
      ignore_changes = [ etag ]
      replace_triggered_by = [terraform_data.content_version.output]
   }
}

resource "aws_s3_object" "app_js" {
   bucket = aws_s3_bucket.website_bucket.bucket 
   key = "app.js"
   content_type = local.content_type_map["js"]
   source = "${var.public_path}/app.js"
   etag = filemd5("${var.public_path}/app.js")

   lifecycle {
      ignore_changes = [ etag ]
      replace_triggered_by = [ terraform_data.content_version.output ]
   }
}


##Upload website styling
resource"aws_s3_object" "style_css" {
   bucket = aws_s3_bucket.website_bucket.bucket
   key = "style/style.css"
   content_type = local.content_type_map["css"]
   source = "${var.public_path}/style/style.css"
   etag = filemd5("${var.public_path}/style/style.css")
   lifecycle {
      ignore_changes = [ etag ]
      replace_triggered_by = [ terraform_data.content_version.output ]
   }
}


#Uploading website Assets to s3 buckets
resource "aws_s3_object" "asset_upload" {
   #https://developer.hashicorp.com/terraform/language/functions/fileset
   for_each = fileset("${var.assets_path}", "*.{jpeg,png,jpg}")
   bucket = aws_s3_bucket.website_bucket.bucket
   key = "assets/${each.key}"
   source = "${var.assets_path}/${each.key}"
   etag = filemd5("${var.assets_path}/${each.key}")

   lifecycle {
      ignore_changes = [ etag ]
      replace_triggered_by = [ terraform_data.content_version.output ]
   }

}
// enabling website configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
   bucket = aws_s3_bucket.website_bucket.bucket

   index_document {
      suffix = "index.html"
   }

   error_document {
      key = "error.html"
   }
}

## Bucket Policy to allow cloudfront access

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# Used to get the current user identity of the aws account to be used.
data "aws_caller_identity" "current" {}

locals {
   bucket_policy = templatefile(var.bucket_policy_path, {
      bucket_arn = aws_s3_bucket.website_bucket.arn,
      account_id = data.aws_caller_identity.current.account_id,
      distribution_id = aws_cloudfront_distribution.s3_distribution.id
   })
}





resource "aws_s3_bucket_policy" "s3_bucket_policy"{
   bucket = aws_s3_bucket.website_bucket.bucket
   policy = local.bucket_policy
   # policy = jsonencode({
   #    "Version" = "2012-10-17",
   #    "Statement" =  {
   #       "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
   #       "Effect" = "Allow",
   #       "Principal" = {
   #          "Service" = "cloudfront.amazonaws.com"
   #       },
   #       "Action" = "s3:GetObject",
   #       "Resource" = "${aws_s3_bucket.website_bucket.arn}/*",
   #       "Condition" = {
   #          "StringEquals" = {
   #             "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
   #          }
   #       }
   #    }, 
   # })
}



