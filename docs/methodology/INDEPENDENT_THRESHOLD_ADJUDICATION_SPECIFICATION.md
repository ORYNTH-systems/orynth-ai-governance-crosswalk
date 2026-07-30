# ORYNTH AI Governance Crosswalk

## Independent Threshold Adjudication Specification

### Version

`05A-R3A-V1`

### Purpose

This specification defines the controlling decision rules for evaluating each
source requirement independently against the indexed public ORYNTH evidence.

The specification is frozen before any replacement compatibility verdicts are
generated.

The final verdict distribution must emerge from row-level decisions.

No quota, target count, ranking bucket, expected distribution, percentile,
relative ordering, or top-N allocation may influence any verdict.

---

## 1. Controlling inputs

The adjudication engine may use only:

- `EO_14409_REQUIREMENTS.csv`;
- `MN_HF_1606_REQUIREMENTS.csv`;
- `SOURCE_TO_NORMALIZED_REQUIREMENT_MAP.csv`;
- `NORMALIZED_REQUIREMENT_TAXONOMY.csv`;
- `ORYNTH_REFERENCE_ARCHITECTURE_INDEX.csv`;
- `ORYNTH_AUDIT_SPECIFICATION_INDEX.csv`;
- `ORYNTH_EVIDENCE_TO_TAXONOMY_MAP.csv`.

The engine must not use:

- a predetermined verdict distribution;
- prior PASS 05A verdicts;
- prior statistical outputs;
- prior public summaries;
- private architecture;
- unpublished implementation details;
- remembered architecture descriptions;
- separate ORYNTH ecosystem projects.

---

## 2. Unit of adjudication

The unit of adjudication is one atomic source requirement.

Each requirement must receive exactly one final verdict:

- `ADDRESSED`;
- `PARTIALLY_ADDRESSED`;
- `RELATED`;
- `NOT_APPLICABLE`;
- `GAP`;
- `UNRESOLVED`.

Each decision must be made independently.

The verdict assigned to one requirement must not depend on the verdict assigned
to any other requirement.

---

## 3. Mandatory decision sequence

Every requirement must pass through the following ordered questions.

### Question 1 — Central duty identification

Identify the central duty created by the source requirement.

The central duty must be expressed as one bounded action or function.

Examples include:

- restrict execution;
- preserve evidence;
- classify a model;
- conduct benchmarking;
- create a government program;
- prohibit specified content capability;
- impose civil liability;
- establish reporting;
- create consultation procedures.

Supporting, incidental, or adjacent duties must be recorded separately.

### Question 2 — Architectural applicability

Determine whether the central duty is architectural in nature.

An architectural duty concerns a mechanism that a system architecture could
meaningfully represent, enforce, preserve, route, validate, restrict, admit,
record, reconcile, or audit.

A duty is presumptively outside architectural applicability when its central
function is:

- legislative;
- judicial;
- punitive;
- fiscal;
- appropriative;
- governmental appointment;
- government workforce administration;
- statutory enforcement;
- creation of a private cause of action;
- creation of a civil penalty;
- mandatory government reporting;
- statutory notice creation;
- substantive legal prohibition as law;
- exercise of sovereign authority.

Architectural support for implementing or evidencing such a duty does not make
the central duty itself architectural.

### Question 3 — Taxonomy validity

Retrieve all reviewed normalized mappings for the requirement.

At least one valid normalized mapping is required before evidence derivation.

Taxonomy overlap is a discovery mechanism only.

Taxonomy overlap does not by itself establish compatibility.

### Question 4 — Evidence derivation

Retrieve all public ORYNTH evidence linked to the requirement’s normalized types.

Every cited evidence identifier must resolve to one of the 40 indexed public
evidence records.

Evidence must be evaluated by mechanism and scope limitation, not by identifier
count alone.

### Question 5 — Functional performance test

Determine whether the public mechanism performs the central architectural duty.

The following distinctions are mandatory:

- conceptual similarity is not functional performance;
- evidence support is not execution control;
- auditability is not legal compliance;
- traceability is not substantive correctness;
- scope limitation is not duty satisfaction;
- authority preservation is not statutory authority;
- execution restriction is not creation of a legal prohibition;
- evidence retention is not government reporting;
- conformance assessment is not certification.

### Question 6 — Material residual test

Identify every material component of the central duty that remains external.

A residual is material when its absence prevents the public ORYNTH mechanism
from performing the full architectural function under examination.

Residuals may include:

- missing architectural mechanism;
- external policy criteria;
- domain-specific thresholds;
- actor assignment;
- operational implementation;
- data collection;
- model access;
- human review;
- government action;
- legal interpretation;
- enforcement;
- notice;
- reporting;
- penalties;
- funding;
- substantive content standards.

### Question 7 — Neighbor-verdict counterfactual

For the proposed verdict, explain why the requirement does not receive each
immediately neighboring verdict.

Required examples:

- why `ADDRESSED` is not `PARTIALLY_ADDRESSED`;
- why `PARTIALLY_ADDRESSED` is not `ADDRESSED` or `RELATED`;
- why `RELATED` is not `PARTIALLY_ADDRESSED` or `NOT_APPLICABLE`;
- why `NOT_APPLICABLE` is not `RELATED` or `GAP`;
- why `GAP` is not `NOT_APPLICABLE` or `UNRESOLVED`;
- why `UNRESOLVED` cannot be assigned another verdict.

### Question 8 — Confidence and challenge status

Each verdict must include:

- `HIGH`, `MEDIUM`, or `LOW` confidence;
- human review status;
- challenge status;
- challenge rationale where applicable.

`LOW` confidence cannot produce `ADDRESSED`.

---

## 4. Verdict rules

### ADDRESSED

Assign `ADDRESSED` only when all conditions are true:

1. the central duty is architectural;
2. at least one reviewed normalized mapping directly represents that duty;
3. at least one indexed public ORYNTH mechanism directly performs the duty;
4. the evidence scope limitation does not negate the claimed function;
5. no material architectural component remains absent;
6. remaining external matters are limited to legal authority, domain criteria,
   adoption, or deployment responsibility;
7. confidence is `HIGH`;
8. the row passes the neighbor-verdict counterfactual.

### PARTIALLY_ADDRESSED

Assign `PARTIALLY_ADDRESSED` only when all conditions are true:

1. the central duty is architectural;
2. a direct public ORYNTH mechanism performs a material part of the duty;
3. one or more material architectural, operational, implementation, policy,
   actor, or data components remain external;
4. the mechanism is stronger than mere conceptual relationship;
5. the row does not satisfy all `ADDRESSED` conditions;
6. confidence is `HIGH` or `MEDIUM`.

### RELATED

Assign `RELATED` only when all conditions are true:

1. indexed public evidence is meaningfully relevant;
2. the evidence supports an adjacent governance, evidence, assurance, audit,
   authority, traceability, or execution dimension;
3. the public mechanism does not perform the central duty;
4. the relationship is stronger than incidental keyword overlap;
5. the central duty is not exclusively outside architectural applicability;
6. confidence is `HIGH` or `MEDIUM`.

### NOT_APPLICABLE

Assign `NOT_APPLICABLE` when:

1. the central duty is inherently legal, governmental, judicial, punitive,
   fiscal, enforcement-based, reporting-based, notice-based, or programmatic;
2. public ORYNTH mechanisms may support implementation or evidence but cannot
   perform the central sovereign or legal function;
3. absence of such a function is not an architectural defect.

This verdict must not be used merely because evidence is weak.

### GAP

Assign `GAP` only when all conditions are true:

1. the central duty is architectural;
2. the duty falls within a function that an execution-governance or assurance
   architecture could reasonably address;
3. no indexed public ORYNTH mechanism adequately performs the duty;
4. the absence is substantive rather than a documentation mismatch;
5. sufficient source and evidence information exists to make the determination.

### UNRESOLVED

Assign `UNRESOLVED` when:

1. source language is materially ambiguous;
2. normalized mappings are contested or insufficient;
3. evidence scope is unclear;
4. central-duty classification cannot be made confidently;
5. conflicting evidence prevents a stable verdict;
6. required information is missing.

`UNRESOLVED` is a valid trust-preserving result.

It must not be forced to zero.

---

## 5. Evidence combination rules

Evidence may be cumulative only when mechanisms perform complementary parts of
the same central duty.

Multiple weak or merely related evidence records cannot be aggregated into
direct performance.

Evidence counts must not substitute for functional analysis.

Reference Architecture and Audit Specification evidence may be combined only
when their functions are explicitly identified.

Audit evidence cannot be used to claim runtime execution control unless the
evidence itself defines that control.

Boundary evidence may constrain a verdict but cannot independently produce an
`ADDRESSED` verdict.

---

## 6. Distribution-blind execution rule

The adjudication engine must not calculate, inspect, or compare aggregate verdict
counts until every row-level verdict is sealed.

The engine must not contain:

- expected verdict counts;
- top-N selection;
- rank buckets;
- percentile allocation;
- quota balancing;
- forced residual distributions;
- post-hoc reassignment to match a target.

The distribution report must be generated only after row-level adjudication is
complete.

---

## 7. Reproducibility requirements

A rerun over unchanged inputs must produce identical:

- central-duty classifications;
- applicability determinations;
- evidence references;
- material residuals;
- verdicts;
- confidence states;
- counterfactual explanations;
- challenge statuses.

Every decision rule must be encoded explicitly.

No randomization is permitted.

---

## 8. Required decision-trace fields

Each adjudication row must preserve:

- adjudication ID;
- requirement ID;
- source ID;
- source text;
- central duty;
- supporting duties;
- architectural applicability;
- applicability rationale;
- normalized type IDs;
- evidence IDs;
- evidence mechanisms;
- evidence scope limits;
- functional-performance result;
- material residuals;
- proposed verdict;
- final verdict;
- confidence;
- neighbor-verdict counterfactual;
- human review status;
- challenge status;
- challenge rationale;
- legal-compliance boundary;
- external-authority boundary;
- method version.

---

## 9. Trust assertions

The implementation must prove:

- no prior verdicts were loaded;
- no expected distribution was defined;
- no rank allocation was used;
- every requirement was adjudicated independently;
- every evidence ID resolves;
- every verdict is traceable;
- every residual is recorded;
- every challenged row remains visible;
- aggregate statistics were generated after row sealing;
- no legal-compliance claim was introduced.

---

## 10. Completion boundary

This specification pass does not assign compatibility verdicts.

It authorizes implementation only after:

- the specification file exists;
- all decision rules are registered;
- all trace fields are defined;
- all challenge fields are defined;
- all no-quota assertions pass;
- downstream prior adjudication artifacts remain invalidated.

## Explicit Post-Hoc Distribution Control

The engine must not inspect aggregate verdict counts until every row-level verdict is sealed.

Aggregate verdict counts may be calculated only after all row-level
adjudications have been independently completed and sealed.

Aggregate counts must not be used to revise, rebalance, upgrade, downgrade,
suppress, or redistribute any sealed verdict.

## Explicit Plain-Text Unresolved-State Control

UNRESOLVED is a valid trust-preserving result.

UNRESOLVED must remain available whenever source language, applicability,
normalized mappings, evidence scope, functional performance, or material
residual analysis cannot support a stable substantive verdict.

UNRESOLVED must not be suppressed, converted, or reassigned to satisfy an
expected distribution.
