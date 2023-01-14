# simple-cf-site
A basic terraform module that stands up an AWS Cloudfront-based website backed by S3.

## Inputs
### Required:
**domain_name** - The domain name of your site, typically matches the name of your hosted zone. Example: `example.com`

### Optional:
**environment_tag** - The value of the `Environment` tag added to the component resources that are created. Default: `development`

**root_object** - The root object to serve when visiting your website's home page. Default: `index.html`

**error_object** - The error object to serve when visiting a page or document that doesn't exist. Default: `error.html`

**price_class** - The price class for your CloudFront distribution. Ultimately defines with regions are served by the CDN. Options include: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. Default: `PriceClass_All`

**www_dir*** - The local file path to your website content. Creates S3 objects for each file present in this directory. Based on the [dir](https://registry.terraform.io/modules/hashicorp/dir/template/latest) module.

## Example Usage

``` main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
  
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "site" {
  source       = "github.com/nijine/simple-cf-site"
  domain_name  = "example.com"
  error_object = "404.html"
  www_dir      = "../www"
}
```
