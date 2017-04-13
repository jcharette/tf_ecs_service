variable "environment" {
  description = "Name for Environment"
}

variable "aws_region" {
  description = "AWS region to build in"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID for this container"
  type        = "string"
}

variable "ecs_cluster_id" {
  description = "Cluster ID to join this service to"
  type        = "string"
}

variable "ecs_desired_count" {
  description = "ECS Desired count"
  default     = "2"
}

variable "lb_arn" {
  description = "ARN of load balancer to attach to"
}

variable "lb_port" {
  description = "Port to bind default listener to"
  default     = "80"
}

variable "lb_protocol" {
  description = "Protocol to bind to"
  default     = "HTTP"
}

variable "container_memory_max" {
  description = "Maximum amount of memory a container can utilize"
  default     = "512"
}

variable "container_memory_reserved" {
  description = "Amount of memory Docker will reserve for this container"
  default     = "128"
}

variable "name" {
  description = "Name of this service"
}

variable "port" {
  description = "Port this service is listening on"
  default =  "80"
}

variable "project" {
  description = "Project name, used for logging"
}

variable "image_url" {
  description = "URL to find docker image for this service"
}

variable "priority" {
  description = "Priority of this service on the ALB.  Default is 0 for root mapping"
  default = "0"
}

variable "mapping" {
  description = "ALB Mapping path for listener"
}

variable "health_check" {
  description = "Health Check for Container"
}

variable "default_listener_arn" {
  description = "ARN for default listener.  Used for mapping additional listeners"
  default = ""
}
