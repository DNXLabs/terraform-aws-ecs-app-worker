
resource "aws_ecs_service" "default" {
  name                   = var.name
  cluster                = var.cluster_name
  task_definition        = aws_ecs_task_definition.default[0].arn
  desired_count          = var.desired_count
  enable_execute_command = true

  deployment_maximum_percent         = try(var.deployment_maximum_percent, 100)
  deployment_minimum_healthy_percent = try(var.deployment_minimum_healthy_percent, 0)

  dynamic "placement_constraints" {
    for_each = var.launch_type == "FARGATE" ? [] : var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? [var.subnets] : []
    content {
      subnets         = var.subnets
      security_groups = var.security_groups == "" ? null : var.security_groups
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.launch_type == "FARGATE" ? [] : var.ordered_placement_strategy
    content {
      field = lookup(ordered_placement_strategy.value, "field", null)
      type  = ordered_placement_strategy.value.type
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = try(var.without_capacity_provider,false) ? [] : ["1"]
    content {
      capacity_provider = var.launch_type == "FARGATE" ? (var.fargate_spot ? "FARGATE_SPOT" : "FARGATE") : "${var.cluster_name}-capacity-provider"
      weight            = 1
      base              = 0
    }
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
