

#default listener for ALB
# all additional listener rules attach to this listener
resource "aws_alb_listener" "default" {
 count             = "${var.mapping == "/" ?  1 : 0}"
 load_balancer_arn = "${var.lb_arn}"
 port              = "${var.lb_port}"
 protocol          = "${var.lb_protocol}"

 default_action {
   target_group_arn = "${aws_alb_target_group.default.arn}"
   type             = "forward"
 }
}

#listener rules for all containers
resource "aws_alb_listener_rule" "listener" {
 count        = "${var.mapping == "/" ?  0 : 1}"
 listener_arn = "${var.default_listener_arn}"
 priority     = "${var.priority}"

 action = {
   type             = "forward"
   target_group_arn = "${aws_alb_target_group.default.arn}"
 }

 condition {
   field  = "path-pattern"
   values = ["${var.mapping}"]
 }
}
