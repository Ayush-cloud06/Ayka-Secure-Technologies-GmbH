output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "ec2_instance_id" {
  value = aws_instance.ops.id
}
