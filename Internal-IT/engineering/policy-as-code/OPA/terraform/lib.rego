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
