provider "aws" {
    region = "us-east-1"
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "phongdh-bucket-1"
    key = "Chapter-3/stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}

data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.address
    db_port = data.terraform_remote_state.db.outputs.port
  }
} 


## Create ASG

resource "aws_launch_configuration" "terraform_launch_configuration" {
    image_id = "ami-0dc2d3e4c0f9ebd18"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]
    key_name = "phongdh_sun"
    user_data = data.template_file.user_data.rendered

    lifecycle {
      create_before_destroy = true
    }

}

resource "aws_autoscaling_group" "terraform_ASG" {
    launch_configuration = aws_launch_configuration.terraform_launch_configuration.name
    vpc_zone_identifier = data.aws_subnet_ids.terraform_subnet.ids
    
    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 5

    tag {
      key = "Name"
      value = "terraform-asg"
      propagate_at_launch = true
    }
}
## Get data VPC default
data "aws_vpc" "terraform_vpc" {
    default = true
}

## Get data subnet of VPC default
data "aws_subnet_ids" "terraform_subnet" {
    vpc_id = data.aws_vpc.terraform_vpc.id
  
}





resource "aws_security_group" "instance" {
  name = var.instance_security_group_name


    ingress {
      from_port   = var.server_port
      to_port     = var.server_port
      protocol    = "tcp"
      #use source security group of loadbalancer instead of cidr_blocks
      security_groups = [aws_security_group.sg_alb.id] 
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}


## Create LB

resource "aws_lb" "terraform_lb" {
    name = "terraform-ALB"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.terraform_subnet.ids
    security_groups = [aws_security_group.sg_alb.id]
}

resource "aws_security_group" "sg_alb" {
    name = var.lb_security_group_name

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.terraform_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "fixed-response"

        fixed_response {
          content_type = "text/plain"
          message_body = "404: page not found"
          status_code = 404
      }
    }
}



resource "aws_lb_target_group" "asg" {
    name = "terraform-target-group"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.terraform_vpc.id
    
    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
  
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
          values = ["*"]
        }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
}

