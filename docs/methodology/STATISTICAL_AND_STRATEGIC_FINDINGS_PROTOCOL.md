# Statistical and Strategic Findings Protocol

## Purpose

PASS 05B derives statistical and strategic findings from the validated
PASS 05A compatibility outputs.

It does not alter compatibility verdicts.

## Controlling inputs

The pass uses:

- `COMPATIBILITY_MATRIX.csv`;
- `ORYNTH_EVIDENCE_USE_LEDGER.csv`;
- `RESIDUAL_REQUIREMENT_REGISTRY.csv`;
- the validated PASS 05A completion marker.

## Statistical units

The primary unit of analysis is one atomic source requirement.

The current bounded corpus contains:

- 25 Executive Order 14409 requirements;
- 9 Minnesota HF 1606 / Chapter 72 requirements;
- 34 total requirements.

Domain statistics may contain one requirement in more than one normalized domain.
Domain totals therefore describe domain participation and must not be added
together as though they were mutually exclusive corpus totals.

## Strategic interpretation rules

Strategic findings are derived from:

1. verdict counts;
2. source-level distributions;
3. normalized-domain distributions;
4. public evidence utilization;
5. residual-duty classes;
6. explicit scope exclusions.

The findings may identify:

- public architectural strengths;
- evidence concentration;
- residual implementation duties;
- intentional scope boundaries;
- public-mechanism gaps.

The findings must not infer:

- legal compliance;
- government approval;
- regulatory certification;
- implementation certification;
- statutory satisfaction;
- safety;
- correctness;
- fitness for purpose.

## Scope rule

`NOT_APPLICABLE` is not treated as a defect when the source requirement creates
a legal, governmental, enforcement, notice, reporting, content, funding, or
programmatic function outside the declared public ORYNTH architecture.

`GAP` is reserved for a requirement for which the indexed public artifacts do
not provide a sufficiently relevant mechanism.

## Release boundary

All findings apply only to the current selected corpus and the two indexed
public ORYNTH artifacts.

## Explicit Safety and Correctness Boundary

This assessment does not establish or guarantee safety.

This assessment does not establish or guarantee correctness.

These limitations apply to every verdict, statistic, strategic finding, and
public interpretation produced by the crosswalk.
