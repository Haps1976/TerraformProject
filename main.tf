# create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}
# Create Ownership
resource "aws_s3_bucket_ownership_controls" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
# Create Public Access BLock
resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Create ACL
resource "aws_s3_bucket_acl" "mybucket" {
  depends_on = [aws_s3_bucket_ownership_controls.mybucket,
                aws_s3_bucket_public_access_block.mybucket]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}
# Create Index for Website Deployment
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}
# Create Error for Website Deployment
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

# Create Profile Image on Website
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key = "profile.webp"
  source = "profile.webp"
  acl = "public-read"
}

# Create Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
   index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.mybucket]
}