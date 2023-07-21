# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for mysql. The common variables for each environment to
# deploy mysql are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "${local.base_source_url}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env        = local.environment_vars.locals.environment
  aws_region = local.region_vars.locals.aws_region

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_source_url = "git::git@github.com:cloudposse/terraform-aws-key-pair.git//"
  #└── we pull this terraform module using the ssh protocol. You can still use https-based URLs, e.g. "github.com/cloudposse/terraform-aws-key-pair.git//."
}


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  region                = local.aws_region
  #namespace             = "demo"
  #stage                 = local.env
  name                  = "aws-key-pair-eksdemo1"
  ssh_public_key_path   = "/eksdemo1/ssh_key"
  generate_ssh_key      = true
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}
# Note: The namespace and stage inputs are disabled to shorten the key name.