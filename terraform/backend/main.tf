provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "backend-bucket" {
  bucket = "${var.backend-bucket-name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name        = "Terraform backend bucket"
    Environment = "prod"
  }
}
