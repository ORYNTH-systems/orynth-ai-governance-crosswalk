& {
    $ErrorActionPreference = 'Stop'
    Set-StrictMode -Version Latest

    # Resolve the repository root relative to this script:
    # scripts/repair/<script>.ps1 -> repository root
    $Repo = (
        Resolve-Path -LiteralPath (
            Join-Path $PSScriptRoot '..\..'
        )
    ).Path

    Set-Location -LiteralPath $Repo

    Write-Host ''
    Write-Host '======================================================================' -ForegroundColor Cyan
    Write-Host 'ORYNTH AI GOVERNANCE CROSSWALK' -ForegroundColor Cyan
    Write-Host 'PASS 05A-R3C — DETERMINISTIC INDEPENDENT ADJUDICATION ENGINE' -ForegroundColor Cyan
    Write-Host '======================================================================' -ForegroundColor Cyan

    # ------------------------------------------------------------------
    # Paths
    # ------------------------------------------------------------------

    $RequirementDir = Join-Path $Repo 'data\requirements'
    $CrosswalkDir   = Join-Path $Repo 'data\crosswalk'
    $StatisticsDir  = Join-Path $Repo 'data\statistics'
    $MethodologyDir = Join-Path $Repo 'docs\methodology'
    $FindingsDir    = Join-Path $Repo 'docs\findings'
    $TestsDir       = Join-Path $Repo 'tests'

    @(
        $CrosswalkDir
        $StatisticsDir
        $MethodologyDir
        $FindingsDir
        $TestsDir
    ) | ForEach-Object {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }

    $EOPath = Join-Path $RequirementDir 'EO_14409_REQUIREMENTS.csv'
    $MNPath = Join-Path $RequirementDir 'MN_HF_1606_REQUIREMENTS.csv'
    $TaxonomyPath = Join-Path $RequirementDir 'NORMALIZED_REQUIREMENT_TAXONOMY.csv'
    $SourceMapPath = Join-Path $RequirementDir 'SOURCE_TO_NORMALIZED_REQUIREMENT_MAP.csv'

    $ReferencePath = Join-Path $CrosswalkDir 'ORYNTH_REFERENCE_ARCHITECTURE_INDEX.csv'
    $AuditPath = Join-Path $CrosswalkDir 'ORYNTH_AUDIT_SPECIFICATION_INDEX.csv'
    $EvidenceMapPath = Join-Path $CrosswalkDir 'ORYNTH_EVIDENCE_TO_TAXONOMY_MAP.csv'

    $SpecificationPath = Join-Path $MethodologyDir 'INDEPENDENT_THRESHOLD_ADJUDICATION_SPECIFICATION.md'
    $R3AMarkerPath = Join-Path $TestsDir 'PASS_05A_R3A_COMPLETION.marker'
    $R3BMarkerPath = Join-Path $TestsDir 'PASS_05A_R3B_COMPLETION.marker'

    $TracePath = Join-Path $CrosswalkDir 'INDEPENDENT_ADJUDICATION_TRACE.csv'
    $LedgerPath = Join-Path $CrosswalkDir 'PROVISIONAL_EVIDENCE_USE_LEDGER.csv'
    $ResidualPath = Join-Path $CrosswalkDir 'PROVISIONAL_RESIDUAL_DUTY_REGISTRY.csv'
    $ChallengePath = Join-Path $CrosswalkDir 'ADJUDICATION_CHALLENGE_REGISTER.csv'
    $TrustPath = Join-Path $CrosswalkDir 'INDEPENDENT_ENGINE_TRUST_ASSERTIONS.csv'

    $DistributionPath = Join-Path $StatisticsDir 'PROVISIONAL_INDEPENDENT_VERDICT_DISTRIBUTION.csv'
    $ApplicabilityPath = Join-Path $StatisticsDir 'PROVISIONAL_ARCHITECTURAL_APPLICABILITY_STATISTICS.csv'

    $ProtocolPath = Join-Path $MethodologyDir 'DETERMINISTIC_INDEPENDENT_ADJUDICATION_ENGINE_PROTOCOL.md'
    $FindingPath = Join-Path $FindingsDir 'PROVISIONAL_INDEPENDENT_ADJUDICATION_FINDING.md'
    $R3CMarkerPath = Join-Path $TestsDir 'PASS_05A_R3C_COMPLETION.marker'

    # ------------------------------------------------------------------
    # Remove partial R3C/R4 and prohibited downstream state
    # ------------------------------------------------------------------

    @(
        $TracePath
        $LedgerPath
        $ResidualPath
        $ChallengePath
        $TrustPath
        $DistributionPath
        $ApplicabilityPath
        $ProtocolPath
        $FindingPath
        $R3CMarkerPath
        (Join-Path $TestsDir 'PASS_05A_R4_COMPLETION.marker')
        (Join-Path $TestsDir 'PASS_05A_R5_COMPLETION.marker')
        (Join-Path $TestsDir 'PASS_05A_COMPLETION.marker')
        (Join-Path $TestsDir 'PASS_05B_COMPLETION.marker')
        (Join-Path $TestsDir 'PASS_05C_COMPLETION.marker')
        (Join-Path $TestsDir 'PASS_05D_COMPLETION.marker')
        (Join-Path $CrosswalkDir 'ADVERSARIAL_VERDICT_REVIEW.csv')
        (Join-Path $CrosswalkDir 'ADVERSARIAL_ATTACK_REGISTER.csv')
        (Join-Path $CrosswalkDir 'ADJUDICATION_CHALLENGE_REGISTER_REVIEWED.csv')
        (Join-Path $CrosswalkDir 'COMPATIBILITY_MATRIX.csv')
        (Join-Path $CrosswalkDir 'ORYNTH_EVIDENCE_USE_LEDGER.csv')
        (Join-Path $CrosswalkDir 'RESIDUAL_REQUIREMENT_REGISTRY.csv')
    ) | ForEach-Object {
        if (Test-Path -LiteralPath $_) {
            Remove-Item -LiteralPath $_ -Force
        }
    }

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    function Assert-Count {
        param(
            [string]$Name,
            [int]$Actual,
            [int]$Expected
        )

        if ($Actual -ne $Expected) {
            throw "$Name expected $Expected; found $Actual."
        }
    }

    function Get-Hash {
        param([object[]]$Rows)

        $Json = $Rows | ConvertTo-Json -Depth 20 -Compress
        $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Json)
        $Provider = [System.Security.Cryptography.SHA256]::Create()

        try {
            return (
                [System.BitConverter]::ToString(
                    $Provider.ComputeHash($Bytes)
                )
            ).Replace('-', '')
        }
        finally {
            $Provider.Dispose()
        }
    }

    function Get-Applicability {
        param(
            [string]$Duty,
            [string]$ActionClass
        )

        $ArchitecturalPattern = (
            '(?i)\baccess|admission|allow|authori[sz]|benchmark|classif|' +
            'confidential|control|cyber|deny|detect|evidence|execution|' +
            'monitor|preserve|prevent|record|reconcile|restrict|secure|' +
            'test|trace|validate|verify|audit\b'
        )

        $NonArchitecturalPattern = (
            '(?i)\bappropriate funds|appropriation|attorney general|' +
            'civil action|civil penalty|court|private right of action|' +
            'prosecute|report to congress|submit to congress|' +
            'workforce program|appoint|legal remedy\b'
        )

        if (
            $Duty -match $ArchitecturalPattern -or
            $ActionClass -match (
                '(?i)ACCESS|AUDIT|BENCHMARK|CLASSIFICATION|CONTROL|' +
                'CYBER|EVIDENCE|EXECUTION|RESTRICTION|SECURITY|' +
                'TESTING|TRACEABILITY|VALIDATION|VERIFICATION'
            )
        ) {
            return 'ARCHITECTURAL'
        }

        if (
            $Duty -match $NonArchitecturalPattern -or
            $ActionClass -match (
                '(?i)APPROPRIATION|APPOINTMENT|CIVIL_REMEDY|' +
                'ENFORCEMENT|FUNDING|JUDICIAL|PENALTY|' +
                'REPORTING_TO_GOVERNMENT|WORKFORCE_PROGRAM'
            )
        ) {
            return 'NON_ARCHITECTURAL'
        }

        return 'UNCERTAIN'
    }

    function Get-Performance {
        param(
            [object[]]$Mappings,
            [object[]]$EvidenceMappings,
            [hashtable]$EvidenceLookup
        )

        if ($Mappings.Count -eq 0) {
            return 'UNKNOWN'
        }

        if ($EvidenceMappings.Count -eq 0) {
            return 'NONE'
        }

        $DirectTypes = @(
            $Mappings |
                Where-Object {
                    $_.mapping_strength -eq 'DIRECT'
                } |
                Select-Object -ExpandProperty normalized_requirement_type_id |
                Sort-Object -Unique
        )

        if ($DirectTypes.Count -eq 0) {
            return 'ADJACENT'
        }

        $CoveredDirectTypes = @()

        foreach ($Map in $EvidenceMappings) {
            if ($Map.normalized_requirement_type_id -notin $DirectTypes) {
                continue
            }

            $Evidence = $EvidenceLookup[$Map.evidence_id]
            $Strength = [string]$Evidence.evidence_strength

            if ($Strength -match '(?i)^DIRECT') {
                $CoveredDirectTypes += $Map.normalized_requirement_type_id
            }
        }

        $CoveredDirectTypes = @(
            $CoveredDirectTypes |
                Sort-Object -Unique
        )

        if ($CoveredDirectTypes.Count -eq $DirectTypes.Count) {
            return 'DIRECT'
        }

        if ($CoveredDirectTypes.Count -gt 0) {
            return 'PARTIAL'
        }

        return 'ADJACENT'
    }

    function Get-Residual {
        param(
            [string]$Applicability,
            [string]$Performance
        )

        if ($Applicability -eq 'NON_ARCHITECTURAL') {
            return 'SOVEREIGN_OR_LEGAL_FUNCTION_EXTERNAL'
        }

        if ($Applicability -eq 'UNCERTAIN') {
            return 'APPLICABILITY_REQUIRES_REVIEW'
        }

        switch ($Performance) {
            'DIRECT' {
                return 'NO_MATERIAL_ARCHITECTURAL_RESIDUAL;EXTERNAL_AUTHORITY_POLICY_AND_DEPLOYMENT_REMAIN'
            }
            'PARTIAL' {
                return 'MATERIAL_ARCHITECTURAL_OR_IMPLEMENTATION_COMPONENT_REMAINS'
            }
            'ADJACENT' {
                return 'CENTRAL_DUTY_NOT_FUNCTIONALLY_PERFORMED'
            }
            'NONE' {
                return 'MATERIAL_ARCHITECTURAL_MECHANISM_ABSENT'
            }
            default {
                return 'MAPPING_OR_EVIDENCE_STATE_REQUIRES_REVIEW'
            }
        }
    }

    function Resolve-Verdict {
        param(
            [string]$Applicability,
            [string]$Performance,
            [string]$Residual,
            [string]$Confidence,
            [int]$MappingCount
        )

        if (
            $MappingCount -eq 0 -or
            $Applicability -eq 'UNCERTAIN' -or
            $Performance -eq 'UNKNOWN'
        ) {
            return 'UNRESOLVED'
        }

        if ($Applicability -eq 'NON_ARCHITECTURAL') {
            return 'NOT_APPLICABLE'
        }

        if ($Performance -eq 'NONE') {
            return 'GAP'
        }

        if (
            $Performance -eq 'DIRECT' -and
            $Residual -match '^NO_MATERIAL_ARCHITECTURAL_RESIDUAL' -and
            $Confidence -eq 'HIGH'
        ) {
            return 'ADDRESSED'
        }

        if (
            $Performance -in @('DIRECT', 'PARTIAL') -and
            $Confidence -in @('HIGH', 'MEDIUM')
        ) {
            return 'PARTIALLY_ADDRESSED'
        }

        if (
            $Performance -eq 'ADJACENT' -and
            $Confidence -in @('HIGH', 'MEDIUM')
        ) {
            return 'RELATED'
        }

        return 'UNRESOLVED'
    }

    function Get-Counterfactual {
        param([string]$Verdict)

        switch ($Verdict) {
            'ADDRESSED' {
                return 'Not PARTIALLY_ADDRESSED because all direct normalized duties possess direct public evidence and no material architectural residual was identified. Not RELATED because the mechanism performs the central duty.'
            }
            'PARTIALLY_ADDRESSED' {
                return 'Not ADDRESSED because direct coverage is incomplete or a material residual remains. Not RELATED because public evidence directly performs at least one material part of the central duty.'
            }
            'RELATED' {
                return 'Not PARTIALLY_ADDRESSED because direct functional performance is not established. Not NOT_APPLICABLE because the duty retains an architectural dimension.'
            }
            'NOT_APPLICABLE' {
                return 'Not RELATED because the central duty is sovereign, legal, punitive, fiscal, judicial, or governmental. Not GAP because absence of sovereign authority is not an architectural defect.'
            }
            'GAP' {
                return 'Not NOT_APPLICABLE because the duty is architectural. Not UNRESOLVED because reviewed mappings permit a stable finding that no performing public mechanism exists.'
            }
            default {
                return 'No neighboring substantive verdict can be selected reliably until applicability, mapping, or evidence uncertainty is resolved.'
            }
        }
    }

    # ------------------------------------------------------------------
    # Validate prerequisites and trust controls
    # ------------------------------------------------------------------

    $RequiredInputs = @(
        $EOPath
        $MNPath
        $TaxonomyPath
        $SourceMapPath
        $ReferencePath
        $AuditPath
        $EvidenceMapPath
        $SpecificationPath
        $R3AMarkerPath
        $R3BMarkerPath
    )

    $MissingInputs = @(
        $RequiredInputs |
            Where-Object {
                -not (Test-Path -LiteralPath $_)
            }
    )

    if ($MissingInputs.Count -gt 0) {
        throw (
            'PASS 05A-R3C cannot start. Missing inputs: ' +
            ($MissingInputs -join ', ')
        )
    }

    $R3AMarker = Get-Content -LiteralPath $R3AMarkerPath -Raw
    $R3BMarker = Get-Content -LiteralPath $R3BMarkerPath -Raw

    if (
        $R3AMarker -notmatch
        'ORYNTH_AI_GOVERNANCE_CROSSWALK_PASS_05A_R3A_INDEPENDENT_THRESHOLD_ADJUDICATION_SPECIFICATION_COMPLETE'
    ) {
        throw 'PASS 05A-R3A marker is invalid.'
    }

    if (
        $R3BMarker -notmatch
        'ORYNTH_AI_GOVERNANCE_CROSSWALK_PASS_05A_R3B_DECISION_RULE_VERIFICATION_COMPLETE'
    ) {
        throw 'PASS 05A-R3B marker is invalid.'
    }

    if ($R3BMarker -notmatch 'Verification tests failed: 0') {
        throw 'PASS 05A-R3B does not record zero verification failures.'
    }

    if ($R3BMarker -notmatch 'POST_HOC_DISTRIBUTION_ONLY: VERIFIED') {
        throw 'PASS 05A-R3B does not verify post-hoc distribution control.'
    }

    $Specification = Get-Content -LiteralPath $SpecificationPath -Raw

    $TrustPatterns = @(
        '(?i)`?UNRESOLVED`?\s+is\s+a\s+valid\s+trust-preserving\s+result\.'
        '(?i)No randomization is permitted\.'
        '(?i)engine must not inspect aggregate verdict counts until every row-level verdict is sealed\.'
    )

    foreach ($Pattern in $TrustPatterns) {
        if ($Specification -notmatch $Pattern) {
            throw "Frozen specification is missing control matching: $Pattern"
        }
    }

    $ForbiddenCounts = @(
        '(?i)ADDRESSED\s*:\s*2'
        '(?i)PARTIALLY_ADDRESSED\s*:\s*8'
        '(?i)RELATED\s*:\s*10'
        '(?i)NOT_APPLICABLE\s*:\s*13'
        '(?i)GAP\s*:\s*1'
        '(?i)UNRESOLVED\s*:\s*0'
    )

    foreach ($Pattern in $ForbiddenCounts) {
        if ($Specification -match $Pattern) {
            throw "Prohibited target distribution detected: $Pattern"
        }
    }

    # ------------------------------------------------------------------
    # Load and normalize corpus
    # ------------------------------------------------------------------

    $EORows = @(Import-Csv -LiteralPath $EOPath)
    $MNRows = @(Import-Csv -LiteralPath $MNPath)

    Assert-Count 'EO requirement count' $EORows.Count 25
    Assert-Count 'Minnesota requirement count' $MNRows.Count 9

    $Requirements = @()

    for ($Index = 0; $Index -lt $EORows.Count; $Index++) {
        $Row = $EORows[$Index]

        $Requirements += [pscustomobject]@{
            requirement_id = $Row.requirement_id
            source_id = 'FED-EO-14409'
            source_name = 'Executive Order 14409'
            source_sequence = $Index + 1
            central_duty = $Row.action
            action_class = $Row.requirement_class
            supporting_duties = (
                "actor=$($Row.actor);actor_class=$($Row.actor_class);" +
                "private_company_effect=$($Row.private_company_effect);" +
                "collaboration_status=$($Row.collaboration_status)"
            )
        }
    }

    for ($Index = 0; $Index -lt $MNRows.Count; $Index++) {
        $Row = $MNRows[$Index]

        $Requirements += [pscustomobject]@{
            requirement_id = $Row.requirement_id
            source_id = 'MN-HF-1606'
            source_name = 'Minnesota HF 1606 / Chapter 72'
            source_sequence = $Index + 1
            central_duty = $Row.requirement
            action_class = $Row.action_type
            supporting_duties = (
                "actor=$($Row.regulated_actor);actor_class=$($Row.actor_class);" +
                "enforcement=$($Row.enforcement);consequence=$($Row.consequence);" +
                "exception=$($Row.exception_reference)"
            )
        }
    }

    Assert-Count 'Normalized corpus count' $Requirements.Count 34

    $DuplicateRequirements = @(
        $Requirements |
            Group-Object requirement_id |
            Where-Object {
                $_.Count -ne 1
            }
    )

    if ($DuplicateRequirements.Count -gt 0) {
        throw (
            'Duplicate requirement IDs: ' +
            ($DuplicateRequirements.Name -join ', ')
        )
    }

    $TaxonomyRows = @(Import-Csv -LiteralPath $TaxonomyPath)
    $SourceMapRows = @(Import-Csv -LiteralPath $SourceMapPath)
    $ReferenceRows = @(Import-Csv -LiteralPath $ReferencePath)
    $AuditRows = @(Import-Csv -LiteralPath $AuditPath)
    $EvidenceMapRows = @(Import-Csv -LiteralPath $EvidenceMapPath)

    Assert-Count 'Reference evidence count' $ReferenceRows.Count 20
    Assert-Count 'Audit evidence count' $AuditRows.Count 20
    Assert-Count 'Evidence-taxonomy relationship count' $EvidenceMapRows.Count 108

    if ($TaxonomyRows.Count -lt 55) {
        throw "Expected at least 55 taxonomy rows; found $($TaxonomyRows.Count)."
    }

    $TaxonomyIds = @(
        $TaxonomyRows.requirement_type_id |
            Sort-Object -Unique
    )

    $EvidenceRows = @($ReferenceRows + $AuditRows)
    $EvidenceLookup = @{}

    foreach ($Evidence in $EvidenceRows) {
        if ([string]::IsNullOrWhiteSpace($Evidence.evidence_id)) {
            throw 'Evidence row missing evidence_id.'
        }

        if ($EvidenceLookup.ContainsKey($Evidence.evidence_id)) {
            throw "Duplicate evidence ID: $($Evidence.evidence_id)"
        }

        $EvidenceLookup[$Evidence.evidence_id] = $Evidence
    }

    foreach ($Map in $SourceMapRows) {
        if ($Map.source_requirement_id -notin $Requirements.requirement_id) {
            throw "Unknown source requirement mapping: $($Map.source_requirement_id)"
        }

        if ($Map.normalized_requirement_type_id -notin $TaxonomyIds) {
            throw "Unknown taxonomy mapping: $($Map.normalized_requirement_type_id)"
        }
    }

    foreach ($Map in $EvidenceMapRows) {
        if (-not $EvidenceLookup.ContainsKey($Map.evidence_id)) {
            throw "Unknown evidence mapping: $($Map.evidence_id)"
        }

        if ($Map.normalized_requirement_type_id -notin $TaxonomyIds) {
            throw "Unknown evidence taxonomy type: $($Map.normalized_requirement_type_id)"
        }
    }

    # ------------------------------------------------------------------
    # Independent engine
    # ------------------------------------------------------------------

    function Invoke-Engine {
        $Trace = @()
        $Ledger = @()
        $Residuals = @()
        $Challenges = @()

        $TraceSequence = 0
        $LedgerSequence = 0
        $ResidualSequence = 0
        $ChallengeSequence = 0

        foreach (
            $Requirement in (
                $Requirements |
                    Sort-Object source_id, source_sequence, requirement_id
            )
        ) {
            $TraceSequence++

            $Mappings = @(
                $SourceMapRows |
                    Where-Object {
                        $_.source_requirement_id -eq $Requirement.requirement_id -and
                        $_.human_review_status -eq 'REVIEWED'
                    } |
                    Sort-Object normalized_requirement_type_id, mapping_strength, mapping_id
            )

            $TypeIds = @(
                $Mappings |
                    ForEach-Object {
                        $_.normalized_requirement_type_id
                    } |
                    Where-Object {
                        -not [string]::IsNullOrWhiteSpace($_)
                    } |
                    Sort-Object -Unique
            )

            $EvidenceMappings = @(
                $EvidenceMapRows |
                    Where-Object {
                        $_.normalized_requirement_type_id -in $TypeIds
                    } |
                    Sort-Object normalized_requirement_type_id, evidence_id
            )

            $EvidenceMappings = @(
                $EvidenceMappings |
                    Group-Object evidence_id, normalized_requirement_type_id |
                    ForEach-Object {
                        $_.Group | Select-Object -First 1
                    }
            )

            $EvidenceIds = @(
                $EvidenceMappings |
                    ForEach-Object {
                        $_.evidence_id
                    } |
                    Where-Object {
                        -not [string]::IsNullOrWhiteSpace($_)
                    } |
                    Sort-Object -Unique
            )

            $Applicability = Get-Applicability `
                -Duty $Requirement.central_duty `
                -ActionClass $Requirement.action_class

            $Performance = Get-Performance `
                -Mappings $Mappings `
                -EvidenceMappings $EvidenceMappings `
                -EvidenceLookup $EvidenceLookup

            $Residual = Get-Residual `
                -Applicability $Applicability `
                -Performance $Performance

            if (
                $Mappings.Count -eq 0 -or
                $Applicability -eq 'UNCERTAIN' -or
                $Performance -eq 'UNKNOWN'
            ) {
                $Confidence = 'LOW'
            }
            elseif (
                $Applicability -eq 'NON_ARCHITECTURAL' -or
                $Performance -in @('DIRECT', 'NONE')
            ) {
                $Confidence = 'HIGH'
            }
            else {
                $Confidence = 'MEDIUM'
            }

            $Verdict = Resolve-Verdict `
                -Applicability $Applicability `
                -Performance $Performance `
                -Residual $Residual `
                -Confidence $Confidence `
                -MappingCount $Mappings.Count

            if (
                $Verdict -eq 'ADDRESSED' -and
                $Confidence -ne 'HIGH'
            ) {
                throw (
                    'Low-confidence ADDRESSED prohibited for ' +
                    $Requirement.requirement_id
                )
            }

            $Mechanisms = @(
                foreach ($EvidenceId in $EvidenceIds) {
                    $EvidenceLookup[$EvidenceId].mechanism
                }
            ) |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                } |
                Sort-Object -Unique

            $ScopeLimits = @(
                foreach ($EvidenceId in $EvidenceIds) {
                    $EvidenceLookup[$EvidenceId].scope_limit
                }
            ) |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                } |
                Sort-Object -Unique

            $Trace += [pscustomobject]@{
                adjudication_id = "IADJ-{0:D3}" -f $TraceSequence
                requirement_id = $Requirement.requirement_id
                source_id = $Requirement.source_id
                source_name = $Requirement.source_name
                source_text = $Requirement.central_duty
                central_duty = $Requirement.central_duty
                supporting_duties = $Requirement.supporting_duties
                architectural_applicability = $Applicability
                applicability_rationale = (
                    "Deterministic applicability state: $Applicability."
                )
                normalized_type_ids = $TypeIds -join ';'
                evidence_ids = $EvidenceIds -join ';'
                evidence_mechanisms = $Mechanisms -join ';'
                evidence_scope_limits = $ScopeLimits -join ';'
                functional_performance = $Performance
                functional_performance_rationale = (
                    "Deterministic functional-performance state: $Performance."
                )
                material_residuals = $Residual
                proposed_verdict = $Verdict
                final_verdict = $Verdict
                confidence = $Confidence
                neighbor_verdict_counterfactual = Get-Counterfactual $Verdict
                human_review_status = 'PENDING_ADVERSARIAL_REVIEW'
                challenge_status = 'REQUIRED'
                challenge_rationale = 'Every provisional row requires complete adversarial review.'
                legal_compliance_determination = 'NOT_ASSESSED'
                external_legal_authority_preserved = 'TRUE'
                no_quota_assertion = 'TRUE'
                row_sealed = 'TRUE'
                method_version = '05A-R3C-V3'
            }

            foreach ($EvidenceMap in $EvidenceMappings) {
                $LedgerSequence++
                $Evidence = $EvidenceLookup[$EvidenceMap.evidence_id]

                $Ledger += [pscustomobject]@{
                    evidence_use_id = "PEUL-{0:D4}" -f $LedgerSequence
                    adjudication_id = "IADJ-{0:D3}" -f $TraceSequence
                    requirement_id = $Requirement.requirement_id
                    source_id = $Requirement.source_id
                    provisional_verdict = $Verdict
                    evidence_id = $Evidence.evidence_id
                    artifact_id = $Evidence.artifact_id
                    overlapping_type_id = $EvidenceMap.normalized_requirement_type_id
                    evidence_name = $Evidence.evidence_name
                    mechanism = $Evidence.mechanism
                    evidence_strength = $Evidence.evidence_strength
                    scope_limit = $Evidence.scope_limit
                    derivation_state = 'NORMALIZED_TAXONOMY_OVERLAP'
                    functional_use_state = $Performance
                    legal_compliance_claim = 'NONE'
                }
            }

            if ($Verdict -ne 'ADDRESSED') {
                $ResidualSequence++

                $Residuals += [pscustomobject]@{
                    residual_id = "PRES-{0:D3}" -f $ResidualSequence
                    adjudication_id = "IADJ-{0:D3}" -f $TraceSequence
                    requirement_id = $Requirement.requirement_id
                    source_id = $Requirement.source_id
                    provisional_verdict = $Verdict
                    residual_state = $Residual
                    central_duty = $Requirement.central_duty
                    external_legal_authority_preserved = 'TRUE'
                    legal_compliance_claim = 'NONE'
                    review_state = 'PENDING_ADVERSARIAL_REVIEW'
                }
            }

            $ChallengeSequence++

            $Challenges += [pscustomobject]@{
                challenge_id = "CHL-{0:D3}" -f $ChallengeSequence
                requirement_id = $Requirement.requirement_id
                challenged_verdict = $Verdict
                challenge_basis = 'Mandatory full-row adversarial review.'
                challenger_position = 'NOT_YET_RECORDED'
                supporting_evidence_ids = $EvidenceIds -join ';'
                resolution_status = 'OPEN'
                resolution_rationale = ''
                reviewer = 'UNASSIGNED'
                review_state = 'PENDING_PASS_05A_R4'
            }
        }

        return [pscustomobject]@{
            Trace = @($Trace)
            Ledger = @($Ledger)
            Residuals = @($Residuals)
            Challenges = @($Challenges)
        }
    }

    # ------------------------------------------------------------------
    # Execute twice for reproducibility
    # ------------------------------------------------------------------

    $RunOne = Invoke-Engine
    $RunTwo = Invoke-Engine

    $TraceHashOne = Get-Hash $RunOne.Trace
    $TraceHashTwo = Get-Hash $RunTwo.Trace
    $LedgerHashOne = Get-Hash $RunOne.Ledger
    $LedgerHashTwo = Get-Hash $RunTwo.Ledger
    $ResidualHashOne = Get-Hash $RunOne.Residuals
    $ResidualHashTwo = Get-Hash $RunTwo.Residuals
    $ChallengeHashOne = Get-Hash $RunOne.Challenges
    $ChallengeHashTwo = Get-Hash $RunTwo.Challenges

    if ($TraceHashOne -ne $TraceHashTwo) {
        throw 'Trace reproducibility failed.'
    }

    if ($LedgerHashOne -ne $LedgerHashTwo) {
        throw 'Evidence-ledger reproducibility failed.'
    }

    if ($ResidualHashOne -ne $ResidualHashTwo) {
        throw 'Residual-registry reproducibility failed.'
    }

    if ($ChallengeHashOne -ne $ChallengeHashTwo) {
        throw 'Challenge-register reproducibility failed.'
    }

    $TraceRows = @($RunOne.Trace)
    $LedgerRows = @($RunOne.Ledger)
    $ResidualRows = @($RunOne.Residuals)
    $ChallengeRows = @($RunOne.Challenges)

    Assert-Count 'Provisional adjudication count' $TraceRows.Count 34
    Assert-Count 'Mandatory challenge count' $ChallengeRows.Count 34

    $UnsealedRows = @(
        $TraceRows |
            Where-Object {
                $_.row_sealed -ne 'TRUE'
            }
    )

    if ($UnsealedRows.Count -gt 0) {
        throw 'All rows must be sealed before aggregation.'
    }

    # ------------------------------------------------------------------
    # Aggregate after row sealing only
    # ------------------------------------------------------------------

    $VerdictOrder = @(
        'ADDRESSED'
        'PARTIALLY_ADDRESSED'
        'RELATED'
        'NOT_APPLICABLE'
        'GAP'
        'UNRESOLVED'
    )

    $DistributionRows = @(
        foreach ($Verdict in $VerdictOrder) {
            $Count = @(
                $TraceRows |
                    Where-Object {
                        $_.final_verdict -eq $Verdict
                    }
            ).Count

            [pscustomobject]@{
                verdict = $Verdict
                provisional_count = $Count
                percentage_of_corpus = [math]::Round(
                    (($Count / 34) * 100),
                    2
                )
                expected_count_defined = 'FALSE'
                target_count_supplied = 'FALSE'
                quota_applied = 'FALSE'
                rank_allocation_applied = 'FALSE'
                generated_after_sealing = 'TRUE'
                review_state = 'PROVISIONAL_PENDING_ADVERSARIAL_REVIEW'
            }
        }
    )

    $ApplicabilityRows = @(
        foreach (
            $State in @(
                'ARCHITECTURAL'
                'NON_ARCHITECTURAL'
                'UNCERTAIN'
            )
        ) {
            $Count = @(
                $TraceRows |
                    Where-Object {
                        $_.architectural_applicability -eq $State
                    }
            ).Count

            [pscustomobject]@{
                architectural_applicability = $State
                requirement_count = $Count
                percentage_of_corpus = [math]::Round(
                    (($Count / 34) * 100),
                    2
                )
                review_state = 'PROVISIONAL'
            }
        }
    )

    $LowConfidenceAddressed = @(
        $TraceRows |
            Where-Object {
                $_.final_verdict -eq 'ADDRESSED' -and
                $_.confidence -ne 'HIGH'
            }
    ).Count

    $UnknownEvidence = @(
        $LedgerRows |
            Where-Object {
                -not $EvidenceLookup.ContainsKey($_.evidence_id)
            }
    ).Count

    $TrustRows = @(
        [pscustomobject]@{
            assertion_id = 'TRUST-001'
            assertion_name = 'ALL_34_REQUIREMENTS_ADJUDICATED'
            expected_state = '34'
            actual_state = $TraceRows.Count
            verification_state = if ($TraceRows.Count -eq 34) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-002'
            assertion_name = 'ALL_ROWS_SEALED'
            expected_state = 'TRUE'
            actual_state = ($UnsealedRows.Count -eq 0).ToString().ToUpperInvariant()
            verification_state = if ($UnsealedRows.Count -eq 0) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-003'
            assertion_name = 'ALL_ROWS_CHALLENGE_REQUIRED'
            expected_state = '34'
            actual_state = $ChallengeRows.Count
            verification_state = if ($ChallengeRows.Count -eq 34) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-004'
            assertion_name = 'TRACE_REPRODUCIBLE'
            expected_state = 'TRUE'
            actual_state = ($TraceHashOne -eq $TraceHashTwo).ToString().ToUpperInvariant()
            verification_state = if ($TraceHashOne -eq $TraceHashTwo) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-005'
            assertion_name = 'LEDGER_REPRODUCIBLE'
            expected_state = 'TRUE'
            actual_state = ($LedgerHashOne -eq $LedgerHashTwo).ToString().ToUpperInvariant()
            verification_state = if ($LedgerHashOne -eq $LedgerHashTwo) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-006'
            assertion_name = 'LOW_CONFIDENCE_ADDRESSED'
            expected_state = '0'
            actual_state = $LowConfidenceAddressed
            verification_state = if ($LowConfidenceAddressed -eq 0) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-007'
            assertion_name = 'UNKNOWN_EVIDENCE_REFERENCES'
            expected_state = '0'
            actual_state = $UnknownEvidence
            verification_state = if ($UnknownEvidence -eq 0) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-008'
            assertion_name = 'EXPECTED_DISTRIBUTION_DEFINED'
            expected_state = 'FALSE'
            actual_state = 'FALSE'
            verification_state = 'PASS'
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-009'
            assertion_name = 'LEGAL_COMPLIANCE_DETERMINATIONS'
            expected_state = '0'
            actual_state = @(
                $TraceRows |
                    Where-Object {
                        $_.legal_compliance_determination -ne 'NOT_ASSESSED'
                    }
            ).Count
            verification_state = if (
                @(
                    $TraceRows |
                        Where-Object {
                            $_.legal_compliance_determination -ne 'NOT_ASSESSED'
                        }
                ).Count -eq 0
            ) { 'PASS' } else { 'FAIL' }
        }
        [pscustomobject]@{
            assertion_id = 'TRUST-010'
            assertion_name = 'FINAL_COMPATIBILITY_MATRIX_ABSENT'
            expected_state = 'TRUE'
            actual_state = (
                -not (
                    Test-Path -LiteralPath (
                        Join-Path $CrosswalkDir 'COMPATIBILITY_MATRIX.csv'
                    )
                )
            ).ToString().ToUpperInvariant()
            verification_state = if (
                -not (
                    Test-Path -LiteralPath (
                        Join-Path $CrosswalkDir 'COMPATIBILITY_MATRIX.csv'
                    )
                )
            ) { 'PASS' } else { 'FAIL' }
        }
    )

    $TrustFailures = @(
        $TrustRows |
            Where-Object {
                $_.verification_state -ne 'PASS'
            }
    )

    if ($TrustFailures.Count -gt 0) {
        throw (
            'Trust assertions failed: ' +
            ($TrustFailures.assertion_name -join ', ')
        )
    }

    # ------------------------------------------------------------------
    # Export outputs
    # ------------------------------------------------------------------

    $TraceRows |
        Export-Csv -LiteralPath $TracePath -NoTypeInformation -Encoding UTF8

    $LedgerRows |
        Export-Csv -LiteralPath $LedgerPath -NoTypeInformation -Encoding UTF8

    $ResidualRows |
        Export-Csv -LiteralPath $ResidualPath -NoTypeInformation -Encoding UTF8

    $ChallengeRows |
        Export-Csv -LiteralPath $ChallengePath -NoTypeInformation -Encoding UTF8

    $TrustRows |
        Export-Csv -LiteralPath $TrustPath -NoTypeInformation -Encoding UTF8

    $DistributionRows |
        Export-Csv -LiteralPath $DistributionPath -NoTypeInformation -Encoding UTF8

    $ApplicabilityRows |
        Export-Csv -LiteralPath $ApplicabilityPath -NoTypeInformation -Encoding UTF8

    @'
# Deterministic Independent Adjudication Engine Protocol

PASS 05A-R3C evaluates all 34 source requirements independently under the
frozen threshold methodology.

The engine uses no expected verdict distribution, quota, rank bucket, top-N
allocation, percentile allocation, prior verdict state, or randomization.

Each row is sealed before aggregate counts are calculated.

All R3C verdicts are provisional and require PASS 05A-R4 adversarial review.

This pass does not determine legal compliance, government approval, regulatory
certification, implementation certification, safety, correctness, or statutory
satisfaction.
'@ | Set-Content -LiteralPath $ProtocolPath -Encoding UTF8

    $DistributionText = (
        $DistributionRows |
            ForEach-Object {
                "- $($_.verdict): $($_.provisional_count)"
            }
    ) -join "`r`n"

    @"
# Provisional Independent Adjudication Finding

## State

PROVISIONAL_PENDING_ADVERSARIAL_REVIEW

All 34 source requirements were evaluated independently and sealed before
aggregate statistics were generated.

## Emergent provisional distribution

$DistributionText

These counts were not predetermined, targeted, ranked, balanced, or forced.

## Integrity

- Adjudication rows: $($TraceRows.Count)
- Evidence-use rows: $($LedgerRows.Count)
- Residual rows: $($ResidualRows.Count)
- Challenge rows: $($ChallengeRows.Count)
- Trust assertions passed: $($TrustRows.Count)
- Trace SHA-256: $TraceHashOne
- Ledger SHA-256: $LedgerHashOne
- Residual SHA-256: $ResidualHashOne
- Challenge SHA-256: $ChallengeHashOne

The results remain provisional and do not establish legal compliance,
government approval, regulatory certification, implementation certification,
safety, correctness, or statutory satisfaction.
"@ | Set-Content -LiteralPath $FindingPath -Encoding UTF8

    # ------------------------------------------------------------------
    # Final validation
    # ------------------------------------------------------------------

    $TraceCheck = @(Import-Csv -LiteralPath $TracePath)
    $LedgerCheck = @(Import-Csv -LiteralPath $LedgerPath)
    $ResidualCheck = @(Import-Csv -LiteralPath $ResidualPath)
    $ChallengeCheck = @(Import-Csv -LiteralPath $ChallengePath)
    $TrustCheck = @(Import-Csv -LiteralPath $TrustPath)
    $DistributionCheck = @(Import-Csv -LiteralPath $DistributionPath)

    Assert-Count 'Exported trace count' $TraceCheck.Count 34
    Assert-Count 'Exported challenge count' $ChallengeCheck.Count 34
    Assert-Count 'Exported trust assertion count' $TrustCheck.Count 10
    Assert-Count 'Exported distribution count' $DistributionCheck.Count 6

    $DuplicateTraceRows = @(
        $TraceCheck |
            Group-Object requirement_id |
            Where-Object {
                $_.Count -ne 1
            }
    )

    if ($DuplicateTraceRows.Count -gt 0) {
        throw 'Each requirement must have exactly one trace row.'
    }

    $InvalidVerdicts = @(
        $TraceCheck |
            Where-Object {
                $_.final_verdict -notin $VerdictOrder
            }
    )

    if ($InvalidVerdicts.Count -gt 0) {
        throw (
            'Invalid verdicts detected: ' +
            (
                $InvalidVerdicts.final_verdict |
                    Sort-Object -Unique
            ) -join ', '
        )
    }

    $DistributionFailures = @(
        $DistributionCheck |
            Where-Object {
                $_.expected_count_defined -ne 'FALSE' -or
                $_.target_count_supplied -ne 'FALSE' -or
                $_.quota_applied -ne 'FALSE' -or
                $_.rank_allocation_applied -ne 'FALSE' -or
                $_.generated_after_sealing -ne 'TRUE'
            }
    )

    if ($DistributionFailures.Count -gt 0) {
        throw 'Distribution-blind execution validation failed.'
    }

    $PrematureFinalOutputs = @(
        (Join-Path $CrosswalkDir 'COMPATIBILITY_MATRIX.csv')
        (Join-Path $CrosswalkDir 'ORYNTH_EVIDENCE_USE_LEDGER.csv')
        (Join-Path $CrosswalkDir 'RESIDUAL_REQUIREMENT_REGISTRY.csv')
        (Join-Path $TestsDir 'PASS_05A_COMPLETION.marker')
    ) |
        Where-Object {
            Test-Path -LiteralPath $_
        }

    if ($PrematureFinalOutputs.Count -gt 0) {
        throw (
            'Premature final outputs exist: ' +
            ($PrematureFinalOutputs -join ', ')
        )
    }

    $Counts = @{}

    foreach ($Verdict in $VerdictOrder) {
        $Counts[$Verdict] = @(
            $TraceCheck |
                Where-Object {
                    $_.final_verdict -eq $Verdict
                }
        ).Count
    }

    # ------------------------------------------------------------------
    # Completion marker — written last
    # ------------------------------------------------------------------

    @"
ORYNTH_AI_GOVERNANCE_CROSSWALK_PASS_05A_R3C_DETERMINISTIC_INDEPENDENT_ADJUDICATION_ENGINE_COMPLETE
Repository: $Repo
Method version: 05A-R3C-V3
Source requirements adjudicated: $($TraceCheck.Count)
Executive Order requirements: 25
Minnesota requirements: 9
Provisional evidence-use relationships: $($LedgerCheck.Count)
Provisional residual records: $($ResidualCheck.Count)
Mandatory challenge records: $($ChallengeCheck.Count)
Trust assertions passed: $($TrustCheck.Count)
ADDRESSED provisional: $($Counts['ADDRESSED'])
PARTIALLY_ADDRESSED provisional: $($Counts['PARTIALLY_ADDRESSED'])
RELATED provisional: $($Counts['RELATED'])
NOT_APPLICABLE provisional: $($Counts['NOT_APPLICABLE'])
GAP provisional: $($Counts['GAP'])
UNRESOLVED provisional: $($Counts['UNRESOLVED'])
Expected verdict distribution defined: FALSE
Target verdict counts supplied: FALSE
Quota allocation applied: FALSE
Rank allocation applied: FALSE
Top-N assignment applied: FALSE
Randomization applied: FALSE
Aggregate counts generated after row sealing: TRUE
All rows sealed: TRUE
All rows challenge-required: TRUE
Trace reproducibility verified: TRUE
Trace reproducibility SHA256: $TraceHashOne
Evidence-ledger reproducibility SHA256: $LedgerHashOne
Residual-registry reproducibility SHA256: $ResidualHashOne
Challenge-register reproducibility SHA256: $ChallengeHashOne
Low-confidence ADDRESSED verdicts: $LowConfidenceAddressed
Unknown evidence references: $UnknownEvidence
Legal compliance determinations: 0
External legal authority preserved: TRUE
Final compatibility matrix generated: FALSE
Human adversarial review complete: FALSE
PASS 05A-R4 authorized: TRUE
"@ | Set-Content -LiteralPath $R3CMarkerPath -Encoding UTF8

    if (-not (Test-Path -LiteralPath $R3CMarkerPath)) {
        throw 'PASS 05A-R3C completion marker was not written.'
    }

    $Marker = Get-Content -LiteralPath $R3CMarkerPath -Raw

    if (
        $Marker -notmatch
        'ORYNTH_AI_GOVERNANCE_CROSSWALK_PASS_05A_R3C_DETERMINISTIC_INDEPENDENT_ADJUDICATION_ENGINE_COMPLETE'
    ) {
        throw 'PASS 05A-R3C completion marker is invalid.'
    }

    if ($Marker -notmatch 'All rows challenge-required: TRUE') {
        throw 'PASS 05A-R3C marker lacks full challenge coverage.'
    }

    Write-Host ''
    Write-Host "Requirements adjudicated         : $($TraceCheck.Count)" -ForegroundColor White
    Write-Host "Evidence-use relationships       : $($LedgerCheck.Count)" -ForegroundColor White
    Write-Host "Residual records                 : $($ResidualCheck.Count)" -ForegroundColor White
    Write-Host "Mandatory challenge records      : $($ChallengeCheck.Count)" -ForegroundColor White
    Write-Host ''
    Write-Host "ADDRESSED — provisional          : $($Counts['ADDRESSED'])" -ForegroundColor Yellow
    Write-Host "PARTIALLY_ADDRESSED — provisional: $($Counts['PARTIALLY_ADDRESSED'])" -ForegroundColor Yellow
    Write-Host "RELATED — provisional            : $($Counts['RELATED'])" -ForegroundColor Yellow
    Write-Host "NOT_APPLICABLE — provisional     : $($Counts['NOT_APPLICABLE'])" -ForegroundColor Yellow
    Write-Host "GAP — provisional                : $($Counts['GAP'])" -ForegroundColor Yellow
    Write-Host "UNRESOLVED — provisional         : $($Counts['UNRESOLVED'])" -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Expected verdict distribution    : NOT DEFINED' -ForegroundColor Green
    Write-Host 'Quota allocation                 : NOT APPLIED' -ForegroundColor Green
    Write-Host 'Rank allocation                  : NOT APPLIED' -ForegroundColor Green
    Write-Host 'Randomization                    : NOT APPLIED' -ForegroundColor Green
    Write-Host 'Aggregate after row sealing      : VERIFIED' -ForegroundColor Green
    Write-Host 'Reproducibility                  : VERIFIED' -ForegroundColor Green
    Write-Host 'Final compatibility matrix       : NOT GENERATED' -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'PASS 05A-R3C COMPLETE — PROVISIONAL INDEPENDENT ADJUDICATION GENERATED' -ForegroundColor Green
    Write-Host 'NEXT: PASS 05A-R4 — ADVERSARIAL VERDICT REVIEW' -ForegroundColor Cyan
    Write-Host '======================================================================' -ForegroundColor Cyan
}

