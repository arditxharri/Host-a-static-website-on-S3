output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_web.website_endpoint
}