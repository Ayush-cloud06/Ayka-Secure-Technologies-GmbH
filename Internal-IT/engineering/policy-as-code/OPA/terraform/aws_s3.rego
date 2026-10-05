package policies.terraform.aws_s3

import data.policies.terraform.lib
import future.keywords.in

public_acls := {"public-read", "public-read-write", "authenticated-read"}

# Buckets must not be publicly readable through an ACL bound to that bucket.
deny[msg] {
    bucket := lib.resources_of_type("aws_s3_bucket")[_]
    acl := lib.resources_of_type("aws_s3_bucket_acl")[_]
    lib.related(acl, "bucket", bucket)
    acl.values.acl in public_acls

    msg := sprintf("[S3_PUBLIC_ACCESS] S3 bucket %s is public", [bucket.address])
}

# Legacy inline acl argument on the bucket itself.
deny[msg] {
    bucket := lib.resources_of_type("aws_s3_bucket")[_]
    object.get(bucket.values, "acl", "") in public_acls

    msg := sprintf("[S3_PUBLIC_ACCESS] S3 bucket %s is public", [bucket.address])
}

# Every bucket must have its own server-side encryption configuration.
deny[msg] {
    bucket := lib.resources_of_type("aws_s3_bucket")[_]
    not has_encryption(bucket)

    msg := sprintf("[S3_ENCRYPTION_MISSING] S3 bucket %s is not encrypted", [bucket.address])
}

has_encryption(bucket) {
    encryption := lib.resources_of_type("aws_s3_bucket_server_side_encryption_configuration")[_]
    lib.related(encryption, "bucket", bucket)
}

# Legacy inline server_side_encryption_configuration block on the bucket.
has_encryption(bucket) {
    count(object.get(bucket.values, "server_side_encryption_configuration", [])) > 0
}
