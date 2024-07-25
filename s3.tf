resource "random_id" "bucket_suffix_gen" {
  byte_length = 10
}

resource "aws_s3_bucket" "mio_static_web" {
  bucket = "random-bucket-${random_id.bucket_suffix_gen.hex}"
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.mio_static_web.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_web_s3_policy" {
  bucket = aws_s3_bucket.mio_static_web.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.mio_static_web.arn}/*"
      }
    ]
  })
}
resource "aws_s3_bucket_website_configuration" "static_web" {
  bucket = aws_s3_bucket.mio_static_web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.mio_static_web.id
  key    = "index.html"
  source = "build/index.html"
  etag = filemd5("build/index.html")
  content_type = "text/html"
}
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.mio_static_web.id
  key    = "error.html"
  source = "build/error.html"
  etag = filemd5("build/error.html")
  content_type = "text/html"
}
