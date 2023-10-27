// Create a bucket to house the static website
resource "aws_s3_bucket" "website_bucket" {
   bucket = var.bucket_name

   tags = {
      Name = "s3-website bucket"
   }
}

// enambling website configuration

resource "aws_s3_bucket_website_configuration" "website_configuration" {
   bucket = aws_s3_bucket.website_bucket.bucket

   index_document {
      suffix = "index.html"
   }

   error_document {
      key = "error.html"
   }
}

