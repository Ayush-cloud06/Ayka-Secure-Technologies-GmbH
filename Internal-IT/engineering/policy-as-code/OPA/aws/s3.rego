package policies.aws.s3

import future.keywords.if

deny[msg] if {
    b := input.buckets[_]
    b.public == true

    msg := sprintf(
        "S3 bucket %s is publicy accessible",
        [b.name]
    )
}
