"""Asset inventory and IAM plan extract generator: what it lists and what it must never print."""
import copy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT = REPO_ROOT / "Internal-IT/engineering/ci-cd/scripts/generate-asset-inventory.py"
COMMIT = "b" * 40
AWS = "registry.terraform.io/hashicorp/aws"

# Values a public file must never carry. Each sits in an attribute the generator should ignore.
SENTINELS = [
    "SENTINEL-ROLE-NAME",
    "SENTINEL-TRUST-POLICY",
    "SENTINEL-ROLE-ARN",
    "SENTINEL-POLICY-DOCUMENT",
    "SENTINEL-DB-PASSWORD",
    "SENTINEL-COST-CENTER",
    "111122223333",
]


def resource(address, rtype, values=None, mode="managed", provider=AWS):
    return {
        "address": address,
        "mode": mode,
        "type": rtype,
        "name": address.rsplit(".", 1)[-1],
        "provider_name": provider,
        "values": values or {},
    }


def base_plan():
    """Root, one child module (iam) and one grandchild module (a.b), with IAM wiring both ways."""
    root = [
        resource("aws_s3_bucket.logs", "aws_s3_bucket", {
            "bucket": "logs",
            "tags": {"Environment": "tagsval", "CostCenter": "SENTINEL-COST-CENTER"},
            "tags_all": {"Environment": "allval", "Owner": "platform", "Name": "logs-123456789012"},
        }),
        resource("data.aws_iam_policy_document.trust", "aws_iam_policy_document",
                 {"json": "SENTINEL-POLICY-DOCUMENT"}, mode="data"),
        resource("aws_db_instance.main", "aws_db_instance",
                 {"password": "SENTINEL-DB-PASSWORD", "tags": {"Workload": "portal"}}),
        resource("aws_iam_role.app", "aws_iam_role", {
            "name": "SENTINEL-ROLE-NAME",
            "assume_role_policy": "SENTINEL-TRUST-POLICY",
            "arn": "arn:aws:iam::111122223333:role/SENTINEL-ROLE-ARN",
        }),
        resource("aws_iam_role_policy_attachment.app", "aws_iam_role_policy_attachment", {
            "role": "SENTINEL-ROLE-NAME",
            "policy_arn": "arn:aws:iam::aws:policy/ReadOnlyAccess",
        }),
        resource("aws_iam_role_policy_attachment.app_custom", "aws_iam_role_policy_attachment", {
            "role": "SENTINEL-ROLE-NAME",
            "policy_arn": "arn:aws:iam::111122223333:policy/team-boundary",
        }),
        resource("aws_identitystore_group.tier0", "aws_identitystore_group", {"display_name": "Tier0"}),
    ]
    iam_module = [
        # Role name and policy ARN are unknown at plan time: linking has to use the configuration.
        resource("module.iam.aws_iam_role.svc", "aws_iam_role", {"assume_role_policy": "SENTINEL-TRUST-POLICY"}),
        resource("module.iam.aws_iam_policy.custom", "aws_iam_policy",
                 {"name": "custom-policy", "policy": "SENTINEL-POLICY-DOCUMENT"}),
        resource("module.iam.aws_iam_role_policy_attachment.svc", "aws_iam_role_policy_attachment", {}),
        resource("module.iam.aws_iam_instance_profile.svc", "aws_iam_instance_profile", {}),
    ]
    nested = [resource("module.a.module.b.aws_sqs_queue.jobs", "aws_sqs_queue", {"tags_all": {"Project": "deep"}})]
    plan = {
        "format_version": "1.2",
        "terraform_version": "1.7.5",
        "timestamp": "2026-10-01T00:00:00Z",
        "planned_values": {"root_module": {
            "resources": root,
            "child_modules": [
                {"address": "module.iam", "resources": iam_module},
                {"address": "module.a", "resources": [], "child_modules": [
                    {"address": "module.a.module.b", "resources": nested},
                ]},
            ],
        }},
        "configuration": {"root_module": {"module_calls": {"iam": {"module": {"resources": [
            {"address": "aws_iam_role_policy_attachment.svc", "expressions": {
                "role": {"references": ["aws_iam_role.svc.name", "aws_iam_role.svc"]},
                "policy_arn": {"references": ["aws_iam_policy.custom.arn", "aws_iam_policy.custom"]},
            }},
            {"address": "aws_iam_instance_profile.svc", "expressions": {
                "role": {"references": ["aws_iam_role.svc.name", "aws_iam_role.svc"]},
            }},
        ]}}}}},
    }
    return with_changes(plan)


def with_changes(plan):
    def walk(module):
        yield from module.get("resources") or []
        for child in module.get("child_modules") or []:
            yield from walk(child)

    plan["resource_changes"] = [
        {"address": r["address"], "mode": r["mode"], "type": r["type"], "change": {"actions": ["create"]}}
        for r in walk(plan["planned_values"]["root_module"])
    ]
    return plan


class AssetInventoryTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.dir = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def run_generator(self, plan, commit=COMMIT, run_id="12345", extra=None):
        plan_path = self.dir / "tfplan.json"
        plan_path.write_text(json.dumps(plan), encoding="utf-8")
        self.inventory = self.dir / "out/inventory.md"
        self.iam = self.dir / "out/iam.md"
        cmd = [
            sys.executable, "-I", str(SCRIPT), str(plan_path),
            "--run-id", run_id, "--commit", commit,
            "--source-artifact", "compliance-evidence",
            "--workload", "Internal-IT/workloads/example",
            "--repository", "example/repo",
            "--generated-at", "2026-10-14T00:00:00+00:00",
            "--inventory-out", str(self.inventory), "--iam-out", str(self.iam),
        ] + (extra or [])
        return subprocess.run(cmd, capture_output=True, text=True, timeout=60)

    def generate(self, plan=None, **kwargs):
        result = self.run_generator(plan or base_plan(), **kwargs)
        self.assertEqual(result.returncode, 0, result.stderr)
        return self.inventory.read_text(encoding="utf-8"), self.iam.read_text(encoding="utf-8")

    def row(self, text, address):
        rows = [line for line in text.splitlines() if line.startswith(f"| `{address}` |")]
        self.assertEqual(len(rows), 1, f"expected one row for {address}")
        return rows[0]

    def test_no_attribute_values_leak(self):
        inventory, iam = self.generate()
        for sentinel in SENTINELS:
            self.assertNotIn(sentinel, inventory, sentinel)
            self.assertNotIn(sentinel, iam, sentinel)

    def test_every_managed_resource_listed_child_modules_included(self):
        inventory, _ = self.generate()
        row = self.row(inventory, "module.a.module.b.aws_sqs_queue.jobs")
        self.assertIn("`module.a.module.b`", row)
        self.assertIn("deep", row)
        self.assertIn("11 managed resources", inventory)

    def test_data_sources_are_not_assets(self):
        inventory, iam = self.generate()
        self.assertNotIn("data.aws_iam_policy_document.trust", inventory)
        self.assertNotIn("data.aws_iam_policy_document.trust", iam)

    def test_tags_all_wins_over_tags_and_unlisted_tags_are_dropped(self):
        inventory, _ = self.generate()
        row = self.row(inventory, "aws_s3_bucket.logs")
        self.assertIn("allval", row)
        self.assertNotIn("tagsval", row)
        self.assertIn("platform", row)
        self.assertIn("portal", self.row(inventory, "aws_db_instance.main"))

    def test_account_id_in_tag_is_redacted(self):
        inventory, _ = self.generate()
        self.assertIn("logs-[account-id]", self.row(inventory, "aws_s3_bucket.logs"))
        self.assertNotIn("123456789012", inventory)

    def test_terraform_sensitive_tags_never_leave_plan(self):
        plan = base_plan()
        bucket = plan["planned_values"]["root_module"]["resources"][0]
        bucket["values"]["tags_all"]["Owner"] = "unrecognizable-secret-value"
        bucket["sensitive_values"] = {"tags_all": {"Owner": True}}
        inventory, iam = self.generate(plan)
        self.assertNotIn("unrecognizable-secret-value", inventory + iam)
        self.assertIn("[sensitive]", inventory)

    def test_long_addresses_remain_complete(self):
        plan = base_plan()
        address = "aws_s3_bucket." + "x" * 100
        plan["planned_values"]["root_module"]["resources"][0]["address"] = address
        inventory, _ = self.generate(with_changes(plan))
        self.row(inventory, address)

    def test_equal_counts_with_different_addresses_fail(self):
        plan = base_plan()
        plan["resource_changes"][0]["address"] = "aws_s3_bucket.different"
        result = self.run_generator(plan)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.inventory.exists())

    def test_ambiguous_instance_reference_does_not_invent_role_attachments(self):
        plan = base_plan()
        resources = plan["planned_values"]["root_module"]["child_modules"][0]["resources"]
        role = resources[0]
        role["address"] += '["one"]'
        other = copy.deepcopy(role)
        other["address"] = other["address"].replace('"one"', '"two"')
        resources.append(other)
        _, iam = self.generate(with_changes(plan))
        self.assertIn("Attachments not linked to a role: 1.", iam)
        self.assertIn("none resolved in this plan", self.row(iam.split("## 5.")[0], role["address"]))

    def test_sensitive_role_names_are_not_join_keys(self):
        plan = base_plan()
        resources = plan["planned_values"]["root_module"]["resources"]
        resources[3]["sensitive_values"] = {"name": True}
        resources[4]["sensitive_values"] = {"role": True}
        resources[4]["values"]["role"] = "different-sensitive-role"
        _, iam = self.generate(plan)
        role = self.row(iam.split("## 5.")[0], "aws_iam_role.app")
        self.assertNotIn("ReadOnlyAccess", role)
        self.assertIn("none resolved in this plan", role)

    def test_duplicate_role_names_do_not_create_false_attachments(self):
        plan = base_plan()
        resources = plan["planned_values"]["root_module"]["resources"]
        duplicate = copy.deepcopy(resources[3])
        duplicate["address"] = "aws_iam_role.other_account"
        resources.append(duplicate)
        _, iam = self.generate(with_changes(plan))
        roles = iam.split("## 5.")[0]
        for address in ("aws_iam_role.app", "aws_iam_role.other_account"):
            self.assertNotIn("ReadOnlyAccess", self.row(roles, address))

    def test_role_policies_linked_by_role_name(self):
        _, iam = self.generate()
        row = self.row(iam.split("## 5.")[0], "aws_iam_role.app")
        self.assertIn("ReadOnlyAccess", row)
        self.assertIn("team-boundary", row)

    def test_role_policies_linked_through_configuration_when_unknown(self):
        _, iam = self.generate()
        roles = iam.split("## 5.")[0]
        self.assertIn("custom-policy", self.row(roles, "module.iam.aws_iam_role.svc"))
        profile = self.row(iam, "module.iam.aws_iam_instance_profile.svc")
        self.assertIn("module.iam.aws_iam_role.svc", profile)
        self.assertIn("Attachments not linked to a role: 0.", iam)

    def test_identity_center_resources_counted_in_iam_extract(self):
        _, iam = self.generate()
        self.assertIn("in this plan: 1.", iam)
        self.row(iam, "aws_identitystore_group.tier0")

    def test_provenance_records_sha256_of_input(self):
        plan = base_plan()
        inventory, iam = self.generate(plan)
        digest = hashlib.sha256((self.dir / "tfplan.json").read_bytes()).hexdigest()
        for text in (inventory, iam):
            self.assertIn(f"| Plan file SHA-256 | `{digest}` |", text)
            self.assertIn(f"`{COMMIT}`", text)
            self.assertIn("https://github.com/example/repo/actions/runs/12345", text)
            self.assertIn("Do not edit by hand", text)

    def test_twelve_digits_in_provenance_are_not_mistaken_for_an_account_id(self):
        commit = "a" * 28 + "123456789012"
        inventory, _ = self.generate(commit=commit, run_id="100000000000")
        self.assertIn(commit, inventory)

    def test_resource_count_mismatch_fails(self):
        plan = base_plan()
        plan["resource_changes"].append(
            {"address": "aws_s3_bucket.ghost", "mode": "managed", "type": "aws_s3_bucket",
             "change": {"actions": ["create"]}})
        result = self.run_generator(plan)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.inventory.exists())

    def test_plan_without_managed_resources_fails(self):
        plan = with_changes({"planned_values": {"root_module": {"resources": []}}})
        result = self.run_generator(plan)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("no managed resources", result.stderr)

    def test_invalid_provenance_flag_fails(self):
        result = self.run_generator(base_plan(), commit="not-a-sha")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.inventory.exists())

    def test_access_key_shaped_value_is_redacted(self):
        plan = copy.deepcopy(base_plan())
        plan["terraform_version"] = "AKIAABCDEFGHIJKLMNOP"
        inventory, _ = self.generate(plan)
        self.assertNotIn("AKIAABCDEFGHIJKLMNOP", inventory)
        self.assertIn("[access-key]", inventory)


if __name__ == "__main__":
    unittest.main()
