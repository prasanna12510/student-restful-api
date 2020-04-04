######################################################  REMOTE STATE  ##################################################
data "terraform_remote_state" "student-service_infra_state" {
  backend = "remote"
  config = {
    organization = "terracloud-utility"
    token        = "TF_CLOUD_TOKEN"
    workspaces = {
      name = "student-service-infra-${terraform.workspace}"
    }
  }
}


######################################################  RESOURCES  #####################################################

module "student-api_parameters" {
  source    = "../../../modules/terraform/aws/parameterstore"
  tags      = { ManagedBy = "${local.name}" }

  parameter_write = [
    {
      description = "student-api APP NAME",
      name        = "/app/student-service/NAME",
      overwrite   = "true",
      type        = "String",
      value       = "${var.env[terraform.workspace].APP_NAME}"
    },
    {
      description = "student-api VPC-ID",
      name        = "/app/student-service/VPCID",
      overwrite   = "true",
      type        = "String",
      value       = data.terraform_remote_state.student-service_infra_state.outputs.vpc_id
    }
]
}


######################################################  OUTPUTS  #####################################################

output "student-api_parameters" {
  value = module.student-api_parameters.map
}
