# Describing Data Processing in FHIR: AI-Assisted Interoperability

**Authors:** David OUAGNE<sup>1</sup>, Vincent ZOSSOU<sup>1</sup>, and Bastien RANCE<sup>1,2</sup>

**Affiliations:**
- <sup>1</sup> AP-HP, Paris, France
- <sup>2</sup> Centre de Recherche des Cordeliers, UMRS 1138, Université Paris Cité, Inserm, Sorbonne Université, Paris, France

**ORCID IDs:**
- David Ouagne: [0009-0001-4069-6124](https://orcid.org/0009-0001-4069-6124)
- Vincent Zossou: [0000-0001-7016-4455](https://orcid.org/0000-0001-7016-4455)
- Bastien Rance: [0000-0003-4417-1197](https://orcid.org/0000-0003-4417-1197)

---

## Summary

This study demonstrates the use of AI-assisted FHIR Implementation Guide authoring for documenting complex data transformation workflows in healthcare. Using TNM cancer staging as a use case, we explored how FHIR PlanDefinition resources can formalize the computational transformation process from raw clinical data to structured, actionable FHIR resources.

### Key Contributions

- **Novel Use of PlanDefinition:** We repurposed the FHIR PlanDefinition resource—traditionally used for care plans—to document and structure data transformation pipelines, representing sequences, dependencies, and conditions in analytical workflows.

- **Five-Category Framework:** Introduced a concise typology for organizing transformation processes: Structuration, Extraction, Normalization, Consolidation, and Derivation.

- **BPMN-to-FHIR Translation:** Developed a workflow using Business Process Model and Notation (BPMN) as a human-readable blueprint, which was then translated into formal FHIR PlanDefinition artifacts.

- **AI-Assisted Generation:** Leveraged Claude Code (Sonnet 4.5) to translate BPMN models into FHIR-compliant PlanDefinition resources in FSH format, requiring only 1-2 rounds of refinement to pass all validation controls.

### Methods

The approach involved creating BPMN diagrams to map the TNM staging workflow, documenting data sources and transformation steps, and using a structured prompting protocol to guide Claude Code in generating FHIR PlanDefinition resources. The generated artifacts were validated through syntax checking, Implementation Guide compilation, and expert review.

### Results & Impact

This work illustrates that AI can effectively translate conceptual models into formal FHIR structures, simplifying artifact generation, reducing costs in time and expertise, and assisting non-experts in adopting FHIR. The approach demonstrates how Generative AI can serve as a collaborative assistant in achieving transparent, reproducible, and semantically rich data transformation pipelines.

---

## FHIR Implementation Guide

The complete FHIR Implementation Guide with the generated PlanDefinition for TNM Cancer Staging is available at:

**[CARPEM Oncology Staging PlanDefinition](https://interop.aphp.fr/ig/fhir/carpem/PlanDefinition-CarpemOncologyStaging.html)**

---

## Claude Code Prompt

The following prompt was used to guide Claude Code in generating the FHIR PlanDefinition from the BPMN workflow model:

### Task: Generate FHIR PlanDefinition from BPMN Workflow

Generate a valid FHIR R4 PlanDefinition resource in FSH format by transforming the BPMN 2.0 workflow at `workflow/TNMCancerStaging.bpmn`.

#### Files to Work With

**Input:**
- `workflow/TNMCancerStaging.bpmn` - BPMN 2.0 XML workflow with cancer staging process

**Output:**
- `input/fsh/transformation-layer/plandefinitions/PlanDefinition-CarpemTNMCancerStaging.fsh` - New PlanDefinition in FSH format
- `input/fsh/transformation-layer/codesystems/CodeSystem-transformation.fsh` - Update with new code

#### Requirements

##### 1. Parse BPMN Workflow

- Read and analyze the BPMN XML structure
- Identify: tasks, gateways (Exclusive/Parallel), sequence flows, data associations
- Note 5 activity types: STRUCT, NORM, EXTRACT, CONSOLID, DERIVE
- **CRITICAL:** Extract text annotations associated with data objects
  - Text annotations contain resource type and profile information
  - Use `<bpmn:association>` elements to map data objects to their annotations
  - Parse multi-line annotations (e.g., "Resource: Observation\nProfile: TNM Stage Group")

##### 2. Transform BPMN to PlanDefinition

Apply these mapping rules (per [HL7 CQF Recommendations](https://build.fhir.org/ig/HL7/cqf-recommendations/documentation-methodology.html)):

- **BPMN Task** → PlanDefinition.action
- **BPMN ExclusiveGateway** → action with groupingBehavior=#logical-group, selectionBehavior=#exactly-one
- **BPMN ParallelGateway** → action with groupingBehavior=#logical-group, selectionBehavior=#all
- **BPMN SequenceFlow** → action.relatedAction with relationship type
- **BPMN dataInputAssociation** → action.input with:
  - Resource type from text annotation (required)
  - Profile canonical URL from text annotation (if specified)
- **BPMN dataOutputAssociation** → action.output with:
  - Resource type from text annotation (required)
  - Profile canonical URL from text annotation (if specified)
- **BPMN Process name** → id (kebab-case), name (PascalCase), title (same as process name)

##### Profile Extraction Algorithm:

1. For each dataInputAssociation/dataOutputAssociation, get the data object reference ID
2. Find the association linking the data object to a text annotation
3. Parse the annotation text:
   - Line starting with "Resource:" → extract FHIR resource type (e.g., "Observation", "DocumentReference")
   - Line starting with "Profile:" → extract profile name (e.g., "TNM Stage Group")
4. Convert profile name to canonical URL using project naming conventions
5. Add both type and profile to input/output elements in PlanDefinition

##### 3. Generate Complete PlanDefinition

Include all required elements:

**Metadata:**
- id, url, version, name, title, status, description

**Actions (for each BPMN task):**
- Unique action code
- title and description
- Sequencing via relatedAction
- Conditions for gateway paths
- Activity type mappings (STRUCT/NORM/EXTRACT/CONSOLID/DERIVE)
- **input/output based on data associations WITH profile information:**
  - Each input must specify: type (required), profile canonical URL (if annotated in BPMN)
  - Each output must specify: type (required), profile canonical URL (if annotated in BPMN)
  - Example: `* output[0].type = #Observation` AND `* output[0].profile[0] = Canonical(CarpemTNMStageGroup)`

##### 4. Update CodeSystem

Add new code to `CodeSystem-transformation.fsh` representing the TNM staging workflow

#### Success Criteria

✅ Valid FSH syntax (no parsing errors)
✅ Conforms to FHIR R4 PlanDefinition specification
✅ All BPMN elements translated to appropriate PlanDefinition structures
✅ Workflow sequence and logic preserved
✅ All codes and profiles validated and exist
✅ **Data inputs/outputs properly mapped WITH profiles:**
  - All data associations from BPMN have corresponding input/output in PlanDefinition
  - Resource types match BPMN text annotations exactly
  - Profile canonical URLs included for all annotated profiles
  - Profile names correctly converted to canonical URLs (e.g., "TNM Stage Group" → `Canonical(CarpemTNMStageGroup)`)

#### Constraints

- Do NOT execute or simulate the workflow
- Focus on structural transformation only
- Maintain traceability between BPMN and FHIR elements

#### References

- [FHIR R4 PlanDefinition](http://hl7.org/fhir/R4/plandefinition.html)
- [FSH Spec](https://build.fhir.org/ig/HL7/fhir-shorthand/reference.html)
- [BPMN-to-PlanDefinition](https://build.fhir.org/ig/HL7/cqf-recommendations/documentation-methodology.html)

---

## Contact

For more information or to cite this work, please contact:
**David Ouagne:** [david.ouagne@aphp.fr](mailto:david.ouagne@aphp.fr)
