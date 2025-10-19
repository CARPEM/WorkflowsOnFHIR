Alias: $CarpemTransformation = https://interop.aphp.fr/ig/fhir/carpem/CodeSystem/CarpemTransformation
Alias: $action-type = http://terminology.hl7.org/CodeSystem/action-type

Instance: CarpemTNMCancerStaging
InstanceOf: PlanDefinition
Usage: #example
* url = "https://interop.aphp.fr/ig/fhir/carpem/PlanDefinition/CarpemTNMCancerStaging"
* version = "0.1.0"
* name = "CarpemTNMCancerStaging"
* title = "Carpem TNM Cancer Staging"
* status = #active
* date = "2025-10-18T18:55:05+00:00"
* publisher = "AP-HP"
* contact.name = "AP-HP"
* contact.telecom.system = #url
* contact.telecom.value = "https://aphp.fr"
* description = "PlanDefinition for TNM cancer staging workflow based on pathology reports, tumor board reports, and tumor board report documents. This workflow extracts TNM observations from multiple sources, consolidates them, and derives the final cancer stage."
* jurisdiction = urn:iso:std:iso:3166#FR "France"
* action.title = "TNM Cancer Staging Workflow"
* action.description = "Complete TNM cancer staging workflow that processes pathology reports, tumor board questionnaires, and tumor board report documents to derive cancer stage"
* action.code = $CarpemTransformation#CarpemTNMCancerStaging
* action.trigger.type = #named-event
* action.trigger.name = "tnm-staging-required"
* action.action[0].id = "parallel-extraction"
* action.action[=].title = "Parallel Data Extraction from Multiple Sources"
* action.action[=].description = "Extract TNM observations from pathology reports, tumor board questionnaires, and tumor board report documents in parallel"
* action.action[=].groupingBehavior = #logical-group
* action.action[=].selectionBehavior = #all
* action.action[=].action[0].title = "Process Pathology Report"
* action.action[=].action[=].groupingBehavior = #logical-group
* action.action[=].action[=].selectionBehavior = #all
* action.action[=].action[=].action[0].id = "struct-anapath"
* action.action[=].action[=].action[=].title = "Structure Pathology Report to FHIR"
* action.action[=].action[=].action[=].description = "Convert raw pathology text document to FHIR DocumentReference resource"
* action.action[=].action[=].action[=].code = $CarpemTransformation#STRUCT_PathologyToFHIR
* action.action[=].action[=].action[=].input.type = #DocumentReference
* action.action[=].action[=].action[=].output.type = #DocumentReference
* action.action[=].action[=].action[=].output.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/CarpemPathologyDocumentReference"
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[=].action[=].action[+].id = "extract-anapath"
* action.action[=].action[=].action[=].title = "Extract TNM from Pathology"
* action.action[=].action[=].action[=].description = "Extract TNM classification observations (T, N, M components) from structured pathology DocumentReference"
* action.action[=].action[=].action[=].code = $CarpemTransformation#EXTRACT_TNM_Pathology
* action.action[=].action[=].action[=].input.type = #DocumentReference
* action.action[=].action[=].action[=].input.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/CarpemPathologyDocumentReference"
* action.action[=].action[=].action[=].output.type = #Observation
* action.action[=].action[=].action[=].output.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].action[=].action[=].relatedAction.actionId = "struct-anapath"
* action.action[=].action[=].action[=].relatedAction.relationship = #after-start
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[=].action[+].title = "Process Tumor Board Questionnaire"
* action.action[=].action[=].groupingBehavior = #logical-group
* action.action[=].action[=].selectionBehavior = #all
* action.action[=].action[=].action[0].id = "struct-tumor-board"
* action.action[=].action[=].action[=].title = "Structure Tumor Board Questionnaire to FHIR"
* action.action[=].action[=].action[=].description = "Convert tabular tumor board questionnaire data to FHIR QuestionnaireResponse resources"
* action.action[=].action[=].action[=].code = $CarpemTransformation#STRUCT_TumorBoardToFHIR
* action.action[=].action[=].action[=].input.type = #QuestionnaireResponse
* action.action[=].action[=].action[=].output.type = #QuestionnaireResponse
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[=].action[=].action[+].id = "extract-tumor-board"
* action.action[=].action[=].action[=].title = "Extract TNM from Tumor Board"
* action.action[=].action[=].action[=].description = "Extract TNM classification observations from tumor board QuestionnaireResponse"
* action.action[=].action[=].action[=].code = $CarpemTransformation#EXTRACT_TNM_TumorBoard
* action.action[=].action[=].action[=].input.type = #QuestionnaireResponse
* action.action[=].action[=].action[=].output.type = #Observation
* action.action[=].action[=].action[=].output.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].action[=].action[=].relatedAction.actionId = "struct-tumor-board"
* action.action[=].action[=].action[=].relatedAction.relationship = #after-start
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[=].action[+].title = "Process Tumor Board Report Document"
* action.action[=].action[=].groupingBehavior = #logical-group
* action.action[=].action[=].selectionBehavior = #all
* action.action[=].action[=].action[0].id = "struct-tumor-board-report"
* action.action[=].action[=].action[=].title = "Structure Tumor Board Report Document to FHIR"
* action.action[=].action[=].action[=].description = "Convert tumor board report text document to FHIR DocumentReference resource"
* action.action[=].action[=].action[=].code = $CarpemTransformation#STRUCT_TumorBoardReportToFHIR
* action.action[=].action[=].action[=].input.type = #DocumentReference
* action.action[=].action[=].action[=].output.type = #DocumentReference
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[=].action[=].action[+].id = "extract-tumor-board-report"
* action.action[=].action[=].action[=].title = "Extract TNM from Tumor Board Report"
* action.action[=].action[=].action[=].description = "Extract TNM classification observations from tumor board report DocumentReference"
* action.action[=].action[=].action[=].code = $CarpemTransformation#EXTRACT_TNM_TumorBoardReport
* action.action[=].action[=].action[=].input.type = #DocumentReference
* action.action[=].action[=].action[=].output.type = #Observation
* action.action[=].action[=].action[=].output.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].action[=].action[=].relatedAction.actionId = "struct-tumor-board-report"
* action.action[=].action[=].action[=].relatedAction.relationship = #after-start
* action.action[=].action[=].action[=].type = $action-type#create
* action.action[+].id = "consolidate-tnm"
* action.action[=].title = "Consolidate TNM Observations"
* action.action[=].description = "Consolidate TNM observations extracted from pathology, tumor board, and tumor board report sources into a single unified TNM stage group observation"
* action.action[=].code = $CarpemTransformation#CONSOLID_TNM
* action.action[=].input[0].type = #Observation
* action.action[=].input[=].profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].input[+].type = #Observation
* action.action[=].input[=].profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].input[+].type = #Observation
* action.action[=].input[=].profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].output.type = #Observation
* action.action[=].output.profile = "https://interop.aphp.fr/ig/fhir/carpem/StructureDefinition/carpem-tnm-stage-group"
* action.action[=].relatedAction.actionId = "parallel-extraction"
* action.action[=].relatedAction.relationship = #after-end
* action.action[=].type = $action-type#create
