# default
resource "aws_ecs_service" "default" {
  name            = "${var.name}-${var.environment}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count   = "${var.ecs_desired_count}"
  iam_role        = "${aws_iam_role.ecs_service.name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    container_name   = "${var.name}"
    container_port   = "${var.port}"
  }

  depends_on = [
    "aws_iam_role_policy.ecs_service",
  ]
}

data "template_file" "default_task_definition" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {
    environment      = "${var.environment}"
    image_url        = "${var.image_url}"
    container_name   = "${var.name}"
    container_port   = "${var.port}"
    log_group_region = "${var.aws_region}"
    log_group_name   = "${aws_cloudwatch_log_group.default.name}"
    memory_reserved  = "${var.container_memory_reserved}"
    memory_max       = "${var.container_memory_max}"
  }
}

resource "aws_ecs_task_definition" "default" {
  family                = "${var.name}-${var.environment}"
  container_definitions = "${data.template_file.default_task_definition.rendered}"
}
