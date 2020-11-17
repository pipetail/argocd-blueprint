terraform {
  backend "s3" {
    bucket         = "tf-state-pipetail-20201107"
    key            = "tfstate/dev"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "tf-lock-development"
  }
}

