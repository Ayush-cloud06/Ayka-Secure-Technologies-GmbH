package policies.terraform.aws_s3

deny[msg] if {
    r := input.resources[_]
    r.resource_type == "aws_s3_bucket"
    r.acl == "public-read"
    msg := sprintf("s3 bucket %s is public", [r.name])
}

deny[msg] if {
    r := input.resources[_]
    r.resource_type == "aws_s3_bucket"
    not r.encrypted
    msg := sprintf("s3 bucket %s is not encrypted", [r.name])
}


 # Test command : 

 # opa eval --input examples/bucket.json \
         # --data policies/terraform/aws_s3.rego \
         # "data.policies.terraform.aws_s3.deny"



            # "s3 bucket my-bucket is not encrypted": true,
            # "s3 bucket my-bucket is public": true
         