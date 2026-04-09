module "networking" {
  source = "./modules/networking"

  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
}

module "security" {
  source = "./modules/security"

  name_prefix = var.name_prefix
  vpc_id      = module.networking.vpc_id
  app_port    = var.app_port
  db_port     = var.db_port
}

module "storage" {
  source = "./modules/storage"

  name_prefix   = var.name_prefix
  bucket_suffix = var.bucket_suffix
  kms_key_arn   = aws_kms_key.workload.arn
}

module "database" {
  source = "./modules/database"

  name_prefix            = var.name_prefix
  db_name                = var.db_name
  db_username            = var.db_username
  db_port                = var.db_port
  db_instance_class      = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  subnet_ids             = module.networking.db_subnet_ids
  vpc_security_group_ids = [module.security.rds_security_group_id]
  kms_key_arn            = aws_kms_key.workload.arn
}

module "compute" {
  source = "./modules/compute"

  name_prefix                = var.name_prefix
  aws_region                 = var.aws_region
  vpc_id                     = module.networking.vpc_id
  public_subnet_ids          = module.networking.public_subnet_ids
  private_subnet_ids         = module.networking.private_subnet_ids
  alb_security_group_id      = module.security.alb_security_group_id
  ecs_security_group_id      = module.security.ecs_security_group_id
  ec2_security_group_id      = module.security.ec2_security_group_id
  ecs_execution_role_arn     = module.security.ecs_execution_role_arn
  ecs_task_role_arn          = module.security.ecs_task_role_arn
  ec2_instance_profile_name  = module.security.ec2_instance_profile_name
  ecs_container_image        = var.ecs_container_image
  app_port                   = var.app_port
  ecs_cpu                    = var.ecs_cpu
  ecs_memory                 = var.ecs_memory
  ecs_desired_count          = var.ecs_desired_count
  ecs_min_capacity           = var.ecs_min_capacity
  ecs_max_capacity           = var.ecs_max_capacity
  ecs_target_cpu_utilization = var.ecs_target_cpu_utilization
  ec2_ami_id                 = var.ec2_ami_id
  ec2_instance_type          = var.ec2_instance_type
  ec2_root_volume_size       = var.ec2_root_volume_size
  access_logs_bucket_name    = module.storage.access_logs_bucket_name
  kms_key_arn                = aws_kms_key.workload.arn
  environment                = var.environment
  owner                      = var.owner
  cost_center                = var.cost_center
}
