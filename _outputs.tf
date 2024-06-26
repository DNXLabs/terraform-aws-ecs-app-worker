output "aws_cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.default.arn
}

output "aws_cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.default.name
}

output "autoscaling" {
  value = {
    resource_id        = aws_appautoscaling_target.ecs[0].resource_id
    scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
    service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace
  }
}