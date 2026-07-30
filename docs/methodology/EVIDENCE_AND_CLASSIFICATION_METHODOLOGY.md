# Evidence and Classification Methodology

## 1. Source Hierarchy

Sources are ranked in the following order:

1. Enrolled act, session law, statute, executive order, regulation, or official rule
2. Official legislative bill page and legislative journal
3. Official agency guidance or government press release
4. NCSL or equivalent institutional legislative database
5. Reputable legal analysis
6. News reporting
7. Commentary and social-media material

A lower-ranked source may support discovery but may not override a
higher-ranked source.

## 2. Date Classes

The project does not collapse dates into a single "law date."

Each measure may contain:

- public_text_date
- introduction_date
- announcement_date
- committee_action_date
- chamber_passage_date
- enrollment_date
- signature_date
- filing_date
- effective_date
- compliance_date
- rulemaking_deadline
- amendment_date
- repeal_date

Unknown dates remain blank. They are not inferred.

## 3. Status Classes

- DRAFT
- INTRODUCED
- PENDING
- PASSED_ONE_CHAMBER
- PASSED_LEGISLATURE
- ENROLLED
- ENACTED
- VETOED
- FAILED
- WITHDRAWN
- EXPIRED
- IN_FORCE
- AMENDED
- REPEALED

## 4. Requirement Atomicity

Each legal or policy provision must be decomposed into the smallest
independently assessable obligation.

One row must not combine multiple materially distinct obligations.

## 5. Actor Separation

Requirements must identify the actual regulated actor:

- model developer
- model deployer
- distributor
- platform operator
- employer
- government agency
- contractor
- consumer-facing service
- auditor
- designated federal official

Government implementation obligations must not be mislabeled as private
company mandates.

## 6. ORYNTH Compatibility Rule

A requirement may be marked ADDRESSED only where a public ORYNTH artifact
contains sufficiently specific architectural or audit evidence.

Conceptual similarity alone supports RELATED, not ADDRESSED.

No compatibility status constitutes legal advice, statutory certification,
regulatory approval, or a claim of legal compliance.
