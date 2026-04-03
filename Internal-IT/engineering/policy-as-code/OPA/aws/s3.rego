package policies.aws.s3

deny[msg] {
    b := input.buckets[_]
    b.public == true

    msg := sprintf(
        "S3 bucket %s is publicy accessible",
        [b.name]
    )
}
