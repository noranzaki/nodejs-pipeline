terraform {
  backend "s3" {
    bucket = "myawsbucket-terraform-day1"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-statelock"
  }
}
