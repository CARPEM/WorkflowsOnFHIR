# PlanDefinition Reproducibility Analysis

## Overview

This document analyzes the reproducibility of PlanDefinition generation across 5 test files created on 2025-10-19.

**Overall Finding**: The generation process shows **POOR reproducibility** with inconsistencies across runs and a bug fix introduced mid-testing.

## Test Files

| File | Timestamp | Instance Name | Version |
|------|-----------|---------------|---------|
| PlanDefinition-CarpemTNMCancerStaging20251019-2237.fsh | 22:37 | CarpemTNMCancerStaging2 | - |
| PlanDefinition-CarpemTNMCancerStaging20251019-2249.fsh | 22:49 | CarpemTNMCancerStaging20251019 | - |
| PlanDefinition-CarpemTNMCancerStaging20251019-2254.fsh | 22:54 | CarpemTNMCancerStaging20251019v2 | v2 |
| PlanDefinition-CarpemTNMCancerStaging20251019-2259.fsh | 22:59 | CarpemTNMCancerStaging20251019v3 | v3 |
| PlanDefinition-CarpemTNMCancerStaging20251019-2301.fsh | 23:01 | CarpemTNMCancerStaging20251019v4 | v4 |

## Similarity Metrics

| Metric | Value |
|--------|-------|
| **Total lines per file** | 144 |
| **Structurally identical lines** | 139-140 (96.5-97.2%) |
| **Semantic similarity** | 97.2% (bug in first 2 files) |
| **Workflow logic similarity** | 100% |

## Exhaustive Difference Analysis

### All Differences Across Files

| Line | Field | File 2237 | File 2249 | File 2254 | File 2259 | File 2301 | Notes |
|------|-------|-----------|-----------|-----------|-----------|-----------|-------|
| **1** | Instance ID | `CarpemTNMCancerStaging2` | `CarpemTNMCancerStaging20251019` | `CarpemTNMCancerStaging20251019v2` | `CarpemTNMCancerStaging20251019v3` | `CarpemTNMCancerStaging20251019v4` | Unique identifiers |
| **3** | Title | `"Carpem TNM Cancer Staging"` | `"Carpem TNM Cancer Staging (2025-10-19)"` | `"Carpem TNM Cancer Staging (2025-10-19 v2)"` | `"Carpem TNM Cancer Staging (2025-10-19 v3)"` | `"Carpem TNM Cancer Staging (2025-10-19 v4)"` | Progressive versioning |
| **4** | Description | `"...documents."` | `"...documents. Generated from BPMN workflow on 2025-10-19."` | `"...documents. Generated from BPMN workflow on 2025-10-19."` | `"...documents. Generated from BPMN workflow on 2025-10-19."` | `"...documents. Generated from BPMN workflow on 2025-10-19."` | Metadata added from 2249+ |
| **7** | name property | `"CarpemTNMCancerStaging2"` | `"CarpemTNMCancerStaging20251019"` | `"CarpemTNMCancerStaging20251019v2"` | `"CarpemTNMCancerStaging20251019v3"` | `"CarpemTNMCancerStaging20251019v4"` | Mirrors Instance ID |
| **57** | Pathway 2 description | `"...to FHIR Observation"` ⚠️ | `"...to FHIR Observation"` ⚠️ | `"...to FHIR QuestionnaireResponse"` ✅ | `"...to FHIR QuestionnaireResponse"` ✅ | `"...to FHIR QuestionnaireResponse"` ✅ | **BUG FIXED** at 2254 |

### Detailed Line 57 Issue

**Location**: Pathway 2 → Tumor Board structuring action

**Incorrect** (files 2237, 2249):
```fsh
* description = "Structure tumor board report to FHIR Observation"
```

**Correct** (files 2254, 2259, 2301):
```fsh
* description = "Structure tumor board report to FHIR QuestionnaireResponse"
```

**Impact**: The description text was inconsistent with the actual output type defined on line 61 (`type = #QuestionnaireResponse`). This is a documentation error, not a functional error.

## Difference Categories

| Category | Lines Affected | Type | Impact |
|----------|----------------|------|--------|
| **Metadata/Naming** | 1, 3, 7 | Version identifiers | Cosmetic - no workflow impact |
| **Documentation** | 4 | Generation metadata | Added from file 2249 onwards |
| **Bug Fix** | 57 | Semantic correction | Corrected in files 2254+ |

## Evolution Across Runs

### Run 1 (22:37 - File 2237)
- Basic naming scheme (`CarpemTNMCancerStaging2`)
- No generation metadata
- **Contains line 57 documentation bug**

### Run 2 (22:49 - File 2249)
- Updated to date-based naming
- Added "Generated from BPMN workflow" metadata
- **Bug still present** (12 minutes after first run)

### Run 3 (22:54 - File 2254)
- Added version suffix (v2)
- **BUG FIXED** - Description now correctly states QuestionnaireResponse
- 5 minutes after Run 2

### Runs 4 & 5 (22:59, 23:01 - Files 2259, 2301)
- Sequential version increments (v3, v4)
- Bug fix persists
- Consistent with Run 3

## Reproducibility Issues Identified

### 1. Non-deterministic Naming
- First file uses different naming convention
- Inconsistent versioning scheme

### 2. Metadata Evolution
- Description field changed after first run
- Indicates generator configuration or code changes

## Workflow Structure Validation

Despite the differences, all files define **identical workflow structure**:

- ✅ 3 parallel pathways (Pathology, Tumor Board, Tumor Board Report Document)
- ✅ 6 processing actions (3 STRUCT + 3 EXTRACT)
- ✅ 2 gateway actions (split + join)
- ✅ 1 consolidation action
- ✅ All action IDs, relationships, and dependencies identical
- ✅ All FHIR resource types correctly specified
- ✅ All transformation codes consistent

## Conclusion

The **core workflow logic is 100% consistent**
