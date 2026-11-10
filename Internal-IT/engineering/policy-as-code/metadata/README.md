# Control mapping

`control-mapping.yaml` in this folder is the mapping the gate **enforces**. The evaluator reads it on every CI run (`Internal-IT/engineering/ci-cd/scripts/evaluate-results.py`, constant `CONTROL_MAPPING_FILE`).

For each control it holds:

- the severity that drives the decision (HIGH fails the run, MEDIUM needs approval, LOW passes);
- the scanner rules that report it (Checkov or tfsec `policy_id`, OPA package and `[CONTROL_ID]` message prefix);
- the ISO/IEC 27001:2022 references (`frameworks.iso27001`);
- the SOC 2 Trust Services Criteria (2017, revised points of focus 2022) the control supports (`frameworks.soc2`). The compliance report prints both per control and lists the SOC 2 criteria touched by a run. A criterion listed here is supported by the plan check, not met by it: SOC 2 criteria are met by operating controls, which a plan scan cannot show.

A control that no scanner rule reports is listed but not enforced.
Changing a severity changes what the gate blocks, so write the reason in the commit message.
