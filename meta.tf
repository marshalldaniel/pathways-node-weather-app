terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "marshalldaniel-tfstate-main"
    region = "ap-southeast-1"
  }
}