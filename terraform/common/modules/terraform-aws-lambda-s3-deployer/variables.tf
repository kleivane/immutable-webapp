variable "src_version" {
  description = "The version of the source code the lambda should run"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "bucket" {
  description = "The arn and bucket id of the bucket to deploy to"
  type        = object({
    id  = string
    arn = string
  })
}

variable "api_url" {
  description = "The api-url to the source code "
  type        = string
}
