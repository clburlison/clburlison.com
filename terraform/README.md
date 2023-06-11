# Terraform setup

This configuration is what I use to manage my website. It is currently using
the following AWS tech stack:

* CloudFront (CF) - CDN
* S3 - object storage
* Route53 - DNS (Optional)
* Certificate Manager - Free SSL certs

If you have ever used AWS you will know the options are limitless. For
consistency of this setup I am using Terraform to manage my infrastructure.

## Usage

### Create your backend terraform storage

All actions should take place inside the backend folder IE - `cd backend`

* Setup AWS keys (`~/.aws/config` & `~/.aws/credentials`)
* Download [Terraform](https://www.terraform.io/downloads.html)
* `export AWS_PROFILE=personal` set your AWS profile (optional)
* Make modifications to your `vars.tf` file
* `terraform init`
* `terraform plan`
* `terraform apply`

### Create your website resources

All actions should take place at root of this README.md file

* Manually create a SSL Certificate with AWS Certificate Manager
* Modify the `vars.tf` file with your settings.
* Match the vars from `backend/vars.tf` into the `backend.tf` file
* `terraform init`
* `terraform plan`
* `terraform apply`
* Wait...

No seriously keep waiting. Building a CF distribution point takes a while...

## DNS Notes

Route53 has a $0.50 charge per month just for hosting a domain. This cost,
while nominal, can add up overtime. Many other DNS providers
(Namecheap, Google Domains, etc.) are more than sufficient for most sites
and do not have a monthly charge. If you go with another provider you'll
need to comment out the DNS resources at the bottom of the `main.tf` file.
You will lose the programmatic DNS access that Route53 provides but save
money in the long run.

## (Pretty) URL Notes

CloudFront has no way to rewrite `/path/index.html` to `/path`, also
known as "PrettyUrls", therefore I'm sharing the site using the AWS S3
"static website hosting" feature which supports rewrites. Then CloudFront in
front of this S3 hosting for lower cost and faster speeds.

The hack above means we can not use the built in "cloudfront origin
access identity" to restrict S3 access. And without S3 restriction anyone
could visit the raw S3 site without SSL. To get around the path hack we then
use a "User-Agent" restriction so that only the CloudFront distribution
point can access the S3 static website. Hacky but it works.

### Using ugly urls

In your hugo `config.toml`

    uglyurls = true

Then in the `main.tf`, look for the two blocks encapsulated with
`START` or `END` comments. Comment out the 'pretty' blocks and uncomment
the 'ugly' blocks.

## Resources

* [https://github.com/ringods/terraform-website-s3-cloudfront-route53][]
* [https://lustforge.com/2016/02/27/hosting-hugo-on-aws/][]
