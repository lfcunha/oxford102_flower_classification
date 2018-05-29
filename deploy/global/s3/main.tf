resource "aws_s3_bucket" "terraform_state" {
  bucket = "lfcunha-terraform"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true  # set to false to be able to destoy this resource
  }
}
