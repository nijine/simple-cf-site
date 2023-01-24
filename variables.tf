variable "domain_name" {
  description = "The domain name of your site. Typically matches the name of your hosted zone."
  type        = string
}

variable "s3_origin_id" {
  description = "Origin ID for CloudFront."
  type        = string
  default     = "S3SiteOrigin"
}

variable "environment_tag" {
  description = "An optional tag applied to some of the created resources."
  type        = string
  default     = "development"
}

variable "root_object" {
  type    = string
  default = "index.html"
}

variable "error_object" {
  type    = string
  default = "error.html"
}

variable "price_class" {
  description = "The price class for your CloudFront distribution. Ultimately defines which regions are served by the CDN."
  type        = string
  default     = "PriceClass_All"
}

variable "www_dir" {
  description = "The local location of your website content."
  type        = string
  default     = "/dev/null"
}

variable "default_cache_func_assoc" {
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []
}
