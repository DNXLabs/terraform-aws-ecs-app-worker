variable "name" {
  description = "Name of your ECS service"
}

variable "memory" {
  default     = "512"
  description = "Hard memory of the container"
}

variable "cpu" {
  default     = "0"
  description = "Hard limit for CPU for the container"
}

variable "deployment_maximum_percent" {
  default     = "100"
  description = "Deployment maximum percentage"
}

variable "deployment_minimum_healthy_percent" {
  default     = "0"
  description = "Deployment minumum health percentage"
}

variable "desired_count" {
  default     = 1
  description = "Number of containers (tasks) to run"
}

variable "cluster_name" {
  default = "Name of existing ECS Cluster to deploy this app to"
}

variable "service_role_arn" {
  description = "Existing service role ARN created by ECS cluster module"
}

variable "task_role_arn" {
  description = "Existing task role ARN created by ECS cluster module"
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
  default     = "dnxsolutions/nginx-hello:latest"
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS service metrics"
}

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional, leave blank to use iam_account_alias)"
  default     = ""
}

variable "cloudwatch_logs_retention" {
  default     = 120
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
}

variable "cloudwatch_logs_export" {
  default     = false
  description = "Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region)"
}

variable "log_subscription_filter_enabled" {
  type        = bool
  default     = false
  description = "Enable cloudwatch log subscription filter"
}

variable "log_subscription_filter_role_arn" {
  type        = string
  default     = ""
  description = "Role to use for log subscription filter (required when log_subscription_filter_enabled=true)"
}

variable "log_subscription_filter_destination_arn" {
  type        = string
  default     = ""
  description = "Destination for log subscription filter (required when log_subscription_filter_enabled=true)"
}

variable "log_subscription_filter_filter_pattern" {
  default     = ""
  type        = string
  description = "Filter pattern for log subscription filter"
}

variable "ordered_placement_strategy" {
  # This variable may not be used with Fargate!
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5."
  type = list(object({
    field      = string
    expression = string
  }))
  default = []
}

variable "placement_constraints" {
  # This variables may not be used with Fargate!
  description = "Rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

variable "fargate_spot" {
  default     = false
  description = "Set true to use FARGATE_SPOT capacity provider by default (only when launch_type=FARGATE)"
}

variable "subnets" {
  default     = null
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "network_mode" {
  default     = null
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "security_groups" {
  default     = null
  description = "The security groups associated with the task or service"
}

variable "without_capacity_provider" {
  default = false
  description = "Launch service without capacity provider"
}