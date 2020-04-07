######################################################  VARIABLES  #####################################################

variable "env" {

  default = {

    play = {
      cidr                 = "192.168.0.0/24"
      cidrs_public         = "192.168.0.0/28,192.168.0.16/28,192.168.0.32/28"
      cidrs_private        = "192.168.0.48/28,192.168.0.64/28,192.168.0.80/28"
      ec2_root_volume_size = "20"
      ec2_instance_type    = "m5.large"
      sns_topic_name       = "student-api-cloudwatch-alarm"
      lambda_name          = "student-api-cloudwatch-slack-alerts"
      slack_channel_name   = "student-api-alerts"

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


########cloudwatch alarms##############
#cloudwatch alarms variables for targetgroup and load_balancer

variable "metric_name" {
  type = map
  default = {
    target_4xx_count       = "HTTPCode_Target_4XX_Count"
    target_5xx_count       = "HTTPCode_Target_5XX_Count"
    elb_5xx_count          = "HTTPCode_ELB_5XX_Count"
    target_response_time   = "TargetResponseTime"
    target_unhealthy_hosts = "UnHealthyHostCount"
    ecs_high_memory        = "MemoryReservation"
    ecs_low_memory         = "MemoryReservation"
    ecs_high_cpu           = "CPUReservation"
    ecs_low_cpu            = "CPUReservation"
    asg_sys_check_failure  = "StatusCheckFailed"

  }
}


variable "statistic" {
  type = map
  default = {
    target_3xx_count       = "Sum"
    target_4xx_count       = "SampleCount"
    target_5xx_count       = "Sum"
    elb_5xx_count          = "Sum"
    target_response_time   = "Average"
    target_unhealthy_hosts = "Maximum"
    ecs_high_memory        = "Average"
    ecs_low_memory         = "Average"
    ecs_high_cpu           = "Average"
    ecs_low_cpu            = "Average"
    asg_sys_check_failure  = "Sum"
  }
}


variable "alarm_name" {
  type        = string
  description = "The string to format and use as the httpcode alarm name"
  default     = "%s"
}


variable "notify_arns" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when this alarm transitions into ANY state from any other state. May be overridden by the value of a more specific {alarm,ok,insufficient_data}_actions variable. "
  default     = []
}


variable "evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

variable "datapoints_to_alarm" {
  type        = number
  description = "Number of datapoints to alarm"
  default     = 1
}



variable "target_4xx_count_threshold" {
  type        = number
  description = "The maximum count of 4XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "target_5xx_count_threshold" {
  type        = number
  description = "The maximum count of 5XX requests over a period. A negative value will disable the alert"
  default     = 25
}

variable "elb_5xx_count_threshold" {
  type        = number
  description = "The maximum count of ELB 5XX requests over a period. A negative value will disable the alert"
  default     = 25
}


variable "target_unhealthy_hosts_threshold" {
  type        = number
  description = "The maximum count of UnHealthyHostCount over a period. A negative value will disable the alert"
  default     = 1
}

variable "target_response_time_threshold" {
  type        = number
  description = "The maximum average target response time (in seconds) over a period. A negative value will disable the alert"
  default     = 0.5
}

variable "ecs_high_memory_threshold" {
  type        = number
  description = "Higher Memory Utilization. A negative value will disable the alert"
  default     = 80
}

variable "ecs_low_memory_threshold" {
  type        = number
  description = "Lower Memory Utilization"
  default     = 40
}

variable "ecs_high_cpu_threshold" {
  type        = number
  description = "High CPU Utlilization. A negative value will disable the alert"
  default     = 80
}

variable "ecs_low_cpu_threshold" {
  type        = number
  description = "Low CPU Utlization. A negative value will disable the alert"
  default     = 40
}

variable "asg_sys_check_failure_threshold" {
  type        = number
  description = "EC2 System check failure. A negative value will disable the alert"
  default     = 1
}


variable "httpcode_alarm_description" {
  type        = string
  description = "The string to format and use as the httpcode alarm description"
  default     = "HTTPCode %v count for %v over %v last %d minute(s) over %v period(s)"
}


variable "target_response_time_alarm_description" {
  type        = string
  description = "The string to format and use as the target response time alarm description"
  default     = "Target Response Time average for %v over %v last %d minute(s) over %v period(s)"
}

variable "utlization_alarm_description" {
  type        = string
  description = "The string to format and use as the target response time alarm description"
  default     = "Utilization Time average for %v over %v last %d minute(s) over %v period(s)"
}


variable "treat_missing_data" {
  type        = string
  description = "Sets how alarms handle missing data points. Values supported: missing, ignore, breaching and notBreaching"
  default     = "missing"
}

#####lambda function variables#####
variable "slack_lambda_permission" {
  type = map

  default = {
    "statement_id" = "AllowExecutionFromSNS"
    "action"       = "lambda:InvokeFunction"
    "principal"    = "sns.amazonaws.com"
  }
}


variable "slack_lambda_runtime" {
  type        = string
  description = "runtime for lambda"
  default     = "python3.7"
}

variable "slack_lambda_function_decsription" {
  type        = string
  description = "lambda function description"
  default     = "Lambda function which sends notifications to Slack"
}

variable "slack_lambda_handler_name" {
  type        = string
  description = "lambda function handler name to send alerts to slack"
  default     = "notify_slack.lambda_handler"
}

variable "slack_lambda_timeout" {
  type        = number
  description = "lambda function name to send alerts to slack"
  default     = 30
}

variable "slack_lambda_log_events" {
  type        = bool
  description = "log events for slack lambda function"
  default     = true
}

variable "sns_subscription_protocol" {
  type        = string
  description = "protocol type for sns subscription"
  default     = "lambda"
}

variable "slack_username" {
  type        = string
  description = "Slack username to post alerts"
  default     = "student-api-alarm"
}

variable "slack_emoji" {
  description = "A custom emoji that will appear on Slack messages"
  type        = string
  default     = ":aws:"
}

variable "slack_webhook_url" {
  description = "The URL of Slack webhook"
  type        = string
  default     = "VAULTED_SLACK_WEBHOOK_URL"
}
