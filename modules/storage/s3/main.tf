resource "aws_s3_bucket" "stos3" {

  bucket = "stos3"
  # acl    = "private"
  tags = {
    Name        = "stos3"
    Environment = "Dev"
  }

}