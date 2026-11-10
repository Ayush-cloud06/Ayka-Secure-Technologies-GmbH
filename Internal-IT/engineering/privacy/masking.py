"""Masking functions consistent with Governance/policies/data-masking-standard.md (STD-MSK-01).

Rules followed (section 3 of the standard):
- Default is removal: a field with no rule is dropped (rule 2).
- Permitted transformations are removal, synthetic replacement and tokenisation
  with a token store kept apart from the masked set (rule 3).
- A hash of a name or email is not offered, because the standard says it is not anonymous.
- The masked set carries a label: source system, date, transformation, fields that
  still identify (rule 4).
- survivors() is the test the standard asks for in section 4: a known identifier
  must not appear anywhere in the output, nested fields included.
"""

import json
import secrets

REMOVE, SYNTHETIC, TOKENISE, KEEP = "remove", "synthetic", "tokenise", "keep"
ACTIONS = {REMOVE, SYNTHETIC, TOKENISE, KEEP}


class TokenVault:
    """Token store. Keep it in a separate, access-controlled place from the masked set."""

    def __init__(self):
        self._map = {}

    def token(self, kind, value):
        key = (kind, value)
        if key not in self._map:
            self._map[key] = f"tok_{kind}_{secrets.token_hex(6)}"
        return self._map[key]

    def dump(self):
        """Serialise for storage elsewhere. Anyone holding this can reverse the tokens."""
        return json.dumps([[k, v, t] for (k, v), t in self._map.items()])


class Synthesiser:
    """Replaces a value with a stable synthetic one inside one run. The mapping is not exposed."""

    def __init__(self):
        self._seen = {}

    def value(self, kind, original):
        key = (kind, original)
        if key not in self._seen:
            n = sum(1 for k in self._seen if k[0] == kind) + 1
            self._seen[key] = {
                "email": f"person-{n:04d}@example.invalid",
                "name": f"Person {n:04d}",
                "ip": f"192.0.2.{(n % 254) + 1}",
            }.get(kind, f"{kind}-{n:04d}")
        return self._seen[key]


def scrub_text(text, identifiers, replacement="[masked]"):
    """Replace every occurrence of a known identifier in free text (case-insensitive)."""
    out = text
    for ident in sorted({i for i in identifiers if i}, key=len, reverse=True):
        low, start = out.lower(), 0
        while True:
            i = low.find(ident.lower(), start)
            if i < 0:
                break
            out = out[:i] + replacement + out[i + len(ident):]
            low, start = out.lower(), i + len(replacement)
    return out


def _mask_value(value, rule, vault, synth, identifiers):
    action, kind = rule
    if action == KEEP:
        return scrub_text(value, identifiers) if isinstance(value, str) else value
    if action == SYNTHETIC:
        return synth.value(kind, value)
    if action == TOKENISE:
        return vault.token(kind, value)
    raise ValueError(action)


def mask_dataset(rows, policy, *, source, date, vault=None, identifiers=()):
    """Mask rows (list of dicts). policy: field -> (action, kind). Unlisted fields are removed.

    Returns {"label": {...}, "rows": [...]}. Nested dicts and lists are masked recursively
    using the policy entry of the nested key. Free text kept with KEEP is scrubbed of the
    identifiers given.
    """
    for field, rule in policy.items():
        if rule[0] not in ACTIONS:
            raise ValueError(f"unknown action for {field}: {rule[0]}")
    vault = vault if vault is not None else TokenVault()
    synth = Synthesiser()

    def walk(obj):
        if isinstance(obj, dict):
            out = {}
            for k, v in obj.items():
                rule = policy.get(k)
                if rule is None or rule[0] == REMOVE:
                    continue
                out[k] = walk(v) if isinstance(v, (dict, list)) else _mask_value(v, rule, vault, synth, identifiers)
            return out
        if isinstance(obj, list):
            return [walk(x) for x in obj]
        return obj

    masked = [walk(r) for r in rows]
    label = {
        "source_system": source,
        "date": date,
        "transformations": {f: r[0] for f, r in policy.items()},
        "removed": "every field not listed in the policy",
        "fields_still_identifying": sorted(f for f, r in policy.items() if r[0] == KEEP),
        "tokens": "token store kept separately" if any(r[0] == TOKENISE for r in policy.values()) else "none",
    }
    return {"label": label, "rows": masked}


def survivors(masked, identifiers):
    """Return identifiers that still appear anywhere in the masked output (case-insensitive)."""
    blob = json.dumps(masked, ensure_ascii=False).lower()
    return sorted(i for i in identifiers if i and i.lower() in blob)
