provider "aws" {
  region = var.region
}

module "logs" {
  source                   = "cloudposse/s3-log-storage/aws"
  #version                  = "0.18.0"
  enabled                  = false
  attributes               = compact(concat(module.this.attributes, var.extra_logs_attributes))
  lifecycle_prefix         = var.log_prefix
  standard_transition_days = var.log_standard_transition_days
  glacier_transition_days  = var.log_glacier_transition_days
  expiration_days          = var.log_expiration_days
  force_destroy            = true
  versioning_enabled       = var.log_versioning_enabled

  context = module.this.context
}

module "cloudfront_s3_cdn" {
  source                   = "../../"
  context                  = module.this.context
  parent_zone_name         = var.parent_zone_name
  dns_alias_enabled        = true
  use_regional_s3_endpoint = true
  origin_force_destroy     = true
  cors_allowed_headers     = ["*"]
  cors_allowed_methods     = ["GET", "HEAD", "PUT"]
  cors_allowed_origins     = ["*.fooness.com"]
  cors_expose_headers      = ["ETag"]
  origin_bucket = var.origin_bucket
}

resource "aws_s3_bucket_object" "index" {
  bucket       = module.cloudfront_s3_cdn.s3_bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = md5(file("${path.module}/index.html"))
  tags         = module.this.tags
}

resource "aws_s3_bucket" "origin" {
  dynamic "logging" {
    for_each = var.access_log_bucket_name != "" ? [1] : []
    content {
      target_bucket = var.access_log_bucket_name
      target_prefix = "logs/${module.this.id}/"
    }
  }
} 

