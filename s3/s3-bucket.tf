resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-tc3"
  tags = {
    Name = "Store lambda"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-tc3-g38-lanchonete"
  tags = {
    Name = "Terraform Infra Directory"
  }
}
