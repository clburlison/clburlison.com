provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_user" "circleci" {
  name = "circleci"
  path = "/"
}

resource "aws_iam_access_key" "circleci" {
  user = "${aws_iam_user.circleci.name}"
}

resource "aws_iam_user_policy" "circleci" {
  name = "circleci"
  user = "${aws_iam_user.circleci.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket",
          "s3:GetBucketLocation"
      ],
      "Resource": ["arn:aws:s3:::${var.s3_bucket_name}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.s3_bucket_name}"

  website {
    index_document = "index.html"
    error_document = "404.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyWith": "index.html"
    }
}]
EOF
  }
}

# START: For PrettyURLS
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${var.s3_bucket_name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
      "Condition": {
         "StringEquals": {"aws:UserAgent": "${var.content-secret}"}
      } 
    } 
  ]
}
POLICY
}

# END: For PrettyURLS

# START: For UglyURLS
# resource "aws_s3_bucket_policy" "s3_bucket_policy" {
#   bucket = "${var.s3_bucket_name}"
#   policy =<<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": ["${aws_cloudfront_origin_access_identity.website-cf-identity.iam_arn}"]
#       },
#       "Action": "s3:*",
#       "Resource": ["arn:aws:s3:::${var.s3_bucket_name}/*"]
#     } 
#   ]
# }
# POLICY
# }
# END: For UglyURLS

output "access_key_id" {
  value = "${aws_iam_access_key.circleci.id}"
}

# This is plan text and scary town!! Make sure you know what this means.
# You definitely want to be careful with your terraform state.
output "access_key_secret" {
  value = "${aws_iam_access_key.circleci.secret}"
}

####
# CloudFront Bits
###
resource "aws_cloudfront_origin_access_identity" "website-cf-identity" {
  comment = "Website CloudFront identity"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    # START: For PrettyURLS
    domain_name = "${var.s3_bucket_name}.s3-website-${var.region}.amazonaws.com"
    origin_id   = "myS3Origin"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.content-secret}"
    }

    # END: For PrettyURLS

    # START: For UglyURLS
    # domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    # origin_id   = "myS3Origin"
    # s3_origin_config {
    #   origin_access_identity = "${aws_cloudfront_origin_access_identity.website-cf-identity.cloudfront_access_identity_path}"
    # }
    # END: For UglyURLS
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Website CloudFront distribution"
  default_root_object = "index.html"

  aliases = ["${var.dns_record}", "${var.alt_dns_record}"]

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "360"
    response_code         = "200"
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 120                 # 2min
    default_ttl            = 120                 # 2min
    max_ttl                = 300                 # 5min
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.ssl_cert_arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"            # Warning: Not using SNI costs $600/mo, so use SNI
  }
}

output "cloudfront_dns_name" {
  value = "${aws_cloudfront_distribution.website_distribution.domain_name}"
}

####
# DNS Bits. Only works with Route53.
###
data "aws_route53_zone" "main" {
  name = "${var.dns_zone}."
}

resource "aws_route53_record" "dns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.dns_record}."
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alt-dns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.alt_dns_record}."
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
