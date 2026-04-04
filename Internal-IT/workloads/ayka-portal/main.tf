module "compute" {
  source = "./modules/compute"

  name_prefix                = var.name_prefix
  aws_region                 = var.aws_region
  vpc_id                     = var.vpc_id
  public_subnet_ids          = var.public_subnet_ids
  private_subnet_ids         = var.private_subnet_ids
  alb_security_group_id      = var.alb_security_group_id
  ecs_security_group_id      = var.ecs_security_group_id
  ec2_security_group_id      = var.ec2_security_group_id
  ecs_execution_role_arn     = var.ecs_execution_role_arn
  ecs_task_role_arn          = var.ecs_task_role_arn
  ec2_instance_profile_name  = var.ec2_instance_profile_name
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
}
