
resource "aws_ecs_service" "default" {
  name            = var.name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = var.desired_count

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      field = lookup(ordered_placement_strategy.value, "field", null)
      type  = ordered_placement_strategy.value.type
    }
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
  tags = merge(
    var.tags,
    {
      "terraform" = "true"
    },
  )

}
