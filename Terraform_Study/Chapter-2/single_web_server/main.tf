provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "local" {
    path = "."
  }
}

#terraform {
#  backend "s3" {
#    bucket = "phongdh-bucket-1"
#    key = "Chapter-2/single-web/terraform.tfstate"
#    region = "us-east-1"
#
#    dynamodb_table = "terraform_locks"
#    encrypt = true
#  }
#}


resource "aws_instance" "instance_terraform" {
  ami = "ami-0dc2d3e4c0f9ebd18"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG_instance_terraform.id]
  key_name = "phongdh_sun"

  user_data = <<-EOF
              #!/bin/bash
              # Use this for your user data 
              # install httpd

              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              echo "${var.ingress_port_http}" > test.txt
              EOF

  tags = {
    "Name" = "terraform-example"
  }
}


resource "aws_security_group" "SG_instance_terraform" {
  name = "terraform_sg_test"

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = var.ingress_port_ssh
    protocol = "tcp"
    to_port = var.ingress_port_ssh
    description = "Allow ssh traffic"
    }
    
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = var.ingress_port_http
    protocol = "tcp"
    to_port = var.ingress_port_http
    description = "Allow web traffic"
    }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ingress_port_ssh" {
  description = "Inbound port ssh will be open"
  type = number
  default = 22
}

variable "ingress_port_http" {
  description = "Inbound port http will be open"
  type = number
  default = 80
}

output "public_ip" {
  value = aws_instance.instance_terraform.public_ip
  description = "Public IP of instance"
}

