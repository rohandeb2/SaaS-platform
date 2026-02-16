provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "main" {
  provider = aws.us_east_1

  name  = "${var.name_prefix}-waf"
  scope = "CLOUDFRONT"

  default_action { 
    allow {} 
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "GlobalWAF"
    sampled_requests_enabled   = true
  }
}


resource "aws_acm_certificate" "edge" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_cloudfront_distribution" "main" {
  enabled = true
  web_acl_id = aws_wafv2_web_acl.main.arn

  origin_group {
    origin_id = "multi-region-group"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member { origin_id = "primary-us" }
    member { origin_id = "secondary-eu" }
  }

  origin {
    domain_name = var.us_alb_dns_name
    origin_id   = "primary-us"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = var.eu_alb_dns_name
    origin_id   = "secondary-eu"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "multi-region-group"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.edge.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}



resource "aws_globalaccelerator_accelerator" "main" {
  name    = "${var.name_prefix}-accelerator"
  enabled = true
}

resource "aws_globalaccelerator_listener" "main" {
  accelerator_arn = aws_globalaccelerator_accelerator.main.id
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "us" {
  listener_arn          = aws_globalaccelerator_listener.main.id
  endpoint_group_region = "us-east-1"

  endpoint_configuration {
    endpoint_id = var.us_alb_arn
    weight      = 128
  }
}

resource "aws_globalaccelerator_endpoint_group" "eu" {
  listener_arn          = aws_globalaccelerator_listener.main.id
  endpoint_group_region = "eu-west-1"

  endpoint_configuration {
    endpoint_id = var.eu_alb_arn
    weight      = 128
  }
}


