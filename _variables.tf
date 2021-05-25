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
  type        = list(string)
  default     = []
}

variable "placement_constraints" {
  # This variables may not be used with Fargate!
  description = "Rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
    type = list(object({
      type       = string
      expression = string
  }))
  default     = []
}