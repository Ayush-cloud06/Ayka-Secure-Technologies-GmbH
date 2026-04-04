variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "name_prefix" {
  type    = string
  default = "ayka-portal-dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.42.0.0/24", "10.42.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.42.10.0/24", "10.42.11.0/24"]
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["10.42.20.0/24", "10.42.21.0/24"]
}

variable "bucket_suffix" {
  type    = string
  default = "artifacts"
}

variable "ecs_container_image" {
  type    = string
  default = "nginx:stable"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "ecs_cpu" {
  type    = number
  default = 256
}

variable "ecs_memory" {
  type    = number
  default = 512
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}

variable "ecs_min_capacity" {
  type    = number
  default = 1
}

variable "ecs_max_capacity" {
  type    = number
  default = 2
}

variable "ecs_target_cpu_utilization" {
  type    = number
  default = 70
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_ami_id" {
  type    = string
  default = "ami-1234567890abcdef0"
}

variable "ec2_root_volume_size" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "aykaportal"
}

variable "db_username" {
  type    = string
  default = "portal_admin"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_max_allocated_storage" {
  type    = number
  default = 100
}
