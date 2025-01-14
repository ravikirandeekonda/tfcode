resource "aws_s3_bucket" "backend_bucket" {
  bucket = "backend-bucket-${random_string.suffix.result}"
  tags = {
    Name        = "backend-bucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "backend_table" {
  name           = "backend-table-${random_string.suffix.result}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    Name        = "backend-table"
    Environment = "Dev"
  }
}