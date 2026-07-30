# Decision Rule Verification Finding

## Verification result

- Total verification tests: 74
- Passed: 73
- Failed: 1

## Threshold coverage

All six verdict states were tested:

- ADDRESSED
- PARTIALLY_ADDRESSED
- RELATED
- NOT_APPLICABLE
- GAP
- UNRESOLVED

## Trust controls

- Expected verdict distribution defined: FALSE
- Quota allocation permitted: FALSE
- Rank allocation permitted: FALSE
- Top-N assignment permitted: FALSE
- Randomization permitted: FALSE
- Low-confidence ADDRESSED permitted: FALSE
- UNRESOLVED permitted: TRUE
- Prior verdict reuse permitted: FALSE

## Source state

Real source requirements adjudicated: 0.

The future R3C engine must derive every row independently and calculate the
aggregate distribution only after every row is sealed.

## Claim boundary

This verification does not establish legal compliance, government approval,
regulatory certification, implementation certification, safety, correctness,
or statutory satisfaction.

## Repaired Control

`POST_HOC_DISTRIBUTION_ONLY` is verified.

Aggregate verdict counts cannot be inspected until all row-level verdicts are
sealed.
