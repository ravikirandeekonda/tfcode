resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
resource "aws_s3_bucket" "backend_bucket" {
  bucket = "backend-bucket-${random_string.suffix.result}"
  tags = {
    Name        = "backend-bucket"
    Environment = "Dev"
  }
  
}
#
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.backend_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}
#
resource "aws_s3_bucket_server_side_encryption_configuration" "bucketencrypttf" {
  bucket = aws_s3_bucket.backend_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      //kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "AES256"
    }
  }
}
#
resource "aws_s3_bucket_ownership_controls" "tfs3oc" {
  bucket = aws_s3_bucket.backend_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
#
resource "aws_s3_bucket_acl" "tfs3acl" {
  depends_on = [aws_s3_bucket_ownership_controls.tfs3oc]

  bucket = aws_s3_bucket.backend_bucket.id
  acl    = "private"
}
#
resource "aws_s3_bucket_public_access_block" "tfs3publicaccess" {
  bucket = aws_s3_bucket.backend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#
resource "aws_dynamodb_table" "backend_table" {
  name           = "backend-table-${random_string.suffix.result}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
  tags = {
    Name        = "backend-table"
    Environment = "Dev"
  }
}