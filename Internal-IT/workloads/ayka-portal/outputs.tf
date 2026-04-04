output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "ecs_cluster_arn" {
  value = module.compute.ecs_cluster_arn
}

output "ecs_service_name" {
  value = module.compute.ecs_service_name
}

output "ec2_instance_id" {
  value = module.compute.ec2_instance_id
}

output "s3_bucket_name" {
  value = module.storage.bucket_name
}

output "database_endpoint" {
  value = module.database.db_endpoint
}

output "database_secret_arn" {
  value     = module.database.db_secret_arn
  sensitive = true
}
