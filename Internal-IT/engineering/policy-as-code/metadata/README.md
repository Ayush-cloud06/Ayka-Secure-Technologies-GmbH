# Control mapping

`control-mapping.yaml` in this folder is the mapping the gate **enforces**. The evaluator reads it on every CI run (`Internal-IT/engineering/ci-cd/scripts/evaluate-results.py`, constant `CONTROL_MAPPING_FILE`).

For each control it holds:

- the severity that drives the decision (HIGH fails the run, MEDIUM needs approval, LOW passes);
- the scanner rules that report it (Checkov or tfsec `policy_id`, OPA package and `[CONTROL_ID]` message prefix);
- the ISO/IEC 27001:2022 references.

A control that no scanner rule reports is listed but not enforced.
Changing a severity changes what the gate blocks, so write the reason in the commit message.
