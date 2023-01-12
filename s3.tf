resource "aws_s3_bucket" "b" {
  bucket = "${local.domain_name}-www"

  tags = {
    Name = "${local.domain_name} www content"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::${local.domain_name}-www/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::${local.account_id}:distribution/${aws_cloudfront_distribution.s3_website.id}"]
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "b_owner_ctls" {
  bucket = aws_s3_bucket.b.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "b_pub_block" {
  bucket = aws_s3_bucket.b.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# site content
module "dir" {
  source  = "hashicorp/dir/template"
  version = "1.0.2"

  base_dir = local.www_dir
}

resource "aws_s3_object" "site" {
  for_each = module.dir.files

  bucket       = aws_s3_bucket.b.id
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content

  # track updates
  etag = each.value.digests.md5
}

