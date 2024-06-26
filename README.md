# terraform-aws-ecs-app-worker

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs-app-worker/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs-app-worker/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs-app-worker)](https://github.com/DNXLabs/terraform-aws-ecs-app-worker/blob/master/LICENSE)

Terraform-aws-ecs-app-worker is an AWS ECS Application Module for Workers without Application Load Balancer(ALB).

This module is designed to be used with `DNXLabs/terraform-aws-ecs` (https://github.com/DNXLabs/terraform-aws-ecs).

The following resources will be created:
 
 - Cloudwatch Metrics alarm - Provides a CloudWatch Metric Alarm resource.
   - High memory
   - High cpu
 - IAM roles - The cloudwatch event needs an IAM Role to run the ECS task definition. A role is created and a policy will be granted via IAM policy.
 - ECS task definition - A task definition is required to run Docker containers in Amazon ECS. Some of the parameters you can specify in a task definition include:
      - Image - Docker image to deploy.
           - Default value is "dnxsolutions/nginx-hello:latest"
      - CPU - Hard limit of the CPU for the container
           -  Default Value = 0
      - Memory - Hard memory of the container
           -  Default Value = 512
      - Name - Name of the ECS Service
      - Set log configuration
 - ECS Task-scheduler activated by cloudwatch events

In addition you have the option to create or not :

 - Simple Notification Service (SNS) topics - Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms.
 - Cloudwatch Log Groups   
      - You can specify the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653.
      - Export to a S3 Bucket - Whether to mark the log group to export to an S3 bucket (needs the module terraform-aws-log-exporter (https://github.com/DNXLabs/terraform-aws-log-exporter) to be deployed in the account/region)

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_prefix | String prefix for cloudwatch alarms. (Optional, leave blank to use iam\_account\_alias) | `string` | `""` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS service metrics | `list` | `[]` | no |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | `bool` | `false` | no |
| autoscaling\_custom | Set one or more app autoscaling by customized metric | <pre>list(object({<br>    name               = string<br>    scale_in_cooldown  = number<br>    scale_out_cooldown = number<br>    target_value       = number<br>    metric_name        = string<br>    namespace          = string<br>    statistic          = string<br>  }))</pre> | `[]` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | `number` | `4` | no |
| autoscaling\_memory | Enables autoscaling based on average Memory tracking | `bool` | `false` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | `number` | `1` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | `number` | `300` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | `number` | `50` | no |
| autoscaling\_target\_memory | Target average Memory percentage to track for autoscaling | `number` | `90` | no |
| cloudwatch\_logs\_export | Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region) | `bool` | `false` | no |
| cloudwatch\_logs\_retention | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `120` | no |
| cluster\_name | n/a | `string` | `"Name of existing ECS Cluster to deploy this app to"` | no |
| cpu | Hard limit for CPU for the container | `string` | `"0"` | no |
| deployment\_maximum\_percent | Deployment maximum percentage | `string` | `"100"` | no |
| deployment\_minimum\_healthy\_percent | Deployment minumum health percentage | `string` | `"0"` | no |
| desired\_count | Number of containers (tasks) to run | `number` | `1` | no |
| enable\_schedule | Enables schedule to shut down and start up instances outside business hours. | `bool` | `false` | no |
| fargate\_spot | Set true to use FARGATE\_SPOT capacity provider by default (only when launch\_type=FARGATE) | `bool` | `false` | no |
| image | Docker image to deploy (can be a placeholder) | `string` | `"dnxsolutions/nginx-hello:latest"` | no |
| launch\_type | The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2. | `string` | `"EC2"` | no |
| log\_subscription\_filter\_destination\_arn | Destination for log subscription filter (required when log\_subscription\_filter\_enabled=true) | `string` | `""` | no |
| log\_subscription\_filter\_enabled | Enable cloudwatch log subscription filter | `bool` | `false` | no |
| log\_subscription\_filter\_filter\_pattern | Filter pattern for log subscription filter | `string` | `""` | no |
| log\_subscription\_filter\_role\_arn | Role to use for log subscription filter (required when log\_subscription\_filter\_enabled=true) | `string` | `""` | no |
| memory | Hard memory of the container | `string` | `"512"` | no |
| name | Name of your ECS service | `any` | n/a | yes |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| ordered\_placement\_strategy | Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered\_placement\_strategy blocks is 5. | <pre>list(object({<br>    field      = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| placement\_constraints | Rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| schedule\_cron\_start | Cron expression to define when to trigger a start of the auto-scaling group. E.g. 'cron(00 21 ? \* SUN-THU \*)' to start at 8am UTC time. | `string` | `""` | no |
| schedule\_cron\_stop | Cron expression to define when to trigger a stop of the auto-scaling group. E.g. 'cron(00 09 ? \* MON-FRI \*)' to start at 8am UTC time | `string` | `""` | no |
| security\_groups | The security groups associated with the task or service | `any` | `null` | no |
| subnets | The subnets associated with the task or service. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| task\_role\_policies | Custom policies to be added on the task role | `list` | `[]` | no |
| task\_role\_policies\_managed | AWS Managed policies to be added on the task role. | `list` | `[]` | no |
| vpc\_id | VPC ID to deploy this app to | `any` | n/a | yes |
| without\_capacity\_provider | Launch service without capacity provider | `bool` | `false` | no |
| tags | A map of tags to add to service | `map(string)` | `{}`| no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling | n/a |
| aws\_cloudwatch\_log\_group\_arn | n/a |
| aws\_cloudwatch\_log\_group\_name | n/a |

<!--- END_TF_DOCS --->


## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs-app-worker/blob/master/LICENSE) for full details.
