terraform {
  source = "../../resources"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "poc-statefiles-137"
    key            = "terragrunt/cc2/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

inputs = {
  base_name = "cc2"
  region    = "eu-west-2"
}
