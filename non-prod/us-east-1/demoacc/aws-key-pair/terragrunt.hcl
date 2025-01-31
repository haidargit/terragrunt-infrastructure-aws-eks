# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# We can override the terraform block source attribute here to deploy a
# different version of the module in a specific environment. example:

#terraform {
#  source = "${include.envcommon.locals.base_source_url}?ref=v0.19.0"
#}

terraform {
  source = "${include.envcommon.locals.base_source_url}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/aws-key-pair.hcl"
  expose = true
}

inputs = {
  ssh_key_algorithm = "ED25519"
}

# ---------------------------------------------------------------------------------------------------------------------
# Since we need to override any of the common parameters for this environment, so we need to define the required inputs.
# ---------------------------------------------------------------------------------------------------------------------
