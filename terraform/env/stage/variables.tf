# You  will need to create a 'terraform.tfvars' file providing your secret keys and credentials
variable "ACCESS_KEY" {
  description = "AWS ACCESS_KEY. Should be in terraform.tfvars file."
}
variable "SECRET_KEY" {
  description = "AWS SECRET_KEY. Should be in terraform.tfvars file."
}
variable "REGION" {
  default = "us-east-1"
}

variable "ENV" {
  default = "staging"
}

variable "APP_NAME" {
  default = "aclu"
}

variable "KEY_PAIR" {
  description = "Key Pair file name to ssh into instances."
  default     = "aclu"
}

variable "FRONT_END_BUCKET_NAME" {
  default = "hi.aclu.com"
}

variable "SOURCE_BUCKET_ARN" {
  default = "arn:aws:s3:::temp-felimartina"
}

variable "GITHUB_OWNER" {
  description = "Gtihub account. Also needs to provide GITHUB_TOKEN valid for this user. Should be in terraform.tfvars file."
}

variable "GITHUB_REPO" {
  default = "ACLU"
}

variable "GITHUB_BRANCH" {
  default = "master"
}

variable "GITHUB_TOKEN" {
  description = "OAuth token from github to grant CodePipeline access to your github repo. Should be in terraform.tfvars file."
}

variable "admin_cidrs" {
  type = "list"

  default = [
    "50.113.42.119/32", # Pipe's IP
  ]
}