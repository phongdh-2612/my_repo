variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "instance_security_group_name" {
  description = "Name of security group instance"
  type = string
  default = "security_group_instance"

}

variable "lb_security_group_name" {
    description = "Name of security group loadbalancer"
    type = string
    default = "security_group_lb"
}
