terraform {
  backend "s3" {
    bucket = "tf-immutable-infrastructure-remote-state-storage"
    key    = "immutable_web_app_test"
    region = "eu-north-1"
  }
}
