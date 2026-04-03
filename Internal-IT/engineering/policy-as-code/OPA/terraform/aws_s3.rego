package policies.terraform.aws_s3

# Buckets must not be publicly readable through ACL resources.
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    bucket := module.resources[_]
    bucket.type == "aws_s3_bucket"

    acl := module.resources[_]
    acl.type == "aws_s3_bucket_acl"
    acl.values.acl == "public-read"

    msg := sprintf("[S3_PUBLIC_ACCESS] S3 bucket %s is public", [bucket.address])
}

# Buckets must define server-side encryption configuration.
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    bucket := module.resources[_]
    bucket.type == "aws_s3_bucket"

    not module_has_s3_encryption(module)

    msg := sprintf("[S3_ENCRYPTION_MISSING] S3 bucket %s is not encrypted", [bucket.address])
}

module_has_s3_encryption(module) {
    encryption := module.resources[_]
    encryption.type == "aws_s3_bucket_server_side_encryption_configuration"
}
