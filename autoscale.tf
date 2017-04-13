resource "aws_appautoscaling_target" "default" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.environment}/${var.name}-${var.environment}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "arn:aws:iam::468675206134:role/ecsAutoscaleRole"
  min_capacity       = 1
  max_capacity       = 10

  depends_on = ["aws_ecs_service.default"]
}

resource "aws_appautoscaling_policy" "default-up" {
  name                    = "${var.name}-${var.environment}-scale-up"
  service_namespace       = "ecs"
  resource_id             = "service/${var.environment}/${var.name}-${var.environment}"
  scalable_dimension      = "ecs:service:DesiredCount"
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }

  depends_on = ["aws_appautoscaling_target.default"]
}

resource "aws_appautoscaling_policy" "default-down" {
  name               = "${var.name}-${var.environment}-scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.environment}/${var.name}-${var.environment}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = -1
  }

  depends_on = ["aws_appautoscaling_target.default"]
}

resource "aws_cloudwatch_metric_alarm" "default_service_cpu_high" {
  alarm_name          = "${var.name}-${var.environment}-cpuutilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"

  dimensions {
    ClusterName = "${var.environment}"
    ServiceName = "${var.name}-${var.environment}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.default-up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "default_service_cpu_low" {
  alarm_name          = "${var.name}-${var.environment}-cpuutilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "20"

  dimensions {
    ClusterName = "${var.environment}"
    ServiceName = "${var.name}-${var.environment}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.default-down.arn}"]
}
