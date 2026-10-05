package policies.terraform.aws_s3_test

import data.policies.terraform.aws_s3

# Shapes follow a terraform 1.7.5 plan: sub-resources reference the bucket by
# aws_s3_bucket.<name>.id, which is unknown (null) in planned_values, so the
# link only exists in configuration.

bucket(name) = {
	"address": sprintf("module.store.aws_s3_bucket.%s", [name]),
	"type": "aws_s3_bucket", "name": name,
	"values": {"bucket": sprintf("%s-bucket", [name])},
}

child(type, name, target, values) = {
	"address": sprintf("module.store.%s.%s", [type, name]),
	"type": type, "name": name,
	"values": object.union({"bucket": null}, values),
}

config(type, name, target) = {
	"address": sprintf("%s.%s", [type, name]),
	"type": type, "name": name,
	"expressions": {"bucket": {"references": [sprintf("aws_s3_bucket.%s.id", [target]), sprintf("aws_s3_bucket.%s", [target])]}},
}

plan(planned, configured) = {
	"planned_values": {"root_module": {"child_modules": [{"address": "module.store", "resources": planned}]}},
	"configuration": {"root_module": {"module_calls": {"store": {"module": {"resources": configured}}}}},
}

enc := "aws_s3_bucket_server_side_encryption_configuration"

two_buckets_one_encrypted := plan(
	[bucket("a"), bucket("b"), child(enc, "a", "a", {})],
	[config(enc, "a", "a")],
)

two_buckets_one_public := plan(
	[bucket("a"), bucket("b"), child("aws_s3_bucket_acl", "pub", "b", {"acl": "public-read"}), child(enc, "a", "a", {}), child(enc, "b", "b", {})],
	[config("aws_s3_bucket_acl", "pub", "b"), config(enc, "a", "a"), config(enc, "b", "b")],
)

denied(input_plan, prefix) = {msg | aws_s3.deny[msg] with input as input_plan; startswith(msg, prefix)}

test_encryption_is_bound_to_its_own_bucket {
	denied(two_buckets_one_encrypted, "[S3_ENCRYPTION_MISSING]") == {"[S3_ENCRYPTION_MISSING] S3 bucket module.store.aws_s3_bucket.b is not encrypted"}
}

test_public_acl_flags_only_its_own_bucket {
	denied(two_buckets_one_public, "[S3_PUBLIC_ACCESS]") == {"[S3_PUBLIC_ACCESS] S3 bucket module.store.aws_s3_bucket.b is public"}
}

test_fully_configured_buckets_pass {
	ok := plan(
		[bucket("a"), child(enc, "a", "a", {}), child("aws_s3_bucket_acl", "priv", "a", {"acl": "private"})],
		[config(enc, "a", "a"), config("aws_s3_bucket_acl", "priv", "a")],
	)
	count(aws_s3.deny) == 0 with input as ok
}

# Same local names in two module instances must not satisfy each other.
test_reference_is_scoped_to_module_instance {
	p := {
		"planned_values": {"root_module": {"child_modules": [
			{"address": "module.store[0]", "resources": [object.union(bucket("a"), {"address": "module.store[0].aws_s3_bucket.a"}), object.union(child(enc, "a", "a", {}), {"address": "module.store[0].aws_s3_bucket_server_side_encryption_configuration.a"})]},
			{"address": "module.other", "resources": [object.union(bucket("a"), {"address": "module.other.aws_s3_bucket.a"})]},
		]}},
		"configuration": {"root_module": {"module_calls": {
			"store": {"module": {"resources": [config(enc, "a", "a")]}},
			"other": {"module": {"resources": []}},
		}}},
	}
	denied(p, "[S3_ENCRYPTION_MISSING]") == {"[S3_ENCRYPTION_MISSING] S3 bucket module.other.aws_s3_bucket.a is not encrypted"}
}

# A known literal bucket name binds without configuration references.
test_literal_bucket_name_binds {
	p := {"planned_values": {"root_module": {"resources": [
		{"address": "aws_s3_bucket.a", "type": "aws_s3_bucket", "name": "a", "values": {"bucket": "a-bucket"}},
		{"address": "aws_s3_bucket_acl.x", "type": "aws_s3_bucket_acl", "name": "x", "values": {"bucket": "a-bucket", "acl": "public-read-write"}},
	]}}}
	count(denied(p, "[S3_PUBLIC_ACCESS]")) == 1
}

# Reference binding in the root module (empty configuration path) and in a
# nested module (module.a.module.b), with no literal bucket name to fall back on.
bare_bucket(prefix) = {"address": sprintf("%saws_s3_bucket.a", [prefix]), "type": "aws_s3_bucket", "name": "a", "values": {"bucket": null}}

bare_enc(prefix) = {"address": sprintf("%s%s.a", [prefix, enc]), "type": enc, "name": "a", "values": {"bucket": null}}

root_plan(planned, configured) = {
	"planned_values": {"root_module": {"resources": planned}},
	"configuration": {"root_module": {"resources": configured}},
}

nested_plan(planned, configured) = {
	"planned_values": {"root_module": {"child_modules": [{"address": "module.a", "resources": [], "child_modules": [{"address": "module.a.module.b", "resources": planned}]}]}},
	"configuration": {"root_module": {"module_calls": {"a": {"module": {"module_calls": {"b": {"module": {"resources": configured}}}}}}}},
}

test_root_module_reference_binds {
	count(denied(root_plan([bare_bucket(""), bare_enc("")], [config(enc, "a", "a")]), "[S3_ENCRYPTION_MISSING]")) == 0
}

test_root_module_without_encryption_is_denied {
	count(denied(root_plan([bare_bucket("")], []), "[S3_ENCRYPTION_MISSING]")) == 1
}

test_nested_module_reference_binds {
	p := "module.a.module.b."
	count(denied(nested_plan([bare_bucket(p), bare_enc(p)], [config(enc, "a", "a")]), "[S3_ENCRYPTION_MISSING]")) == 0
}

test_nested_module_without_encryption_is_denied {
	p := "module.a.module.b."
	count(denied(nested_plan([bare_bucket(p)], []), "[S3_ENCRYPTION_MISSING]")) == 1
}
