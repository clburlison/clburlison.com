terraform {
  backend "s3" {
    bucket = "clburlison-terraform"
    key    = "website.tfstate"
    region = "us-east-1"
  }
}
