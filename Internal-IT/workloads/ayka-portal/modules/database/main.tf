resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "${var.name_prefix}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    engine   = "postgres"
    dbname   = var.db_name
    port     = var.db_port
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier                 = "${var.name_prefix}-postgres"
  engine                     = "postgres"
  engine_version             = "17.2"
  instance_class             = var.db_instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  storage_encrypted          = true
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = random_password.db.result
  port                       = var.db_port
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = var.vpc_security_group_ids
  backup_retention_period    = 7
  deletion_protection        = false
  skip_final_snapshot        = true
  publicly_accessible        = false
  multi_az                   = false
  auto_minor_version_upgrade = true

  depends_on = [aws_secretsmanager_secret_version.db]
}
