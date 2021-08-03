variable "bucket_name" {
    description = "The name of the s3 bucket"
    type = string
    default = "phongdh-bucket-1"
}


variable "table_name" {
    description = "The name of the s3 bucket"
    type = string
    default = "terraform_locks"
}