provider aws {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket = "phongdh-bucket-1"
    key = "Chapter-3/stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform_locks"
    encrypt = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-mysql"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"

  username = "admin"
  name = var.db_name
  skip_final_snapshot = true

  password = var.db_password
}
