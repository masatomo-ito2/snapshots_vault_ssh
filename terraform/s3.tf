data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket
}

resource "aws_s3_bucket_object" "object" {
  count   = 5
  bucket  = var.s3_bucket
  key     = "file${count.index}"
  content = "Content ${count.index}"
}
