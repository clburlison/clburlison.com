variable "s3_bucket_name" {
  type    = "string"
  default = "clburlison.com"
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "ssl_cert_arn" {
  type        = "string"
  description = "Used for CloudFront distribution point. Use Amazon Certificate Manager to create. Make sure to add all CNAMES: www.example.com, example.com, etc."
  default     = "arn:aws:acm:us-east-1:029516313545:certificate/0ed36f57-8d4a-495e-bb17-85a6fd10657b"
}

variable "dns_zone" {
  type        = "string"
  description = "If using a sub domain like blog.example.com you should use example.com. root level just example.com"
  default     = "clburlison.com"
}

variable "dns_record" {
  type    = "string"
  default = "clburlison.com"
}

variable "alt_dns_record" {
  type    = "string"
  default = "www.clburlison.com"
}

variable "content-secret" {
  type        = "string"
  description = "Litteraly just a random string. You can use mine if you'd like. Used to restrict s3 read access so CF is used."
  default     = "D480BBA0-8172-4BD0-894F-6086A816FAC3"
}
