######################################################  VARIABLES  #####################################################

variable "env" {

  default = {

    play = {
      cidr                 = "192.168.0.0/24"
      cidrs_public         = "192.168.0.0/28,192.168.0.16/28,192.168.0.32/28"
      cidrs_private        = "192.168.0.48/28,192.168.0.64/28,192.168.0.80/28"
      cidrs_elasticache    = "192.168.0.96/28,192.168.0.112/28,192.168.0.128/28"
      ec2_root_volume_size = "20"
      ec2_instance_type    = "t3.medium"


    }
  }
}

variable "assume_role_principle" {
  type = map

  default = {
    "ecs_assume_resources" = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
    "ec2_assume_resources" = ["ec2.amazonaws.com", "ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
  }
}

variable "aws_iam_managed_policy_arns" {
  type    = list
  default = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"]
}

###################custom_policy_actions########################

variable "custom_policy_actions" {
  type = map
  default = {

    "elasticache" = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
      "cloudwatch:PutMetricData"
    ]

    "cloudwatch" = ["logs:*"]
    "ecstaskexecution" = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    "ecs" = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    "s3" = ["s3:GetObject"]
    "ssm" = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:*",
      "ec2messages:*"
    ]
    "lambda" = [
      "lambda:AddPermission",
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:InvokeFunction",
      "lambda:UpdateFunctionConfiguration"
    ]
    "secretmanager" = [
      "secretsmanager:*",
      "cloudformation:CreateChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:DescribeStackResource",
      "cloudformation:DescribeStacks",
      "cloudformation:ExecuteChangeSet",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "kms:DescribeKey",
      "kms:ListAliases",
      "kms:ListKeys",
      "lambda:ListFunctions",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "tag:GetResources"
    ]
    "cloudformation" = [
      "serverlessrepo:CreateCloudFormationChangeSet"
    ]

  }
}

variable "custom_policy_resources" {
  type = map
  default = {
    "ssm"              = ["*"]
    "cloudwatch"       = ["*"]
    "elasticache"      = ["*"]
    "ecstaskexecution" = ["*"]
    "secretmanager"    = ["*"]
    "lambda"           = ["arn:aws:lambda:*:*:function:SecretsManager*"]
    "s3"               = ["arn:aws:s3:::awsserverlessrepo-changesets*"]
    "cloudformation"   = ["arn:aws:serverlessrepo:*:*:applications/SecretsManager*"]
    "ecs"              = ["*"]
  }
}
variable "any_port" {
  default = "0"
}

variable "to_port" {
  default = "65535"
}

variable "any_protocol" {
  default = "-1"
}

variable "tcp_protocol" {
  default = "tcp"
}

variable "all_ips" {
  default = ["0.0.0.0/0"]
}

variable "http_port" {
  default = "80"
}

variable "https_port" {
  default = "443"
}

variable "azs" {
  description = "Availability Zones in AWS to be use"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "service_name" {
  description = "Tag: Service Name for all resources"
  default     = "student-api"
}
variable "owner" {
  description = "Tag: Owner of the resources"
  default     = "student-api"
}

variable "tag" {
  default = "APP_TAG"
}

variable "hosted_zone_name" {
  default = "play-hooq.tv"
}
#s3 alb logs
variable "acl"{
  description = "Access Control List"
  default     = "private"
}

variable "versioning"{
  description = "Versioning"
  default     = true
}

variable "force-destroy"{
  description = "Force Destroy Option"
  default     = true
}

variable "alb_accesslogs_bucket" {
  description = "s3 alb access bucket"
  default = "student-api-alb-logs"
}
