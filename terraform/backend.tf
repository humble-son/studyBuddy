terraform {
  backend "s3" {
    bucket       = "studybuddy-219063677017-us-east-1-an"
    key          = "studybuddy/frontend/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}