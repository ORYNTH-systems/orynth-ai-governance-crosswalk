# Decision Rule Verification Protocol

## Purpose

PASS 05A-R3B verifies the frozen Independent Threshold Adjudication
Specification before any source-requirement verdict is generated.

## Controls verified

The pass verifies:

1. decision-rule presence and order;
2. decision-rule uniqueness;
3. decision-trace schema completeness;
4. challenge-register schema completeness;
5. all six verdict thresholds;
6. low-confidence restrictions;
7. material-residual behavior;
8. scope-negation behavior;
9. distribution blindness;
10. prohibition of quotas, ranking buckets, and top-N allocation;
11. availability of UNRESOLVED;
12. evidence and taxonomy referential integrity.

## Synthetic test boundary

Threshold tests use synthetic cases only.

No Executive Order 14409 or Minnesota HF 1606 requirement receives a verdict
during this pass.

## Distribution boundary

No expected verdict distribution is defined.

Aggregate source-corpus statistics cannot exist until the independent engine
has sealed all 34 row-level adjudications.

## Post-Hoc Distribution Verification

The engine must not inspect aggregate verdict counts until every row-level
verdict is sealed.

The distribution is an output of completed adjudication and may not influence
any row-level verdict.
