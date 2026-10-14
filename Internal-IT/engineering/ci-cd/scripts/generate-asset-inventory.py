#!/usr/bin/env python3
"""Generate the ISMS asset inventory and IAM plan extract from a Terraform plan JSON.

Input is `terraform show -json` output, e.g. output/tfplan.json from a run's
compliance-evidence artifact. Output is Markdown for Governance/ISMS (A.5.9,
A.5.15, A.8.2): one inventory of every managed resource and one IAM extract.

The repository is public and a plan holds account IDs, ARNs, policy documents
and generated secrets. So the only values written are: resource addresses,
types, module paths, provider names, an allowlist of tags, and for IAM roles
the names of attached managed policies. Anything that still looks like an
account ID or a key is redacted, and the output is checked again before it is
written.

Usage:
  generate-asset-inventory.py PLAN_JSON --run-id ID --commit SHA \
      --source-artifact NAME --workload DIR \
      [--artifact-path PATH] [--repository OWNER/REPO] [--generated-at ISO8601] \
      [--inventory-out FILE] [--iam-out FILE]
"""
import argparse
from collections import Counter
import copy
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import sys

GENERATOR = "Internal-IT/engineering/ci-cd/scripts/generate-asset-inventory.py"
SELECTED_TAGS = ["Name", "Environment", "Owner", "Workload", "Project", "DataClassification"]
IAM_PREFIXES = ("aws_iam_", "aws_ssoadmin_", "aws_identitystore_")
IDENTITY_CENTER_PREFIXES = ("aws_ssoadmin_", "aws_identitystore_")
INVENTORY_DOC_ID = "ISMS-02-01"
IAM_DOC_ID = "ISMS-07-05"

ACCOUNT_ID = re.compile(r"(?<!\d)\d{12}(?!\d)")
ACCESS_KEY = re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b")
PEM = re.compile(r"-----BEGIN [A-Z ]+-----")
POLICY_NAME = re.compile(r"^[A-Za-z0-9+=,.@_-]{1,128}$")
FLAG_PATTERNS = {
    "run_id": re.compile(r"^\d{1,20}$"),
    "commit": re.compile(r"^[0-9a-f]{7,40}$"),
    "source_artifact": re.compile(r"^[A-Za-z0-9._-]{1,100}$"),
    "artifact_path": re.compile(r"^[A-Za-z0-9._/-]{1,200}$"),
    "workload": re.compile(r"^[A-Za-z0-9._/-]{1,200}$"),
    "repository": re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$"),
}


def fail(reason):
    print(f"generate-asset-inventory: {reason}", file=sys.stderr)
    sys.exit(1)


def sha256_file(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load_plan(path):
    try:
        plan = json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        fail(f"cannot read plan JSON {path}: {exc}")
    if not isinstance(plan, dict):
        fail("plan JSON is not an object")
    root = (plan.get("planned_values") or {}).get("root_module")
    if not isinstance(root, dict):
        fail("plan JSON has no planned_values.root_module (is this `terraform show -json` of a plan?)")
    return plan


def walk(module, module_address="(root)"):
    """Yield (module address, resource) for a module and every child module."""
    for resource in module.get("resources") or []:
        yield module_address, resource
    for child in module.get("child_modules") or []:
        yield from walk(child, child.get("address") or "(unknown module)")


def managed_resources(plan):
    rows = [
        {"module": module, "resource": r}
        for module, r in walk(plan["planned_values"]["root_module"])
        if r.get("mode") == "managed"
    ]
    if not rows:
        fail("plan has no managed resources; an empty inventory is not evidence")
    return sorted(rows, key=lambda row: row["resource"].get("address", ""))


def redact_sensitive(value, mask):
    """Honor Terraform's sensitivity metadata before selecting printable attributes."""
    if mask is True:
        return "[sensitive]"
    if isinstance(value, dict):
        masks = mask if isinstance(mask, dict) else {}
        return {key: redact_sensitive(item, masks.get(key)) for key, item in value.items()}
    if isinstance(value, list):
        masks = mask if isinstance(mask, list) else []
        return [redact_sensitive(item, masks[i] if i < len(masks) else None)
                for i, item in enumerate(value)]
    return value


def public_plan(plan):
    plan = copy.deepcopy(plan)
    for _, resource in walk(plan["planned_values"]["root_module"]):
        values = redact_sensitive(resource.get("values") or {}, resource.get("sensitive_values"))
        resource["values"] = values if isinstance(values, dict) else {}
    return plan


def planned_change_count(plan):
    """Managed resources the plan keeps (everything except pure deletes)."""
    return sum(
        1 for rc in plan.get("resource_changes") or []
        if rc.get("mode") == "managed" and (rc.get("change") or {}).get("actions") != ["delete"]
    )


def redact(text):
    text = ACCOUNT_ID.sub("[account-id]", text)
    text = ACCESS_KEY.sub("[access-key]", text)
    return PEM.sub("[pem]", text)


def cell(value):
    """A plan-derived string made safe for one Markdown table cell."""
    if value is None or value == "" or value == []:
        return "—"
    text = redact(" ".join(str(value).split()))
    # Addresses must remain complete: truncation can make distinct resources indistinguishable.
    return (text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace("`", "&#96;").replace("|", "&#124;"))


def provider_short(name):
    return (name or "").replace("registry.terraform.io/", "") or None


def tags_of(resource):
    """tags_all (provider default_tags included) wins over tags; either may be unknown at plan time."""
    values = resource.get("values") or {}
    if not isinstance(values, dict):
        return {}
    tags = {}
    for key in ("tags", "tags_all"):
        if isinstance(values.get(key), dict):
            tags.update(values[key])
    return tags


def policy_name_from_arn(arn):
    if not isinstance(arn, str) or ":policy/" not in arn:
        return None
    name = arn.rsplit("/", 1)[-1]
    return name if POLICY_NAME.match(name) else "[unparsed policy ARN]"


def module_names(module_address):
    """module.a[0].module.b["x"] -> ["a", "b"] (configuration has no instance keys)."""
    if module_address in ("(root)", None):
        return []
    return re.findall(r"module\.([A-Za-z0-9_-]+)", module_address)


def config_resource(plan, module_address, resource):
    module = (plan.get("configuration") or {}).get("root_module") or {}
    for name in module_names(module_address):
        module = ((module.get("module_calls") or {}).get(name) or {}).get("module") or {}
    local = f"{resource.get('type')}.{resource.get('name')}"
    for candidate in module.get("resources") or []:
        if candidate.get("address") == local:
            return candidate
    return None


def referenced(plan, row, attribute, wanted_type, known):
    """Planned addresses of `wanted_type` that `attribute` refers to in the configuration."""
    cfg = config_resource(plan, row["module"], row["resource"])
    refs = (((cfg or {}).get("expressions") or {}).get(attribute) or {}).get("references") or []
    prefix = "" if row["module"] == "(root)" else row["module"] + "."
    found = []
    for ref in refs:
        parts = ref.split(".")
        if len(parts) >= 2 and parts[0] == wanted_type:
            target = prefix + parts[0] + "." + re.sub(r"\[.*$", "", parts[1])
            candidates = [a for a in known if a == target or a.startswith(target + "[")]
            # Configuration references may omit an instance key. Do not invent an
            # attachment to every count/for_each instance when the value is unknown.
            if len(candidates) != 1:
                continue
            if candidates[0] not in found:
                found.append(candidates[0])
    return found


class IamIndex:
    """Links attachments and instance profiles to roles. Only addresses and policy names leave it."""

    def __init__(self, plan, rows):
        self.plan = plan
        self.rows = [row for row in rows if row["resource"].get("type", "").startswith(IAM_PREFIXES)]
        by_type = lambda t: {row["resource"]["address"]: row for row in self.rows if row["resource"]["type"] == t}
        self.roles = by_type("aws_iam_role")
        self.policies = by_type("aws_iam_policy")
        self.role_by_name = {}
        for address, row in self.roles.items():
            name = (row["resource"].get("values") or {}).get("name")
            if isinstance(name, str) and name != "[sensitive]":
                self.role_by_name.setdefault(name, []).append(address)
        self.role_policies = {address: [] for address in self.roles}
        self.links = {}  # resource address -> (policy names, role addresses)
        self.unresolved = []
        self._link()

    def _roles_for(self, row, names, attribute):
        names = [n for n in names if isinstance(n, str) and n != "[sensitive]"]
        found = [matches[0] for n in names
                 if len(matches := self.role_by_name.get(n, [])) == 1]
        return found or referenced(self.plan, row, attribute, "aws_iam_role", self.roles)

    def _policy_name(self, row, arn):
        name = policy_name_from_arn(arn)
        if name:
            return name
        for address in referenced(self.plan, row, "policy_arn", "aws_iam_policy", self.policies):
            planned = (self.policies[address]["resource"].get("values") or {}).get("name")
            if isinstance(planned, str) and POLICY_NAME.match(planned):
                return planned
            return f"{address} (name unknown at plan time)"
        return "[policy unknown at plan time]"

    def _link(self):
        for row in self.rows:
            r, values = row["resource"], row["resource"].get("values") or {}
            if r["type"] == "aws_iam_role_policy_attachment":
                roles = self._roles_for(row, [values.get("role")], "role")
                policies = [self._policy_name(row, values.get("policy_arn"))]
            elif r["type"] == "aws_iam_policy_attachment":
                roles = self._roles_for(row, values.get("roles") or [], "roles")
                policies = [self._policy_name(row, values.get("policy_arn"))]
            elif r["type"] == "aws_iam_instance_profile":
                roles, policies = self._roles_for(row, [values.get("role")], "role"), []
            elif r["type"] == "aws_iam_role":
                arns = values.get("managed_policy_arns")
                for name in (policy_name_from_arn(a) for a in arns if isinstance(a, str)) if isinstance(arns, list) else []:
                    if name and name not in self.role_policies[r["address"]]:
                        self.role_policies[r["address"]].append(name)
                continue
            else:
                continue
            self.links[r["address"]] = (policies, roles)
            if r["type"] != "aws_iam_instance_profile":
                if not roles:
                    self.unresolved.append(r["address"])
                for role in roles:
                    for name in policies:
                        if name not in self.role_policies[role]:
                            self.role_policies[role].append(name)


def header_table(doc_id, generated_date):
    return [
        "| Field | Value |",
        "|---|---|",
        f"| Document ID | {doc_id} |",
        "| Owner | Cloud Platform Engineering |",
        "| Approver | Managing Director |",
        "| Version | 1.0 |",
        "| Effective | On approval |",
        "| Next review | 12 months after approval, or regenerate from the latest `main` run "
        "after any change to the workload's Terraform |",
        "| Status | Draft. Not approved: no approval record exists (simulated company) |",
    ]


def banner():
    return [
        f"<!-- Generated by {GENERATOR}. Do not edit by hand. -->",
    ]


def visible_banner():
    return (
        f"> Generated by `{GENERATOR}` from a Terraform plan JSON. **Do not edit by hand**: "
        "regenerate it from a newer run's `compliance-evidence` artifact instead. "
        "Ayka Secure Technologies GmbH is a simulated company; nothing in this plan is deployed."
    )


def provenance(args, plan, plan_sha, managed, changes):
    run = f"[{args.run_id}](https://github.com/{args.repository}/actions/runs/{args.run_id})" \
        if args.repository else args.run_id
    return [
        "| Field | Value |",
        "|---|---|",
        f"| Workload | `{args.workload}` |",
        f"| CI run | {run} |",
        f"| Commit | `{args.commit}` |",
        f"| Source artifact | `{args.source_artifact}`, file `{args.artifact_path}` |",
        f"| Plan file SHA-256 | `{plan_sha}` |",
        f"| Plan format / Terraform | {cell(plan.get('format_version'))} / {cell(plan.get('terraform_version'))} |",
        f"| Plan timestamp | {cell(plan.get('timestamp'))} |",
        f"| Generated at | {args.generated_at} |",
        f"| Generator | `{GENERATOR}` |",
        f"| Cross-check | {managed} managed resources in `planned_values`; "
        f"{changes} managed entries in `resource_changes` (excluding deletes). "
        "The generator stops if these differ |",
    ]


def verification_note(args):
    return (
        f"To re-check: download the artifact of the run above, compute `sha256sum {args.artifact_path}`, "
        "compare it with the SHA-256 here and with `evidence/artifacts.sha256` in the same artifact, "
        "then rerun the generator. This works only while GitHub still holds the artifact "
        "(the retention period is to verify in the repository settings)."
    )


def render_inventory(args, plan, plan_sha, rows, changes):
    resources = [row["resource"] for row in rows]
    by_module = Counter(row["module"] for row in rows)
    by_provider = Counter(provider_short(r.get("provider_name")) or "—" for r in resources)
    by_type = Counter(r.get("type") for r in resources)
    date = args.generated_at[:10]
    out = banner() + [
        f"# Asset inventory: {cell(Path(args.workload).name)} (generated)",
        "",
    ] + header_table(INVENTORY_DOC_ID, date) + [
        "",
        visible_banner(),
        "",
        "## 1. Provenance",
        "",
    ] + provenance(args, plan, plan_sha, len(rows), changes) + [
        "",
        verification_note(args),
        "",
        "## 2. Scope and limits",
        "",
        "- Every managed resource in the plan's `planned_values`, child modules included. Data sources are not assets and are left out.",
        "- A row is a resource Terraform **would** create. CI plans with mock credentials and never applies, "
        "so each row is **Gated design**, not a live asset.",
        f"- Tags shown: {', '.join(f'`{t}`' for t in SELECTED_TAGS)} (from `tags_all`, else `tags`). "
        "No other attribute value is written: the repository is public.",
        "- Terraform-marked sensitive attribute values are redacted before selection. Values that look like an AWS account ID or access key are replaced by `[account-id]` / `[access-key]`. Review allowlisted tags before publication: arbitrary unmarked secrets cannot be recognized reliably.",
        "",
        "## 3. Summary",
        "",
        f"{len(rows)} managed resources of {len(by_type)} types.",
        "",
        "| Module | Resources |",
        "|---|---|",
    ] + [f"| `{cell(m)}` | {n} |" for m, n in sorted(by_module.items())] + [
        "",
        "| Provider | Resources |",
        "|---|---|",
    ] + [f"| `{cell(p)}` | {n} |" for p, n in sorted(by_provider.items())] + [
        "",
        "| Tag | Resources carrying it |",
        "|---|---|",
    ] + [
        f"| `{t}` | {sum(1 for r in resources if t in tags_of(r))} of {len(rows)} |" for t in SELECTED_TAGS
    ] + [
        "",
        "## 4. Resources",
        "",
        "| Address | Type | Module | Provider | " + " | ".join(SELECTED_TAGS) + " |",
        "|---|---|---|---|" + "---|" * len(SELECTED_TAGS),
    ]
    for row in rows:
        r, tags = row["resource"], tags_of(row["resource"])
        out.append(
            f"| `{cell(r.get('address'))}` | `{cell(r.get('type'))}` | `{cell(row['module'])}` | "
            f"{cell(provider_short(r.get('provider_name')))} | "
            + " | ".join(cell(tags.get(t)) for t in SELECTED_TAGS) + " |"
        )
    out += [
        "",
        "## Revision history",
        "",
        "| Version | Date | Change |",
        "|---|---|---|",
        f"| 1.0 | {date} | First issue (generated from run {args.run_id}, commit `{args.commit[:7]}`) |",
        "",
    ]
    return "\n".join(out)


def render_iam(args, plan, plan_sha, rows, changes):
    index = IamIndex(plan, rows)
    by_type = Counter(row["resource"]["type"] for row in index.rows)
    identity_center = sum(n for t, n in by_type.items() if t.startswith(IDENTITY_CENTER_PREFIXES))
    users = by_type.get("aws_iam_user", 0)
    date = args.generated_at[:10]
    out = banner() + [
        f"# IAM plan extract: {cell(Path(args.workload).name)} (generated)",
        "",
    ] + header_table(IAM_DOC_ID, date) + [
        "",
        visible_banner(),
        "",
        "## 1. Provenance",
        "",
    ] + provenance(args, plan, plan_sha, len(rows), changes) + [
        "",
        verification_note(args),
        "",
        "## 2. Scope and limits",
        "",
        f"- Managed resources whose type starts with {', '.join(f'`{p}`' for p in IAM_PREFIXES)}. "
        "Policy documents (`aws_iam_policy_document` data sources) are not resources and are left out.",
        "- For roles: the **names** of attached managed policies, read from the attachment's policy ARN or, "
        "when that is unknown at plan time, from the referenced `aws_iam_policy` in the plan configuration. "
        "Role names, ARNs, trust policies and policy documents are not written.",
        "- Plan-time view, never deployed (**Gated design**). It shows what Terraform would create, not effective permissions.",
        "- Only the workload named in the provenance table is in this plan. IAM Identity Center groups, permission sets "
        "and platform IAM roles live in other Terraform roots that CI does not plan, so they are not listed here.",
        "",
        "## 3. Summary",
        "",
        "| Type | Resources |",
        "|---|---|",
    ] + [f"| `{cell(t)}` | {n} |" for t, n in sorted(by_type.items())] + [
        "",
        f"- IAM users in this plan: {users}.",
        f"- IAM Identity Center resources (`aws_ssoadmin_*`, `aws_identitystore_*`) in this plan: {identity_center}.",
        f"- Attachments not linked to a role: {len(index.unresolved)}.",
        "",
        "## 4. Roles and attached managed policies",
        "",
        "| Address | Module | Attached managed policies |",
        "|---|---|---|",
    ]
    for address in sorted(index.roles):
        names = index.role_policies.get(address) or []
        out.append(f"| `{cell(address)}` | `{cell(index.roles[address]['module'])}` | "
                   f"{cell(', '.join(names)) if names else 'none resolved in this plan'} |")
    if not index.roles:
        out.append("| — | — | No IAM roles in this plan |")
    out += [
        "",
        "## 5. All IAM resources",
        "",
        "| Address | Type | Module | Attached managed policy | Linked role |",
        "|---|---|---|---|---|",
    ]
    for row in index.rows:
        r = row["resource"]
        policies, roles = index.links.get(r["address"], ([], []))
        if r["type"] == "aws_iam_role":
            policies = index.role_policies.get(r["address"]) or []
        out.append(
            f"| `{cell(r['address'])}` | `{cell(r['type'])}` | `{cell(row['module'])}` | "
            f"{cell(', '.join(policies))} | {cell(', '.join(roles))} |"
        )
    if not index.rows:
        out.append("| — | — | — | — | No IAM resources in this plan |")
    if index.unresolved:
        out += ["", "Attachments not linked to a role: " + ", ".join(f"`{cell(a)}`" for a in index.unresolved)]
    out += [
        "",
        "## Revision history",
        "",
        "| Version | Date | Change |",
        "|---|---|---|",
        f"| 1.0 | {date} | First issue (generated from run {args.run_id}, commit `{args.commit[:7]}`) |",
        "",
    ]
    return "\n".join(out)


def check_output(text, name, known_values):
    """Last line of defence: a public file must not carry anything that looks like a credential.

    The provenance values (hashes, commit, run ID, timestamp) are not plan data and may contain
    twelve digits in a row, so they are taken out before the scan.
    """
    for value in sorted((v for v in known_values if v), key=len, reverse=True):
        text = text.replace(value, "")
    for label, pattern in (("account ID", ACCOUNT_ID), ("access key", ACCESS_KEY), ("PEM block", PEM)):
        if pattern.search(text):
            fail(f"{name}: output still contains something that looks like an {label}; nothing written")


def parse_args(argv):
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("plan_json")
    parser.add_argument("--run-id", required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--source-artifact", required=True)
    parser.add_argument("--workload", required=True)
    parser.add_argument("--artifact-path", default="output/tfplan.json",
                        help="path of the plan JSON inside the artifact, for the provenance table")
    parser.add_argument("--repository", default=os.environ.get("GITHUB_REPOSITORY"))
    parser.add_argument("--generated-at", default=datetime.now(timezone.utc).isoformat(timespec="seconds"))
    parser.add_argument("--inventory-out")
    parser.add_argument("--iam-out")
    args = parser.parse_args(argv)
    if not (args.inventory_out or args.iam_out):
        fail("give --inventory-out, --iam-out or both")
    for flag, pattern in FLAG_PATTERNS.items():
        value = getattr(args, flag)
        if value is not None and not pattern.match(value):
            fail(f"--{flag.replace('_', '-')} {value!r} is not valid")
    try:
        datetime.fromisoformat(args.generated_at.replace("Z", "+00:00"))
    except ValueError:
        fail(f"--generated-at {args.generated_at!r} is not ISO 8601")
    return args


def main(argv=None):
    args = parse_args(sys.argv[1:] if argv is None else argv)
    plan = public_plan(load_plan(args.plan_json))
    plan_sha = sha256_file(args.plan_json)
    rows = managed_resources(plan)
    changes = planned_change_count(plan)
    if changes != len(rows):
        fail(f"{len(rows)} managed resources in planned_values but {changes} in resource_changes; "
             "the walk missed something or the plan is inconsistent")
    addresses = [row["resource"].get("address") for row in rows]
    change_addresses = [r.get("address") for r in plan.get("resource_changes") or []
                        if r.get("mode") == "managed"
                        and (r.get("change") or {}).get("actions") != ["delete"]]
    if (any(not isinstance(a, str) or not a for a in addresses)
            or len(set(addresses)) != len(addresses)
            or Counter(addresses) != Counter(change_addresses)):
        fail("managed resource addresses are missing, duplicated or inconsistent with resource_changes")
    outputs = {}
    if args.inventory_out:
        outputs[args.inventory_out] = render_inventory(args, plan, plan_sha, rows, changes)
    if args.iam_out:
        outputs[args.iam_out] = render_iam(args, plan, plan_sha, rows, changes)
    known = [plan_sha, args.commit, args.run_id, args.generated_at]
    for path, text in outputs.items():
        check_output(text, path, known)
    for path, text in outputs.items():
        Path(path).parent.mkdir(parents=True, exist_ok=True)
        Path(path).write_text(text, encoding="utf-8")
        print(f"wrote {path}")
    print(json.dumps({"plan_sha256": plan_sha, "managed_resources": len(rows)}))


if __name__ == "__main__":
    main()
