# ORYNTH AI Governance Crosswalk — Public Polish Audit v1.0.1

## Audit scope

This audit evaluates the public GitHub landing-page experience and supporting
release presentation without changing the canonical adjudication, evidence
mapping, methodology, or verdict distribution.

## Canonical state

- Matrix rows: 34
- Addressed: 0
- Partially Addressed: 9
- Related: 4
- Not Applicable: 8
- Gap: 13
- Unresolved: 0

## Audit findings

- Critical: 1
- High: 2
- Medium: 1
- Low: 0
- Total: 4

| Severity | Area | Finding | Required action |
|---|---|---|---|
| CRITICAL | Privacy and portability | Absolute local Windows path found in scripts\repair\PASS_05A_R3C_STRICTMODE_REPAIRED.ps1. | Remove the local path before publication. |
| HIGH | README navigation | Broken relative README link: data/crosswalk/ORYNTH_EVIDENCE_USE_LEDGER.csv | Correct or remove the broken link. |
| HIGH | README navigation | Broken relative README link: LICENSE | Correct or remove the broken link. |
| MEDIUM | Release synchronization | main contains presentation corrections made after the v1.0.0 release tag. | Complete polish on this branch, then publish v1.0.1 without moving v1.0.0. |

## Release synchronization

- main commit: 879f358dbc43df4881f6461f142e9422e6fd13e2
- v1.0.0 tag commit: 46bcee715f775806085eb3b48e8e6d30347b7041
- Recommended polished release: v1.0.1
- v1.0.0 must remain immutable: TRUE

## Next phase

Apply only the documented public-presentation corrections on
\$PolishBranch\, validate the result, merge into main, and publish v1.0.1.
