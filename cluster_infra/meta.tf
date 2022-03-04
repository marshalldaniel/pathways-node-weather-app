terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "marshalldaniel-tfstate-cluster-infra"
    region = "us-east-1"
  }
}
