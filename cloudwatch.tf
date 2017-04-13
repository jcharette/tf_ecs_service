#create log group for default container
resource "aws_cloudwatch_log_group" "default" {
  name              = "${var.project}/app-${var.name}-${var.environment}"
  retention_in_days = 7
}

# create log groups for any other additional container services
resource "aws_cloudwatch_log_group" "listener" {
  retention_in_days = 7
  name              = "${var.project}/app-${var.name}-${var.environment}"
}
