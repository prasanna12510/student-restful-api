# run_task

Use this module to run any script within service private VPC. If you want to run a long-running service (e.g. an API), please take a look at [modules/terraform/aws/ecs/service](../service/main.tf) instead. Script is defined using [modules/terraform/aws/ecs/task_definition](../task_definition/main.tf) module.

## Usage

```sh
module "run_script" {
  source                    = "../../../../modules/terraform/aws/ecs/run_task"
  region                    = "ap-southeast-1"
  cluster_name              = "my-cluster"
  task_definition_arn       = "task-definition-arn"
  launch_type               = "FARGATE"         # Either FARGATE or EC2
  awsvpc_private_subnet_ids = ["subnet-id-1"]   # MUST be a private subnet
  awsvpc_security_group_ids = ["sg-id-1"]
}
```
