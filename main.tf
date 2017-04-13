resource "aws_alb_target_group" "default" {
  name                 = "${var.name}-${var.environment}"
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 60

  health_check {
    path = "${var.health_check}"
  }
}
