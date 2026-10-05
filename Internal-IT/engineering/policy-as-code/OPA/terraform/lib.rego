package policies.terraform.lib

import future.keywords.in

# Shared plan traversal for every policy package.
# Syntax stays v0-compatible: conftest v0.45.0 bundles OPA 0.56.0 (ADR-0015).

# Every module in planned_values, keyed by its address ("" for the root module).
# walk() reaches nested modules (module.a.module.b) as well as the root.
modules[addr] = node {
	walk(input.planned_values.root_module, [path, node])
	is_module_path(path)
	addr := module_address(path, node)
}

module_address(path, node) = node.address

module_address(path, node) = "" {
	count(path) == 0
	not node.address
}

# Hand-written test plans may omit child module addresses; fall back to the walk path.
module_address(path, node) = sprintf("%v", [path]) {
	count(path) > 0
	not node.address
}

is_module_path(path) {
	count(path) == 0
}

is_module_path(path) {
	n := count(path)
	n >= 2
	path[n - 2] == "child_modules"
}

# Every planned resource, from the root module and all nested modules.
resources[r] {
	r := modules[_].resources[_]
}

resources_of_type(t) = {r | r := resources[_]; r.type == t}

# Address of the module instance that holds a resource ("" for root).
module_of(r) = addr {
	some addr
	r in modules[addr].resources
}

# ---------------------------------------------------------------------------
# Relationships between resources.
#
# Attributes that point at another resource (bucket = aws_s3_bucket.x.id) are
# usually unknown at plan time, so planned_values holds null there. The link
# survives in input.configuration as an expression reference, scoped to the
# module that declares it. related(child, attr, parent) is true when child's
# attr refers to parent, either by reference in the same module instance or
# by an equal known value.
# ---------------------------------------------------------------------------

related(child, attr, parent) {
	module_of(child) == module_of(parent)
	ref := references(child, attr)[_]
	refers_to(ref, local_address(parent))
}

related(child, attr, parent) {
	value := child.values[attr]
	is_string(value)
	value != ""
	value in {object.get(parent.values, "id", null), object.get(parent.values, "bucket", null)}
}

local_address(r) = sprintf("%s.%s", [r.type, r.name])

refers_to(ref, target) {
	ref == target
}

refers_to(ref, target) {
	startswith(ref, concat("", [target, "."]))
}

refers_to(ref, target) {
	startswith(ref, concat("", [target, "["]))
}

references(r, attr) = refs {
	config := config_resource(r)
	refs := object.get(config, ["expressions", attr, "references"], [])
}

config_resource(r) = config {
	config := config_module(module_of(r)).resources[_]
	config.address == local_address(r)
}

# module.a[0].module.b["x"] -> configuration path module_calls.a.module.module_calls.b.module
config_module(addr) = object.get(input.configuration.root_module, config_path(addr), {})

config_path(addr) = [] {
	addr == ""
}

config_path(addr) = path {
	addr != ""
	parts := split(regex.replace(addr, `\[[^\]]*\]`, ""), ".")
	path := [segment |
		some i, j
		parts[i] == "module"
		segment := ["module_calls", parts[i + 1], "module"][j]
	]
}
