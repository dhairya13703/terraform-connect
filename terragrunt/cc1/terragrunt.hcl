terraform {
  source = "../../resources"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "poc-statefiles-137"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

inputs = {
    region="eu-west-2"
    base_name="cc1"
}