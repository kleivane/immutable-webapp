terraform {
  backend "s3" {
    bucket = "tf-immutable-infrastructure-remote-state-storage"
    key    = "immutable_web_app_prod"
    region = "eu-north-1"
  }
}
