provider "aws" {
	region = "ap-northeast-1"
}

resource "aws_s3_object" "bucket" {
  count   = 5

  bucket = "hashicorp-demo"
  key     = "file${count.index}"
  content = "Content ${count.index}"

	tags = {
		Name = "test bucket"
		Environement = "Dev"
	}
}

